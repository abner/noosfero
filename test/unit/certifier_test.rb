# encoding: UTF-8
require_relative "../test_helper"

class CertifierTest < ActiveSupport::TestCase

  should 'have link' do
    certifier = Certifier.new

    assert_equal '', certifier.link

    certifier.link = 'http://noosfero.org'
    assert_equal 'http://noosfero.org', certifier.link
  end

  should 'environment is mandatory' do
    certifier = Certifier.new(:name => 'Certifier without environment')
    assert !certifier.valid?

    certifier.environment = create(Environment)
    assert certifier.valid?
  end

  should 'belongs to environment' do
    env_one = create(Environment)
    certifier_from_env_one = env_one.certifiers.create(:name => 'Certifier from environment one')

    env_two = create(Environment)
    certifier_from_env_two = env_two.certifiers.create(:name => 'Certifier from environment two')

    assert_includes env_one.certifiers, certifier_from_env_one
    assert_not_includes env_one.certifiers, certifier_from_env_two
  end

  should 'name is mandatory' do
    env_one = create(Environment)
    certifier = env_one.certifiers.new
    assert !certifier.valid?

    certifier.name = 'Certifier name'
    assert certifier.valid?
  end

  should 'sort by name' do
    last = create(Certifier, :name => "Zumm")
    first = create(Certifier, :name => "Atum")
    assert_equal [first, last], Certifier.all.sort
  end

  should 'sorting is not case sensitive' do
    first = create(Certifier, :name => "Aaaa")
    second = create(Certifier, :name => "abbb")
    last = create(Certifier, :name => "Accc")
    assert_equal [first, second, last], Certifier.all.sort
  end

  should 'discard non-ascii char when sorting' do
    first = create(Certifier, :name => "Áaaa")
    last = create(Certifier, :name => "Aáab")
    assert_equal [first, last], Certifier.all.sort
  end

  should 'set qualifier as self-certified when destroyed' do
    pq = mock
    Certifier.any_instance.stubs(:product_qualifiers).returns([pq])
    pq.expects(:update_attributes!).with(:certifier => nil)
    cert = create(Certifier)
    cert.destroy
  end

end
