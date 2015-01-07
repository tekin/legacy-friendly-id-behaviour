require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'creating a person generates a slug' do
    person = Person.create!(name: 'Hayao Miyazaki')
    assert_equal 'hayao-miyazaki', person.slug
  end
end
