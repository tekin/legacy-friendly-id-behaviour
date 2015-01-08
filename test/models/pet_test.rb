require 'test_helper'

class PetTest < ActiveSupport::TestCase
  test 'allows duplicate slugs outside the scope' do
    person_1  = Person.create!(name: 'Ismail')
    rambo_1 = Pet.create!(name: 'Rambo', owner: person_1)
    rambo_2 = Pet.create!(name: 'Rambo', owner: person_1)

    person_2  = Person.create!(name: 'Frank')
    rambo_3 = Pet.create!(name: 'Rambo', owner: person_2)

    assert_equal 'rambo', rambo_1.slug
    assert_equal 'rambo--2', rambo_2.slug

    assert_equal 'rambo', rambo_3.slug
  end
end
