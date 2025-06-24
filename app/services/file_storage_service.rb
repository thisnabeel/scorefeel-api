class FileStorageService

  def self.upload(file, folder, filename)
    s3 = Aws::S3::Resource.new
    ext = file.original_filename.split('.').last
    key = "#{folder}/#{filename}.#{ext}"
    obj = s3.bucket('scorefeel').object(key)
    
    puts "Uploading file #{key}"
    obj.upload_file(file.tempfile.path, acl: 'public-read')
    obj.public_url
    return {
        key: key,
        url: obj.public_url,
    }
  end
end