class ProductsBlock < Block

  attr_accessible :product_ids

  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def self.description
    _('Products')
  end

  def default_title
    _('Products')
  end

  def help
    _('This block presents a list of your products.')
  end

  def content(args={})
    product_title = block_title(title).html_safe
    products_map = products.map { |product|
        product_link = link_to( 
          product.name,
          product.url,
          :style => 'background-image:url(%s)' % product.default_image('minor')
        )
        content_tag('li', product_link.html_safe, :class => 'product')
    }
    products_map_join = products_map.join.html_safe
    product_title.html_safe + content_tag('ul', products_map_join)
  end

  def footer
    link_to(_('View all products'), owner.public_profile_url.merge(:controller => 'catalog', :action => 'index'))
  end

  settings_items :product_ids, Array
  def product_ids=(array)
    self.settings[:product_ids] = array
    if self.settings[:product_ids]
      self.settings[:product_ids] = self.settings[:product_ids].map(&:to_i)
    end
  end

  def products(reload = false)
    if product_ids.blank?
      owner.products.order('RANDOM()').limit([4,owner.products.count].min)
    else
      owner.products.where(:id => product_ids)
    end.compact
  end

end
