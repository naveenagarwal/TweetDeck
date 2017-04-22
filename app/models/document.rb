class Document < ApplicationRecord
  belongs_to :user

  mount_uploader :upload_doc, DocumentUploader

  validates_size_of :upload_doc,
    maximum: 1.megabyte,
    message: "Attachment size exceeds the allowable limit (1 MB)."
end
