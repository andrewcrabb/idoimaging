require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  NAUTH = 3

  def create_authors(n = NAUTH)
    @nbefore = Author.count
    assert_difference 'Author.count', n do
      n.times { |i| Author.create!(name_last: "author_last#{i}", name_first: "author_first#{i}", email: "author#{n}@foo.com" ) }
    end
  end

  test "Ensure name is present" do
    author = Author.new
      assert_not author.save, "Saved the author without a name or institution"
  end

  test "Ensure valid names OK" do
    author = Author.new(name_last: 'Last1')
    assert author.save, "Saved the author with a name"
    author = Author.new(institution: 'Institution1')
    assert author.save, "Saved the author with an institution"
  end

end
