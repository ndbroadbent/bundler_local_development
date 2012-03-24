# Bundler - Local Development

### Provides a simple way to switch between local and installed gems.

Since this gem overrides bundler itself, it is installed and required in an unusual way.
It is required *within* your Gemfile, and is not meant to be used in your application.

## Installation

Add these lines to your application's Gemfile:

    gem 'bundler_local_development', :group => :development, :require => false
    begin
      require 'bundler_local_development'
      Bundler.development_gems = [/foo/, 'bar', /baz/]
    rescue LoadError
    end

And then execute:

    $ bundle


## Usage

* Call `Bundler.development_gems = [...]` in your Gemfile, to configure
  your default set of local gems.
  You can provide regular expressions or strings to match gem names.
* Set the `$DEV_GEMS` environment variable to add extra gems to this list (comma separated list of gem names).

If the `$GEM_DEV` environment variable is unset, this gem will do nothing.

If the `$GEM_DEV` environment variable is set:

* Bundler will search for local gems in the
path specified by `$GEM_DEV_DIR`. (The default search path is `$HOME/code/gems`, if `$GEM_DEV_DIR` is unset.)

* If a local copy of the gem is found, it will add the `:path => <path>`
option to the `gem` command.


## Shell shortcut

In order to make the most of this gem, you need a quick way to enable or disable it.

Add the following function to your `~/.bashrc` or `~/.zshrc`:

```bash
# Gem development shortcuts
# Toggle between gem development and production mode
# (Set / unset $GEM_DEV variable)
gdv() {
  local flag_var="GEM_DEV"
  if env | grep -q "^$flag_var="; then
    unset $flag_var
  else
    export $flag_var=true
  fi
}
```

Now you will be able to enable or disable the gem by typing: `gdv`


## Indicator in Shell Prompt

Finally, you might want to know whether or not the gem is enabled.

Add the following function to your `~/.bashrc` or `~/.zshrc`:

```bash
# When developing gems ($GEM_DEV is exported), display a hammer and pick
parse_gem_development() {
  if env | grep -q "^GEM_DEV="; then echo "\[\e[0;33m\]⚒ "; fi
}
```

Then, use `$(parse_gem_development)` to display the indicator in your prompt.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
