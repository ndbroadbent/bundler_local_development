#
# Provides a simple way to switch between local and installed gems.
#
# * Call `Bundler.development_gems=[]` in your Gemfile, to configure
# the default set of gems to override with local copies.
# * Set $DEVELOPMENT_GEMS to add extra gems to this list.
#
# If the $GEM_DEV environment variable is set, bundler will search for gems in the
# path specified by $GEM_DEV_DIR (or $HOME/code/gems if not set.)

module Bundler
  class << self
    def development_gems=(search_strings)
      @@development_gems = [search_strings].flatten
    end
    def development_gems
      # If $DEV_GEMS is provided, append to @@development_gems
      if ENV['DEV_GEMS']
        (@@development_gems ||= []) +
        ENV['DEV_GEMS'].to_s.split(';').map(&:strip).select{|s| s != "" }
      # Otherwise, default is to make all gems local
      else
        @@development_gems ||= [:all]
      end
    end
  end

  class Dsl
    alias :gem_without_development :gem
    def gem_with_development(name, *args)
      if ENV['GEM_DEV']
        if Bundler.development_gems == [:all] || Bundler.development_gems.any?{ |s| name[s] }
          gem_development_dirs.each do |dir|
            path = File.join(dir, name)
            if File.exist?(path)
              # Check each local gem's gemspec to see if any dependencies need to be made local
              gemspec_path = File.join(dir, name, "#{name}.gemspec")
              process_gemspec_dependencies(gemspec_path) if File.exist?(gemspec_path)
              return gem_without_development name, :path => path
            end
          end
        end
      end
      gem_without_development(name, *args)
    end
    alias :gem :gem_with_development

    private
    # Returns local gem dirs from ENV or default
    def gem_development_dirs
      @gem_development_dirs ||= if ENV['GEM_DEV_DIR']
        ENV['GEM_DEV_DIR'].split(';')
      else
        ["#{`echo $HOME`.strip}/code/gems"]
      end
    end

    def process_gemspec_dependencies(gemspec_path)
      spec = Bundler.load_gemspec(gemspec_path)
      spec.runtime_dependencies.each do |dep|
        gem_development_dirs.each do |dir|
          path = File.join(dir, dep.name)
          if File.exist?(path)
            gem_without_development(dep.name, :path => path)
            break  # Process next dependency
          end
        end
      end
    end
  end

  class Definition
    # Don't update Gemfile.lock when developing with local gems
    alias :lock_original :lock
    def lock(*args)
      lock_original(*args) unless ENV['GEM_DEV']
    end
  end
end
