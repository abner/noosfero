class InviteFriend < Invitation

  settings_items :group_for_person, :group_for_friend

  def perform
    person.add_friend(friend, group_for_person)
    friend.add_friend(person, group_for_friend)
  end

  def title
    _("New friend")
  end

  def information
    {:message => _('%{requestor} wants to be your friend.')}
  end

  def accept_details
    true
  end

  def icon
    {:type => :profile_image, :profile => requestor, :url => requestor.url}
  end

  def permission
    :manage_friends
  end

  # Default message send to friend when user use invite a friend feature
  def self.mail_template
    [ _('Hello <friend>,'),
      _('<user> is inviting you to participate on <environment>.'),
      _('To accept the invitation, please follow this link:'),
      '<url>',
      "--\n<environment>",
    ].join("\n\n")
  end

end
