class User
  include Mongoid::Document
  field :user_id, type: String
  field :display_name, type: String
  field :user_name, type: String
  field :user_image_url, type: String
  field provider, type: String
end
  