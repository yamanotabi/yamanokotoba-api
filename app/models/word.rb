class Word
  include Mongoid::Document
  field :text, type: String
  field :user_name, type: String
  field :background_image_url, type: String
  field :user_image_url, type: String
end
