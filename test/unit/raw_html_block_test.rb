require_relative "../test_helper"

class RawHTMLBlockTest < ActiveSupport::TestCase

  should 'describe itself' do
    assert_not_equal Block.description, RawHTMLBlock.description
  end

  should 'store HTML' do
    block = RawHTMLBlock.new(:html => '<strong>HTML!</strong>')
    assert_equal '<strong>HTML!</strong>', block.html
  end

  should 'not filter HTML' do
    html = '<script type="text/javascript">alert("Hello, world")</script>"'
    block = RawHTMLBlock.new(:html => html)
    assert_equal html, block.html
  end

  should 'return html as content' do
    block = RawHTMLBlock.new(:html => "HTML")
    assert_match(/HTML$/, block.content)
  end

  should 'not be editable for non admin users' do
    block = RawHTMLBlock.new(:html => "HTML")
    user = create_user('testuser').person
    assert !block.editable?(user)
  end

  should 'be editable for admin users' do
    block = RawHTMLBlock.new(:html => "HTML")
    user = Person[create_admin_user(Environment.default)]
    assert block.editable?(user)
  end

end
