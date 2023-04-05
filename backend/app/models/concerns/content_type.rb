module ContentType
  extend ActiveSupport::Concern

  IMAGE_TYPE = %i(image/jpg image/jpeg image/png)

  included do
    validates :avatar, content_type: IMAGE_TYPE
  end
end
