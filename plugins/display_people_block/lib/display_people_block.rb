class DisplayPeopleBlock < Block

  settings_items :prioritize_people_with_image, :type => :boolean, :default => true
  settings_items :limit, :type => :integer, :default => 6
  settings_items :name, :type => String, :default => ""
  settings_items :address, :type => String, :default => ""
	
  def self.description
    _('Random people')
  end

  def help
    "Help for Display People Block"
  end

  def default_title
    "{#} People"
  end

  def view_title
    default_title.gsub('{#}', profile_count.to_s)
  end

  def profiles
    case
      when owner.kind_of?(Organization)
        owner.members
      when owner.kind_of?(Person)
        owner.friends
      when owner.kind_of?(Environment)
        owner.people
    end
  end

  def profiles_list
    result = nil
    visible_profiles = profiles.visible.includes([:image,:domains,:preferred_domain,:environment])
    if !prioritize_people_with_image
      result = visible_profiles.all(:limit => limit, :order => 'updated_at DESC').sort_by{ rand }
    elsif visible_profiles.with_image.count >= limit
      result = visible_profiles.with_image.all(:limit => limit * 5, :order => 'updated_at DESC').sort_by{ rand }
    else
      result = visible_profiles.with_image.sort_by{ rand } + visible_profiles.without_image.all(:limit => limit * 5, :order => 'updated_at DESC').sort_by{ rand }
    end
    result.slice(0..limit-1)
  end

  def profile_count
    profiles_list.count
  end

  def content(args={})

    profiles = self.profiles_list
    title = self.view_title

    if !self.name.blank? && !self.address.blank?
      name = self.name
      expanded_address = expand_address(self.address)
    end

    lambda do
      count = 0
      list = profiles.map {|item|
               count += 1
               send(:profile_image_link, item, :minor )
             }.join("\n")
      if list.empty?
        list = content_tag 'div', _('None'), :class => 'common-profile-list-block-none'
      else
        if !name.blank? && !expanded_address.blank?
          list << content_tag( 
                    'div', 
                    content_tag( 
                      'li', 
                      link_to( 
                        content_tag(
                          'span', 
                          name, 
                          :class => 'banner-image'
                        ),
                        expanded_address,
                        :class => 'banner-link',
                        :title => name
                      ), 
                    :class => 'vcard'), 
                  :class => 'common-profile-list-block' )
        end
        list = content_tag 'ul', list
      end
      block_title(title) + content_tag('div', list + tag('br', :style => 'clear:both'))
    end
  end

  def expand_address(address)
    if address !~ /^[a-z]+:\/\// && address !~ /^\//
      'http://' + address
    else
      address
    end
  end

end

