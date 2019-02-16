require 'http_headers/link/version'
require 'http_headers/utils/list'

module HttpHeaders
  class Link # < DelegateClass(Array) defined by version
    def initialize(value)
      __setobj__ HttpHeaders::Utils::List.new(value, entry_klazz: Link::Entry)
      indexify!
    end

    alias_method :indexed, :[]
    def [](name)
      lookup.fetch(String(name).to_sym) do
        indexed(name)
      end
    end

    class Entry
      def initialize(href, index:, parameters:)
        self.href = href[1...-1]
        self.parameters = parameters
        self.index = index

        freeze
      end

      attr_reader :href, :index

      # noinspection RubyInstanceMethodNamingConvention
      def rel
        parameters.fetch(:rel) { nil }
      end

      def <=>(other)
        index <=> other.index
      end

      def [](parameter)
        parameters.fetch(String(parameter).to_sym)
      end

      def to_header
        to_s
      end

      def to_s
        ["<#{href}>"].concat(parameters.map { |k, v| "#{k}=#{v}" }).compact.reject(&:empty?).join('; ')
      end

      private

      attr_writer :href, :index
      attr_accessor :parameters
    end

    private

    def indexify!
      self.lookup = each_with_object({}) do |entry, result|
        result[entry.rel&.to_sym] = entry
      end
    end

    attr_accessor :lookup
  end
end
