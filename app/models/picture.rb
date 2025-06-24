class Picture < ApplicationRecord
  belongs_to :picturable, polymorphic: true

  validates :caption, presence: true
  validates :picturable, presence: true

  scope :covers, -> { where(cover: true) }
  scope :ordered, -> { order(created_at: :desc) }

  before_destroy :delete_from_s3

  private

  def delete_from_s3
    return unless storage_key.present?

    begin
      s3_client = Aws::S3::Client.new(
        region: ENV['AWS_REGION'] || 'us-east-2',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )

      s3_client.delete_object(
        bucket: ENV['AWS_S3_BUCKET'] || 'scorefeel-api',
        key: storage_key
      )
      
      Rails.logger.info "Successfully deleted file from S3: #{storage_key}"
    rescue Aws::S3::Errors::NoSuchKey
      Rails.logger.warn "File not found in S3: #{storage_key}"
    rescue => e
      Rails.logger.error "Failed to delete file from S3: #{storage_key}. Error: #{e.message}"
      # Don't raise the error to prevent the record deletion from failing
    end
  end
end
