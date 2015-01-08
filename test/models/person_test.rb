require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'creating a person generates a slug' do
    person = Person.create!(name: 'Hayao Miyazaki')
    assert_equal 'hayao-miyazaki', person.slug
  end

  test 'clashing slugs get a sequence number' do
    people = (1..12).map { Person.create!(name: 'Hayao Miyazaki') }

    assert_equal 'hayao-miyazaki', people[0].slug
    assert_equal 'hayao-miyazaki--2', people[1].slug
    assert_equal 'hayao-miyazaki--3', people[2].slug
    assert_equal 'hayao-miyazaki--4', people[3].slug
    assert_equal 'hayao-miyazaki--5', people[4].slug
    assert_equal 'hayao-miyazaki--6', people[5].slug
    assert_equal 'hayao-miyazaki--7', people[6].slug
    assert_equal 'hayao-miyazaki--8', people[7].slug
    assert_equal 'hayao-miyazaki--9', people[8].slug
    assert_equal 'hayao-miyazaki--10', people[9].slug
    assert_equal 'hayao-miyazaki--11', people[10].slug
    assert_equal 'hayao-miyazaki--12', people[11].slug
  end

  test 'sequential slug resolution copes with deleted instances' do
    person_1 = Person.create!(name: 'Hayao Miyazaki')
    person_2 = Person.create!(name: 'Hayao Miyazaki')
    person_3 = Person.create!(name: 'Hayao Miyazaki')

    assert_equal 'hayao-miyazaki', person_1.slug
    assert_equal 'hayao-miyazaki--2', person_2.slug
    assert_equal 'hayao-miyazaki--3', person_3.slug

    person_2.destroy

    person_4 = Person.create!(name: 'Hayao Miyazaki')

    assert_equal 'hayao-miyazaki--4', person_4.slug
  end
end
