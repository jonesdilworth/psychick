require 'psychick/version'
require 'psychick/url'

module Psychick
  AVAILABLE_STRATEGIES = :remove_extension, :reduce_query_string, :toggle_ssl, :toggle_trailing_slash, :toggle_www

  # TODO: Documentation
  def self.alternates(url, options = {})
    url = URL.new(url)

    strategies = AVAILABLE_STRATEGIES
    strategies -= options[:skip] || []
    alternates = []

    # To get all combinations, we need permutations of 1..n strategies
    1.upto(strategies.count) do |n|
      strategies.permutation(n) do |steps|
        # TODO: This is a little dense and unclear; modification functions
        #   should be acting on an object other than the one passed, probably.
        #   Consider refactoring and extracting to an alternate object.
        alternates |= [steps.reduce(url) { |url, modification| send(modification, url) }]
      end
    end

    alternates
  end

  # Manipulation strategies
  def self.reduce_query_string(url)
    if url.has_query_string?
      url.has_reserved_param? ? url.without_unreserved_params : url.without_query_string
    else
      url
    end
  end

  def self.remove_extension(url)
    url.without_extension
  end

  def self.toggle_trailing_slash(url)
    if url.has_trailing_slash?
      url.without_trailing_slash
    else
      url.has_query_string? ? url : url.with_trailing_slash
    end
  end

  def self.toggle_ssl(url)
    url.secure? ? url.without_ssl : url.with_ssl
  end

  def self.toggle_www(url)
    url.has_www? ? url.without_www : url.with_www
  end
end
