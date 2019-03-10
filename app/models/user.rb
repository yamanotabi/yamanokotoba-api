class User
  include Mongoid::Document
  field :user_id, type: String
  field :user_image_url, type: String
end
  