class Document < ApplicationRecord
  default_scope { order("id DESC") }

  belongs_to :user
  belongs_to :campaign, optional: true

  mount_uploader :upload_doc, DocumentUploader

  validates_size_of :upload_doc,
    maximum: 1.megabyte,
    message: "Attachment size exceeds the allowable limit (1 MB)."

  validates :upload_doc, presence:  true

  def output_filename
    filename = upload_doc.file.file
    @output_filename ||= "#{File.dirname(filename)}/#{File.basename(filename, '.csv')}-output.csv"
  end

  def output_url
    output = upload_doc.url
    output[".csv"] = "-output.csv"
    output
  end
end
