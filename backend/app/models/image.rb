class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  validates  :image_path, presence: true
end
