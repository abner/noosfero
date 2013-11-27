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

end
