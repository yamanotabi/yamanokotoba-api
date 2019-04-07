class Word
  include Mongoid::Document
  field :id, type: String
  field :text, type: String
  field :user_name, type: String
  field :background_image_url, type: String
  field :user_image_url, type: String
  field :tweet_text, type: String
end
