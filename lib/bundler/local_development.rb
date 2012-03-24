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
      @@development_gems = search_strings
    end
    def development_gems
      (@@development_gems ||= []) +
      ENV['DEV_GEMS'].to_s.split(',').map(&:strip).select{|s| s != "" })
    end
  end

  class Dsl
    alias :gem_without_development :gem
    def gem_with_development(name, *args)
      if ENV['GEM_DEV'] && Bundler.development_gems.any?{ |s| name[s] }
        gem_dev_dir = ENV['GEM_DEV_DIR'] || "#{`echo $HOME`.strip}/code/gems"
        path = File.join(gem_dev_dir, name)
        if File.exist?(path)
          return gem_without_development name, :path => path
        end
      end
      gem_without_development(name, *args)
    end
    alias :gem :gem_with_development
  end
end
