require 'active_support/core_ext/object/blank'

module Psychick
  class URL < String
    # TODO: There's probably something better in an existing URL parsing library
    # that pays more attention to RFCs that we could "borrow".
    EXTENSION_REG = /\.[a-zA-Z0-9]{1,5}(?=(\?|$))/

    # TODO: Move this into a more appropriate place, and make it configurable
    RESERVED_PARAMS = [
      /^\w*(id|Id|ID)$/,                # anything ending in "id", which produces some false positives
      /^[a-zA-Z]$/,                     # single character parameters
      /^(action|article|page|view)$/i   # words that signify selecting the content
    ]

    # Tests
    def has_path?
      without_query_string.without_trailing_slash.split('://', 2)[1].match /\//
    end

    def has_trailing_slash?
      has_path? && end_with?('/')
    end

    def has_query_string?
      include? '?'
    end

    def has_extension?
      without_query_string.extension.present?
    end

    # Uses the above set of regular expressions to determine
    def has_reserved_param?
      reserved_params.any?
    end

    def secure?
      start_with? 'https'
    end

    def has_www?
      split(/(\/\/|\.)/).include? 'www'
    end

    # Selectors
    def query_string
      split('?', 2)[1].to_s
    end

    def host
      split('?', 2).first.to_s
    end

    def params
      query_string.split('&').reduce({}) { |params, kv|
        k, v = kv.split('=')
        params[k] = v
        params
      }
    end

    def reserved_params
      params.select { |k, v| RESERVED_PARAMS.any? { |pattern| pattern =~ k } || v.blank? }
    end

    def extension
      (ext = self[EXTENSION_REG]) && ext.to_s
    end

    # Mutators
    def without_trailing_slash
      without_query_string.chomp('/') + query_string_from_params(params)
    end

    def with_trailing_slash
      without_query_string << '/' << query_string_from_params(params)
    end

    def without_query_string
      split('?', 2).first
    end

    def without_extension
      sub /\.[a-zA-Z0-9]{1,5}(?=(\?|$))/, ''
    end

    def without_unreserved_params
      without_query_string << query_string_from_params(reserved_params)
    end

    def with_ssl
      sub 'http', 'https'
    end

    def without_ssl
      sub 'https', 'http'
    end

    def with_www
      has_www? ? self : sub('://', '://www.')
    end

    def without_www
      without_query_string.sub('www.', '') << query_string_from_params(params)
    end

  private
    def query_string_from_params(params)
      qs = params.map { |k,v| v ? "#{k}=#{v}" : k }.join('&')
      qs = "?#{qs}" unless qs.blank?
      qs
    end
  end
end
