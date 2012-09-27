require 'spec_helper'

describe Psychick::URL do
  context 'parsing' do
    context 'without a path, extension, or parameters' do
      subject { Psychick::URL.new 'http://www.google.com/' }

      it { should_not have_path }
      it { should_not have_trailing_slash }
      it { should_not have_query_string }
      it { should_not have_extension }
      it { should_not have_reserved_param }
      it { should_not be_secure }
      it { should have_www }

      its(:extension) { should be_nil }
    end

    context 'with path and no parameters' do
      subject { Psychick::URL.new 'http://www.cnn.com/world/2012/09/18/someone-is-so-cool/' }

      it { should have_path }
      it { should have_trailing_slash }
      it { should have_www }
      it { should_not have_query_string }
      it { should_not have_reserved_param }
      it { should_not be_secure }
      it { should_not have_extension }
    end

    context 'with q parameter' do
      subject { Psychick::URL.new 'https://google.com/?q=super+duper' }

      it { should have_query_string }
      it { should have_reserved_param }
      it { should be_secure }

      it { should_not have_path}
      it { should_not have_trailing_slash }
      it { should_not have_extension }
      it { should_not have_www }
    end

    context 'with multiple params, including complex identifying parameter' do
      subject { Psychick::URL.new 'http://search.google.com/search?lang=en&lat=123.12312312&long=-12.131231&queryID=super+duper' }

      it { should have_query_string }
      it { should have_reserved_param }
      it { should have_path}

      it { should_not have_trailing_slash }
      it { should_not have_extension }
      it { should_not be_secure }
      it { should_not have_www }

      its(:query_string) { should eq 'lang=en&lat=123.12312312&long=-12.131231&queryID=super+duper' }
    end

    context 'with a path and extension' do
      subject { Psychick::URL.new 'https://www.google-de-googs.co.uk/yahoo.php' }

      it { should have_path }
      it { should have_extension }
      it { should be_secure }
      it { should have_www }

      it { should_not have_query_string }
      it { should_not have_trailing_slash }
      it { should_not have_reserved_param }
      its(:extension) { should eq '.php' }
    end

    context 'with path, extension, and non-identifying parameter' do
      subject { Psychick::URL.new 'http://goog.le/maps/find/googleplex.html?ref=123456' }

      it { should have_path }
      it { should have_extension }
      it { should have_query_string }

      it { should_not have_trailing_slash }
      it { should_not have_reserved_param }
      it { should_not have_www }

      its(:extension) { should eq '.html' }
      its(:query_string) { should eq 'ref=123456' }
      its(:params) { should == {'ref' => '123456'} }
    end
  end

  context 'manipulation' do
    let(:url) { Psychick::URL.new 'http://www.google.com/search.php?q=foobar&lang=en' }
    let(:alt_url) { Psychick::URL.new 'https://google.com/news/2012/01/04/someone-is-so-cool/' }

    it 'should remove the query string' do
      url.without_query_string.should == 'http://www.google.com/search.php'
    end

    it 'should remove extension' do
      url.without_extension.should == 'http://www.google.com/search?q=foobar&lang=en'
      alt_url.without_extension.should == alt_url
    end

    it 'should remove unimportant parameters' do
      url.without_unreserved_params.should == 'http://www.google.com/search.php?q=foobar'
      alt_url.without_unreserved_params.should == alt_url
    end

    it 'should add a trailing slash' do
      url.without_trailing_slash.should == url
      alt_url.without_trailing_slash.should == 'https://google.com/news/2012/01/04/someone-is-so-cool'
    end

    it 'should chain manipulators' do
      url.without_extension.without_query_string.without_www.without_unreserved_params.with_trailing_slash.should == 'http://google.com/search/'
      url.with_ssl.without_ssl.should == url
      url.with_trailing_slash.without_trailing_slash.should == url
    end

    it 'should add https' do
      url.with_ssl.should start_with 'https'
    end

    it 'should remove https' do
      alt_url.without_ssl.should start_with 'http'
    end

    it 'should add www' do
      url.should have_www
      alt_url.with_www.should have_www
    end

    it 'should remove www' do
      url.without_www.should_not have_www
      alt_url.should_not have_www
    end

    it 'should not remove a trailing slash from a query string' do
      url = Psychick::URL.new('http://www.google.com/search?q=foo/')
      url.without_trailing_slash.should == url
    end

    it 'should not remove parameters without values' do
      url = Psychick::URL.new('http://google.com/?en')
      url.without_unreserved_params.should == url
    end
  end

end
