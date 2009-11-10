Given /^the following users$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |item|
    person_data = item.dup
    person_data.delete("login")
    User.create!(:login => item[:login], :password => '123456', :password_confirmation => '123456', :email => item[:login] + "@example.com", :person_data => person_data)
  end
end

Given /^the following communities$/ do |table|
  table.hashes.each do |item|
    Community.create!(item)
  end
end

Given /^the following enterprises$/ do |table|
  table.hashes.each do |item|
    Enterprise.create!(item)
  end
end

Given /^the following blocks$/ do |table|
  table.hashes.map{|item| item.dup}.each do |item|
    klass = item.delete('type')
    owner = Profile[item.delete('owner')]
    box_id = owner.boxes.last.id
    klass.constantize.create!(item.merge(:box_id => box_id))
  end
end

Given /^the following (articles|events|blogs)$/ do |content, table|
  klass = {
    'articles' => TextileArticle,
    'events' => Event,
    'blogs' => Blog,
  }[content] || raise("Don't know how to build %s" % content)
  table.hashes.map{|item| item.dup}.each do |item|
    owner_identifier = item.delete("owner")
    owner = Profile[owner_identifier]
    klass.create!(item.merge(:profile => owner))
  end
end

Given /^the following files$/ do |table|
  table.hashes.each do |item|
    owner = Profile[item[:owner]]
    file = "/files/#{item[:file]}"
    article = UploadedFile.create!(:profile => owner, :uploaded_data => fixture_file_upload(file, item[:mime]))
    if item[:homepage]
      owner.home_page = article
      owner.save!
    end
  end
end

Given /^the following products$/ do |table|
  table.hashes.each do |item|
    data = item.dup
    owner = Enterprise[data.delete("owner")]
    Product.create!(data.merge(:enterprise => owner))
  end
end

Given /^I am logged in as "(.+)"$/ do |username|
  visit('/account/login')
  fill_in("Username", :with => username)
  fill_in("Password", :with => '123456')
  click_button("Log in")
end

Given /^I am logged in as admin$/ do
  user = User.create!(:login => 'admin_user', :password => '123456', :password_confirmation => '123456', :email => 'admin_user@example.com')
  e = Environment.default
  e.add_admin(user.person)
  visit('/account/login')
  fill_in("Username", :with => user.login)
  fill_in("Password", :with => '123456')
  click_button("Log in")
end

Given /^I am not logged in$/ do
  visit('/account/logout')
end

Given /^feature "(.+)" is enabled on environment$/ do |feature|
  e = Environment.default
  e.enable(feature)
  e.save
end

Given /^feature "(.+)" is disabled on environment$/ do |feature|
   e = Environment.default
   e.disable(feature)
   e.save
end

Given /^"(.+)" should be a member of "(.+)"$/ do |person,profile|
  Profile.find_by_name(profile).members.should include(Person.find_by_name(person))
end

Given /^"(.+)" is admin of "(.+)"$/ do |person, organization|
  org = Profile.find_by_name(organization)
  user = Profile.find_by_name(person)
  org.add_admin(user)
end
