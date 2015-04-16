module Noosfero
  module API
    module V1
      class People < Grape::API
        before { authenticate! }
  
        resource :people do
  
          # Collect comments from articles
          #
          # Parameters:
          #   from             - date where the search will begin. If nothing is passed the default date will be the date of the first article created
          #   oldest           - Collect the oldest comments from reference_id comment. If nothing is passed the newest comments are collected
          #   limit            - amount of comments returned. The default value is 20
          #
          # Example Request:
          #  GET /people?from=2013-04-04-14:41:43&until=2014-04-04-14:41:43&limit=10
          #  GET /people?reference_id=10&limit=10&oldest
          get do
            people = select_filtered_collection_of(environment, 'people', params)
            people = people.visible_for_person(current_person)
            present people, :with => Entities::Person
          end
  
          desc "Return the person information"
          get ':id' do
            person = environment.people.visible.find_by_id(params[:id])
            present person, :with => Entities::Person
          end
  
          desc "Return the person friends"
          get ':id/friends' do
            friends = current_person.friends.visible
            present friends, :with => Entities::Person
          end
  
        end
  
      end
    end
  end
end