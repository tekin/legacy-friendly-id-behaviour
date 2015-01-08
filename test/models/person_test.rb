require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'creating a person generates a slug' do
    person = Person.create!(name: 'Hayao Miyazaki')
    assert_equal 'hayao-miyazaki', person.slug
  end

  test 'clashing slugs get a sequence number' do
    people = (1..105).map { Person.create!(name: 'Hayao Miyazaki') }

    assert_equal 'hayao-miyazaki', people[0].slug
    (1..104).each do |number|
      assert_equal "hayao-miyazaki--#{number + 1}", people[number].slug
    end
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

  test 'sequential slugging copes with candidates ending with numbers' do
    robot_1 = Person.create!(name: 'Robot No. 12')
    robot_2 = Person.create!(name: 'Robot No. 12')

    assert_equal 'robot-no-12', robot_1.slug
    assert_equal 'robot-no-12--2', robot_2.slug
  end
end
