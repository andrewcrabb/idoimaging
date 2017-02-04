require 'test_helper'
require_relative './author_test'

class ProgramTest < ActiveSupport::TestCase

  NPROG = 3

  def setup
  @programs = []
  @authors = []
    @nbefore = Program.count
    assert_difference 'Program.count', NPROG do
      NPROG.times { |i| @programs << Program.create!(name: "program#{i}", summary: "summary#{i}", add_date: Date.today ) }
    end
    assert_difference 'Author.count', NPROG do
      NPROG.times { |i| @authors << Author.create!(name_last: "author_last#{i}", name_first: "author_first#{i}", email: "author#{i}@foo.com" ) }
    end
  end

  test "Ensure name is present" do
    program = Program.new
    assert_not program.save, "Saved the program without a name"
  end

  test "Insert programs, test add and remove dates" do
    assert_equal(NPROG  , Program.active.count)
    assert_equal(@nbefore, Program.inactive.count)
    assert_difference('Program.active.count', -1) do
      p = Program.find_by(name: 'program0')
      p.remove_date = Date.today
      p.save
    end
  end

  test "Associate program with author" do
  	@programs[0].authors << @authors[0]
  	@programs[1].authors << @authors[0]
  	@programs[1].authors << @authors[1]
    Rails.logger.error("programs[0] authors: #{@programs[0].authors.pluck(:id)}")
    Rails.logger.error("programs[1] authors: #{@programs[1].authors.pluck(:id)}")
  	assert_equal(1, @programs[0].authors.count)
  	assert_equal(2, @programs[1].authors.count)
  	assert_equal(2, @authors[0].programs.count)
  	assert_equal(1, @authors[1].programs.count)
    # Delete associations only:
    # Program.find(6).authors.delete_all
  end



end
