require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  NPROG = 3

  FEATURE_TYPES = %w(speciality language interface)

  def setup
    assert_difference "Program.count", NPROG do
      NPROG.times { |i| Program.create!(name: "program#{i}", summary: "summary#{i}", add_date: Date.today ) }
    end
    FEATURE_TYPES.each do |ftype|
      assert_difference "Feature.count", NPROG do
        NPROG.times { |i| Feature.create!(name: ftype, value: "#{ftype}#{i}" ) }
      end

    end
  end

  test "Find seed languages" do
    langs0 = Feature.where(name: 'language', value: 'language0')
    assert_equal(1, langs0.count)
  end

  test "Add features to programs" do
    p0 = Program.find_by(name: 'program0')
    p1 = Program.find_by(name: 'program1')
    s0 = Feature.find_by(name: 'speciality', value: 'speciality0')
    l0 = Feature.find_by(name: 'language', value: 'language0')
    i0 = Feature.find_by(name: 'interface', value: 'interface0')
    assert_equal(0, s0.programs.count)
    p0.features << s0
    assert_equal(1, s0.programs.count)
    assert_equal(1, p0.features.count)
    assert_equal(p0.features.first.id, s0.id)
  end

end
