# HttpHeaders::Link

[![Build Status: master](https://travis-ci.com/XPBytes/http_headers-link.svg)](https://travis-ci.com/XPBytes/http_headers-link)
[![Gem Version](https://badge.fury.io/rb/http_headers-link.svg)](https://badge.fury.io/rb/http_headers-link)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

:nut_and_bolt: Utility to parse, sort and generate the "Link" HTTP Header

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_headers-link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_headers-link

## Usage

You can parse the "Link" header. As per the RFCs, you should really have one (delimited) value but the current 
implementation links an array of values.

```ruby
require 'http_headers/link'

value = '
<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a/reviews>; rel=reviews, 
<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a>; rel=self, 
<https://domain.tld/deploy/path/api/authors/78eb296b-6942-40ea-be0d-d702c0564b31>; rel=author
'.trim

parsed = HttpHeaders::Link.new(value)
parsed[:self].to_s
# => '<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a>; rel=self' 
parsed.last.rel
# => author
 
parsed = HttpHeaders::Link.new([
  '<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a>; rel=book, foo=bar', 
  '<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a/signatures/219472931>; rel=self'
])
parsed.first[:foo]
# => bar
parsed.last.href
# => 'https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a/signatures/219472931'
```

Each parsed entry exposes the following methods:
- `href`: the parsed href to the link
- `rel`: the quality parameter as float, or 1.0
- `templated?`: true if there is a parameter `templated` that is `true`
- `[](parameter)`: accessor for the parameter; throws if it does not exist
- `to_s`: encode back to an entry to be used in a `Link` header

The resulting collection works both as an `Array` and `Hash` by `rel`.

## Related

- [HttpHeaders::Utils](https://github.com/XPBytes/http_headers-utils): :nut_and_bolt: Utility belt for the HttpHeader libraries
- [HttpHeaders::Accept](https://github.com/XPBytes/http_headers-accept): :nut_and_bolt: Utility to parse and sort the "Accept" HTTP Header
- [HttpHeaders::AcceptLanguage](https://github.com/XPBytes/http_headers-accept_language): :nut_and_bolt: Utility to parse and sort the "Accept-Language" HTTP Header

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [XPBytes/http_headers-link](https://github.com/XPBytes/http_headers-link).
