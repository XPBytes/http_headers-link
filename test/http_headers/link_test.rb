require 'test_helper'

module HttpHeaders
  class LinkTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::HttpHeaders::Link::VERSION
    end

    def test_it_parses_empty
      Link.new('')
      pass 'did not break'
    end

    def test_it_parses_one
      list = Link.new('<https://domain.tld/path/to/api/resource/id>; rel=self')
      assert_equal 1, list.length
      assert_equal '<https://domain.tld/path/to/api/resource/id>; rel=self', list.first.to_s
    end

    def test_it_parses_parameters
      list = Link.new('<https://domain.tld/path/to/api/resource/id>; rel=self; foo=bar')
      assert_equal 1, list.length
      assert_equal 'bar', list.first[:foo]
      assert_equal 'self', list.first.rel
      assert_equal 'https://domain.tld/path/to/api/resource/id', list.first.href
    end

    def test_it_parses_multiple_lines
      list = Link.new([
        '<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a/reviews>; rel=reviews',
        '<https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a>; rel=self',
        '<https://domain.tld/deploy/path/api/authors/78eb296b-6942-40ea-be0d-d702c0564b31>; rel=author'
      ])
      assert_equal 3, list.length
      assert_equal 'reviews', list.first.rel
      assert_equal '<https://domain.tld/deploy/path/api/authors/78eb296b-6942-40ea-be0d-d702c0564b31>; rel=author', list.last.to_s
      assert_equal 'https://domain.tld/deploy/path/api/books/aad2a2f-84e9-4b33-a718-8095262def9a', list[:self].href
      assert_equal list[1], list[:self]
    end
  end
end
