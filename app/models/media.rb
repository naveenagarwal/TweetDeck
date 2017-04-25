class Media < ApplicationRecord
  belongs_to :post

  mount_uploader :upload_doc, MediaUploader

  validates_size_of :upload_doc,
    maximum: 1.megabyte,
    message: "Attachment size exceeds the allowable limit (1 MB)."
end
