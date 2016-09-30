# [ParallelMap](https://github.com/aemadrid/parallel_map) [![Build Status](https://travis-ci.org/aemadrid/parallel_map.svg?branch=master)](https://travis-ci.org/aemadrid/parallel_map)

This Ruby gem adds a parallel map method to any Enumerable (notably including any Array). 

* _pmap_ parallel map

It is implemented using [Concurrent](http://www.concurrent-ruby.com/) 
[Futures](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Future.html)
 so that it uses threads to run your map in parallel. 
 All limitations of Concurrent::Future apply here.
 
ParallelMap was heavily inspired by [pmap](https://github.com/bruceadams/pmap) so a lot of credit
goes to [bruceadams](https://github.com/bruceadams). 
One small difference with [pmap](https://github.com/bruceadams/pmap) 
is that [ParallelMap](https://github.com/aemadrid/parallel_map)
does not patch Enumerable by default. 
You need to decide if you want to patch Enumerable or only other classes like Array or Range.

```ruby
# Patch Enumerable and all its descendants
ParallelMap.patch_enumerable

# Or patch any other class/module directly
ParallelMap.patch Array
```
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parallel_map'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parallel_map

## Usage

Paraphrasing [pmap]((https://github.com/bruceadams/pmap#example)) let's
suppose that we have a function `get_quote` that calls out to a stock
quote service to get a current stock price. The response time for
`get_quote` ranges averages 0.5 seconds.
 
```ruby
# We will only patch Array for now
ParallelMap.patch Array

# We'll gather the stock symbols
stock_symbols = [:ibm, :goog, :appl, :msft, :hp, :orcl]

# This will take about three seconds; an eternity if you want to render a web page.
stock_quotes = stock_symbols.map { |s| get_quote(s) }

# Instead we can use pmap and this whole process will take as much as the slowest of all the calls.
stock_quotes = stock_symbols.pmap { |s| get_quote(s) }
```    

## General Considerations 
 
Threading in Ruby is heavily dependent on the Ruby VM you are using. 
I will quote [pmap](https://github.com/bruceadams/pmap) on its 
[general limitations](https://github.com/bruceadams/pmap#threading-in-ruby-has-limitations)
and its [usefulness](https://github.com/bruceadams/pmap#threading-useful-for-remote-io-such-as-http).

> Threading in Ruby has limitations.
> ----------------------------------
> 
> Matz Ruby 1.8.* uses _green_ threads. All Ruby threads are run within
> a single thread in a single process. A single Ruby program will never
> use more than a single core of a mutli-core machine.
> 
> Matz Ruby 1.9.* uses _native_ threads. Each Ruby thread maps directly
> to a thread in the underlying operating system. In theory, a single
> Ruby program can use multpile cores. Unfortunately, there is a global
> interpreter lock _GIL_ that causes single-threaded behavior.
> 
> JRuby also uses _native_ threads. JRuby avoids the global interpreter
> lock, allowing a single Ruby program to really use multiple CPU cores.
> 
> Threading useful for remote IO, such as HTTP
> --------------------------------------------
> 
> Despite the Matz Ruby threading limitations, IO bound actions can
> greatly benefit from multi-threading. A very typical use is making
> multiple HTTP requests in parallel. Issuing those requests in separate
> Ruby threads means the requests will be issued very quickly, well
> before the responses start coming back. As responses come back, they
> will be processed as they arrive.
>
  
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/parallel_map. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
