# Psychick

Psychick uses her crystal ball to predict alternate URLs.

## Usage

```ruby
Psychick.alternates('http://google.com/search?q=cookie+monster&lang=en')
# =>
[
  "http://google.com/search?q=cookie+monster&lang=en",      # original
  "http://google.com/search?q=cookie+monster",              # rm unimportant params
  "https://google.com/search?q=cookie+monster&lang=en",     # ssl
  "http://www.google.com/search?q=cookie+monster&lang=en",  # add www
  "https://google.com/search?q=cookie+monster",             # ssl; rm unimportant params
  "http://www.google.com/search?q=cookie+monster",          # add www; rm unimportant params
  "https://www.google.com/search?q=cookie+monster&lang=en", # ssl; add www
  "https://www.google.com/search?q=cookie+monster"          # ssl; add www; rm unimportant params
]
```

## Installation

If you haven't figured out how to install a gem, listen up:

Add this line to your application's Gemfile:

    gem 'psychick'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psychick

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
