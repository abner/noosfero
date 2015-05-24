# encoding: UTF-8
require_relative "../test_helper"

class QualifierTest < ActiveSupport::TestCase

  should 'environment is mandatory' do
    qualifier = Qualifier.new(:name => 'Qualifier without environment')
    assert !qualifier.valid?

    qualifier.environment = create(Environment)
    assert qualifier.valid?
  end

  should 'belongs to environment' do
    env_one = create(Environment)
    qualifier_from_env_one = env_one.qualifiers.create(:name => 'Qualifier from environment one')

    env_two = create(Environment)
    qualifier_from_env_two = env_two.qualifiers.create(:name => 'Qualifier from environment two')

    assert_includes env_one.qualifiers, qualifier_from_env_one
    assert_not_includes env_one.qualifiers, qualifier_from_env_two
  end

  should 'name is mandatory' do
    env_one = create(Environment)
    qualifier = env_one.qualifiers.build
    assert !qualifier.valid?

    qualifier.name = 'Qualifier name'
    assert qualifier.valid?
  end

  should 'sort by name' do
    last = create(Qualifier, :name => "Zumm")
    first = create(Qualifier, :name => "Atum")
    assert_equal [first, last], Qualifier.all.sort
  end

  should 'sorting is not case sensitive' do
    first = create(Qualifier, :name => "Aaaa")
    second = create(Qualifier, :name => "abbb")
    last = create(Qualifier, :name => "Accc")
    assert_equal [first, second, last], Qualifier.all.sort
  end

  should 'discard non-ascii char when sorting' do
    first = create(Qualifier, :name => "Áaaa")
    last = create(Qualifier, :name => "Aáab")
    assert_equal [first, last], Qualifier.all.sort
  end

  should 'clean all ProductQualifier when destroy a Qualifier' do
    product1 = create(Product)
    product2 = create(Product)
    qualifier = create(Qualifier, :name => 'Free Software')
    certifier = create(Certifier, :name => 'FSF')
    ProductQualifier.create!(:product => product1, :qualifier => qualifier, :certifier => certifier)
    ProductQualifier.create!(:product => product2, :qualifier => qualifier, :certifier => certifier)
    assert_equal [['Free Software', 'FSF']], product1.product_qualifiers.map{|i| [i.qualifier.name, i.certifier.name]}
    Qualifier.destroy_all
    assert_equal [], product1.product_qualifiers(true)
  end
end
