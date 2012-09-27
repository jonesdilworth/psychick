require 'spec_helper'

describe Psychick do
  context 'alternates' do
    # This tests that everything cumulatively works, but we could use individual
    # tests that show that each strategy works alone, too, especially since
    # that's supported
    it 'should provide alternates' do
      Psychick.alternates('http://www.google.com/search.php?q=foo+bar&lang=en').sort.should eq [
        "http://google.com/search.php?q=foo+bar",
        "http://google.com/search.php?q=foo+bar&lang=en",
        "http://google.com/search?q=foo+bar",
        "http://google.com/search?q=foo+bar&lang=en",
        "http://www.google.com/search.php?q=foo+bar",
        "http://www.google.com/search.php?q=foo+bar&lang=en",
        "http://www.google.com/search?q=foo+bar",
        "http://www.google.com/search?q=foo+bar&lang=en",
        "https://google.com/search.php?q=foo+bar",
        "https://google.com/search.php?q=foo+bar&lang=en",
        "https://google.com/search?q=foo+bar",
        "https://google.com/search?q=foo+bar&lang=en",
        "https://www.google.com/search.php?q=foo+bar",
        "https://www.google.com/search.php?q=foo+bar&lang=en",
        "https://www.google.com/search?q=foo+bar",
        "https://www.google.com/search?q=foo+bar&lang=en"
      ]
    end
  end
end
