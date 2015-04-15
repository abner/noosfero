#require File.dirname(__FILE__) + '/ldap_authentication.rb'

class ExpressoMessagesPlugin < Noosfero::Plugin

  def self.plugin_name
    "ExpressoMessagesPlugin"
  end

  def self.plugin_description
    _("A Plugin that integrate Expresso Inbox into Noosfero.")
  end

  def allow_user_registration
    false
  end

  def allow_password_recovery
    false
  end

  # Overriding the alternative authentication to use the expresso
  def alternative_authentication
    puts 'Alternative authentication on ExpressoMessagesPlugin!'
    auth = OmniAuth::ExpressoV3::AuthClient.new :debug => true
    # Todo: the context object is of what type?
    login = context.params[:user][:login]
    password = context.params[:user][:password]
    # We now connect to expresso
    auth_data = auth.authenticate(login, password)
    # User data
    user_data = auth.get_user_data
    # Fetch the user from database
    user = User.find_or_initialize_by_login(login)

    return nil if !user.activated?

    user
  end

  def login_extra_contents
    proc do
      @person = Person.new(:environment => @environment)
      @profile_data = @person
      labelled_fields_for :profile_data, @person do |f|
        render :partial => 'profile_editor/person_form', :locals => {:f => f}
      end
    end
  end

  # Get the last messages for inbox
  def last_messages
    inbox_id = inbox_folder.id
    account_id = @user_data.expressoAccount.id
    args = {
      filter:
      [
        {
          condition: "OR",
          filters: [
              {condition: "AND", filters: [{field: "query", operator: "contains", value: "", id: "ext-record-351"},
                { field: "path", operator: "in",
                          value: ["/#{account_id}/#{inbox_id}"],
                          id: "ext-record-368"}],
          id: "ext-comp-1101", label: "Messages"}]}],
      paging:
              {
                  sort: "received", dir: "DESC", start: 0, limit: 5
              }
    }
    response = @auth.send("Expressomail.searchMessages", args)

    display_label  "LISTING LAST 5 MESSAGES"

    response.results.each do |msg|
      p "SUBJECT: #{msg.subject}"
      p "EMAIL DATA: "
      puts_object msg
      display_line
    end #response.results
  end #last_messages

end
