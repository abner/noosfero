require_relative "../test_helper"

class CmsHelperTest < ActionView::TestCase

  include CmsHelper
  include BlogHelper
  include ApplicationHelper
  include ActionView::Helpers::UrlHelper
  include Noosfero::Plugin::HotSpot

  should 'show default options for article' do
    result = options_for_article(build(RssFeed, :profile => Profile.new))
    assert_match /id="article_published_true" name="article\[published\]" type="radio" value="true"/, result
    assert_match /id="article_published_false" name="article\[published\]" type="radio" value="false"/, result
    assert_match /id="article_accept_comments" name="article\[accept_comments\]" type="checkbox" value="1"/, result
  end

  should 'show custom options for blog' do
    result = options_for_article(Blog.new(:profile => create(Profile)))
    assert_tag_in_string result, :tag => 'input', :attributes => { :name => 'article[published]' , :type => "hidden", :value => "1" }
    assert_tag_in_string result, :tag => 'input', :attributes => { :name => "article[accept_comments]", :type => "hidden", :value => "0" }
  end

  should 'display link to folder content if article is folder' do
    profile = create(Profile)
    folder = create(Folder, :name => 'My folder', :profile_id => profile.id)
    expects(:link_to).with('My folder', {:action => 'view', :id => folder.id}, :class => icon_for_article(folder))

    result = link_to_article(folder)
  end

  should 'display link to article if article is not folder' do
    profile = create(Profile)
    article = create(TinyMceArticle, :name => 'My article', :profile_id => profile.id)
    expects(:link_to).with('My article', article.url, :class => icon_for_article(article))

    result = link_to_article(article)
  end

  should 'display image and link if article is an image' do
    profile = create(Profile)
    file = UploadedFile.create!(:profile => profile, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'))
    file = FilePresenter.for file
    icon = icon_for_article(file)
    expects(:image_tag).with(icon).returns('icon')

    expects(:link_to).with('rails.png', file.url).returns('link')
    result = link_to_article(file)
  end

  should 'display spread button' do
    plugins.stubs(:dispatch).returns([])
    profile = create(Person)
    article = create(TinyMceArticle, :name => 'My article', :profile_id => profile.id)
    expects(:link_to).with('Spread this', {:action => 'publish', :id => article.id}, :class => 'button with-text icon-spread colorbox', :title => nil)

    result = display_spread_button(article)
  end

  should 'display delete_button to folder' do
    plugins.stubs(:dispatch).returns([])
    profile = create(Profile)
    name = 'My folder'
    folder = create(Folder, :name => name, :profile_id => profile.id)
    confirm_message = CGI.escapeHTML("Are you sure that you want to remove the folder \"#{name}\"? Note that all the items inside it will also be removed!")
    expects(:link_to).with('Delete', {:action => 'destroy', :id => folder.id}, :method => :post, :confirm => confirm_message, :class => 'button with-text icon-delete', :title => nil)

    result = display_delete_button(folder)
  end

  should 'display delete_button to article' do
    plugins.stubs(:dispatch).returns([])
    profile = create(Profile)
    name = 'My article'
    article = create(TinyMceArticle, :name => name, :profile_id => profile.id)
    confirm_message = CGI.escapeHTML("Are you sure that you want to remove the item \"#{name}\"?")
    expects(:link_to).with('Delete', {:action => 'destroy', :id => article.id}, :method => :post, :confirm => confirm_message, :class => 'button with-text icon-delete', :title => nil)

    result = display_delete_button(article)
  end
end

module RssFeedHelper
end
