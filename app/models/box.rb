class Box < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  acts_as_list :scope => 'owner_id = #{owner_id} and owner_type = \'#{owner_type}\''
  has_many :blocks, :dependent => :destroy, :order => 'position'

  include Noosfero::Plugin::HotSpot

  def environment
    owner ? (owner.kind_of?(Environment) ? owner : owner.environment) : nil
  end

  def acceptable_blocks
    blocks = central?  ? Box.acceptable_center_blocks + plugins.dispatch(:extra_blocks, :position => 1) : Box.acceptable_side_blocks + plugins.dispatch(:extra_blocks, :position => [2, 3])
    to_css_class_name(blocks)
  end

  def central?
    position == 1
  end

  def self.acceptable_center_blocks
    [ ArticleBlock,
      BlogArchivesBlock,
      CategoriesBlock,
      CommunitiesBlock,
      EnterprisesBlock,
      FansBlock,
      FavoriteEnterprisesBlock,
      FeedReaderBlock,
      HighlightsBlock,
      LinkListBlock,
      LoginBlock,
      MainBlock,
      MyNetworkBlock,
      ProfileImageBlock,
      RawHTMLBlock,
      RecentDocumentsBlock,
      SellersSearchBlock,
      TagsBlock ]
  end

  def self.acceptable_side_blocks
    [ ArticleBlock,
      BlogArchivesBlock,
      CategoriesBlock,
      CommunitiesBlock,
      DisabledEnterpriseMessageBlock,
      EnterprisesBlock,
      FansBlock,
      FavoriteEnterprisesBlock,
      FeaturedProductsBlock,
      FeedReaderBlock,
      HighlightsBlock,
      LinkListBlock,
      LocationBlock,
      LoginBlock,
      MyNetworkBlock,
      ProductsBlock,
      ProfileImageBlock,
      ProfileInfoBlock,
      ProfileSearchBlock,
      RawHTMLBlock,
      RecentDocumentsBlock,
      SellersSearchBlock,
      SlideshowBlock,
      TagsBlock
    ]
  end

  private

  def to_css_class_name(blocks)
    blocks.map{ |block| block.to_s.underscore.tr('_', '-') }
  end

end
