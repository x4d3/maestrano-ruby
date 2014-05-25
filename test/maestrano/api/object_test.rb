require File.expand_path('../../../test_helper', __FILE__)

module Maestrano
  module API
    class ObjectTest < Test::Unit::TestCase
      should "implement #respond_to correctly" do
        obj = Maestrano::API::Object.construct_from({ :id => 1, :foo => 'bar' })
        assert obj.respond_to?(:id)
        assert obj.respond_to?(:foo)
        assert !obj.respond_to?(:baz)
      end

      should "marshal a maestrano object correctly" do
        obj = Maestrano::API::Object.construct_from({ :id => 1, :name => 'Maestrano' }, 'apikey')
        m = Marshal.load(Marshal.dump(obj))
        assert_equal 1, m.id
        assert_equal 'Maestrano', m.name
        assert_equal 'apikey', m.api_key
      end
    end
  end
end
