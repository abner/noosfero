class ProfileDesignController < BoxOrganizerController

  needs_profile

  protect 'edit_profile_design', :profile
  
  def available_blocks
    blocks = [ ArticleBlock, TagsBlock, RecentDocumentsBlock, ProfileInfoBlock, LinkListBlock, MyNetworkBlock, FeedReaderBlock, ProfileImageBlock, LocationBlock, SlideshowBlock, ProfileSearchBlock, HighlightsBlock ]

    blocks += plugins.dispatch(:extra_blocks)

    # blocks exclusive for organizations
    if profile.has_members?
      blocks << MembersBlock
    end

    # blocks exclusive to people
    if profile.person?
      blocks << FriendsBlock
      blocks << FavoriteEnterprisesBlock
      blocks << CommunitiesBlock
      blocks << EnterprisesBlock
      blocks += plugins.dispatch(:extra_blocks, :type => Person)
    end

    # blocks exclusive to communities
    if profile.community?
      blocks += plugins.dispatch(:extra_blocks, :type => Community)
    end

    # blocks exclusive for enterprises
    if profile.enterprise?
      blocks << DisabledEnterpriseMessageBlock
      blocks << HighlightsBlock
      blocks << FeaturedProductsBlock
      blocks << FansBlock
      blocks += plugins.dispatch(:extra_blocks, :type => Enterprise)
    end

    # product block exclusive for enterprises in environments that permits it
    if profile.enterprise? && profile.environment.enabled?('products_for_enterprises')
      blocks << ProductsBlock
    end

    # block exclusive to profiles that have blog
    if profile.has_blog?
      blocks << BlogArchivesBlock
    end

    if user.is_admin?(profile.environment)
      blocks << RawHTMLBlock
    end

    blocks
  end

  #FIXME DRY
  def update_categories
    @object = params[:id] ? @profile.blocks.find(params[:id]) : nil
    if params[:category_id]
      @current_category = Category.find(params[:category_id])
      @categories = @current_category.children
    else
      @categories = environment.top_level_categories
    end
    render :partial => 'shared/select_categories', :locals => {:object_name => 'block', :multiple => true}, :layout => false
  end

end
