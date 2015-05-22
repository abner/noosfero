FactoryGirl.define do

  sequence :identifier do |n|
    "identifier#{n}"
  end

  sequence :user_login do |n|
    "user#{n}"
  end

  factory :article do
    name { generate(:identifier) }
    slug { name.to_slug }
    path { name.to_slug }
    profile
    trait :of_person do
      profile person
    end

    factory :text_article, class: TextArticle do
    end
    factory :textile_article, class: TextileArticle do
    end

    factory :tiny_mce_article, class: TinyMceArticle do
    end

    factory :folder, class: Folder do
    end

    factory :forum, class: Forum do
    end

    factory :blog, class: Blog do
    end

    factory :gallery, class: Gallery do
    end

    factory :uploaded_file, class: UploadedFile do
    end

    factory :rss_feed, class: RssFeed do
    end

    factory :event, class: Event do
    end

  end

  factory :user do
    login { generate(:user_login) }
    email { "#{login}@example.com".downcase }
    crypted_password 'test'
#    person
#    person user: user
#    before(:build) do |user, evaluator|
#raise 'teste ' + evaluator.inspect 
#      user.person = FactoryGirl.build(:person)
#    end
    after(:create) do |user|
      user.activate
    end
  end

  factory :profile do
    name { generate(:identifier) }
    identifier { name.underscore }
    created_at DateTime.now
#    association :home_page, factory: :article, name: 'homepage', profile: person
#    environment
#    association :user, factory: :user do |user|#, strategy: :build 
#raise user.inspect
#    end
#    after(:build) do |person, evaluator|
#      person.user :user
#      person.home_page [:article, :of_person] #, profile: person
#    end
    factory :person, class: Person do

      before(:create) do |person, evaluator|
        person.user = FactoryGirl.create(:user, :person => person)
        person.visible = evaluator.visible
      end

      factory :user_with_permission do
        transient do 
          permissions []
          target nil
        end
        after(:create) do |person, evaluator|
#FIXME see if get an existing role is better the create a new one
          role = create(Role, :permissions => evaluator.permissions)
          person.add_role(role, evaluator.target)
        end
      end

    end
    factory :community, class: Community do
    end

  end

  factory :role do
    name FFaker::Lorem.word
    permissions [FFaker::Lorem.word]
  end

  factory :category do
    name FFaker::Lorem.word
  end

  factory :environment do
    name FFaker::Lorem.word
#    email { "#{name}@example.com".downcase }
  end

  factory :license do
    name FFaker::Lorem.word
    slug { name.to_slug }
  end

  factory :task do
    code FFaker::Lorem.word

    factory :approve_article, class: ApproveArticle do
    end
  end

  factory :comment do
    name FFaker::Lorem.word
  end

  factory ActsAsTaggableOn::Tag do
    name FFaker::Lorem.word
  end

end
