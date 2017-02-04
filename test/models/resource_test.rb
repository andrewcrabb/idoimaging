require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  NPROG = 3

  def setup
    @nbefore = Program.count
    assert_difference 'Program.count', NPROG do
      NPROG.times { |i| Program.create!(name: "program#{i}", summary: "summary#{i}", add_date: Date.today ) }
    end
    assert_difference 'Author.count', NPROG do
      NPROG.times { |i| Author.create!(name_last: "author_last#{i}", name_first: "author_first#{i}", email: "author#{i}@foo.com" ) }
    end
    assert_difference 'Resource.count', NPROG do
      NPROG.times { |i| Resource.create!( url: "resource#{i}" ) }
    end
  end

  test "Assign resources to program and author" do
    p0 = Program.find_by(name: "program0")
    a0 = Author.find_by(name_last: "author_last0")
    p0.resources << Resource.find_by(url: "resource0")
    a0.resources << Resource.find_by(url: "resource1")
    a0.resources << Resource.find_by(url: "resource2")
    assert_equal(1, Program.find_by(name: "program0").resources.count)
    assert_equal(2, Author.find_by(name_last: "author_last0").resources.count)
  end

end
