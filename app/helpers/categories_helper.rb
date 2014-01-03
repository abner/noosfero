module CategoriesHelper

  TYPES = [
    [ _('General Category'), Category.to_s ],
    [ _('Product Category'), ProductCategory.to_s ],
    [ _('Region'), Region.to_s ],
  ]

  def select_category_type(field)
    value = params[field]
    labelled_form_field(_('Type of category'), select_tag('type', options_for_select(TYPES, value)))
  end

  # return the category color or an ancestor category color 
  def category_tree_color_style(category)
    color = search_category_tree_for_color(category)
    if color.nil?
      ''
    else
      'background-color: #'+color+';'
    end
  end
  
  #return category color ignoring ancestor categories colors
  def category_color_style(category)
    color = (category.display_color.nil? || category.display_color.empty?) ? nil : category.display_color  
    if color.nil?
      ''
    else
      'background-color: #'+color+';'
    end
  end

  protected
  def search_category_tree_for_color(category)
    if category.display_color.nil? || category.display_color.empty?  
      if category.parent.nil?
        nil
      else
        search_category_tree_for_color(category.parent)
      end
    else
      category.display_color
    end
  end

  #FIXME make this test
  def selected_category_link(cat)
    link_to_function(cat.full_name, nil, :id => "remove-selected-category-#{cat.id}-button", :class => 'select-subcategory-link') {|page| page["selected-category-#{cat.id}"].remove}
  end

  #FIXME make this test
  def selected_category_link(cat)
    link_to_function(cat.full_name, nil, :id => "remove-selected-category-#{cat.id}-button", :class => 'select-subcategory-link') {|page| page["selected-category-#{cat.id}"].remove}
  end

end
