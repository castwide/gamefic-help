# Gamefic::Help

A Gamefic extension to implement help commands.

## Usage

Add the gem to your project's Gemfile:

```ruby
gem 'gamefic-help'
```

Include the `Gamefic::Remarkable` module in your project's `Plot`:

```ruby
module MyGame
  class Plot < Gamefic::Plot
    include Gamefic::Standard
    include Gamefic::Help

    # ...
  end
end
```

In the game, the `help` command will provide some basic instructions and a list of known verbs (and verb synonyms). Players can request more information about a verb by entering `help [verb]`.

Authors can add an explanation for a verb with the `explain` method:

```ruby
module MyGame
  class Plot < Gamefic::Plot
    include Gamefic::Help

    script do
      respond :think do |actor|
        actor.tell 'You ponder your predicament.'
      end

      explain :think, 'Take a moment to ponder your predicament.'
    end
  end
end
```

Example of gameplay:

    > help

    I understand the following commands: think.

    > help think

    Take a moment to ponder your predicament.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gamefic-help.
