require 'rubygems'
require 'rmagick'
require 'slack-ruby-client'
class Image
  class << self
    def all
      all_paths.map{|path| new(path)}
    end

    private

    def all_paths
      Dir.glob( File.join(image_root_dir, "*.jpg") ).sort
    end
  end

  def initialize(path)
    @path = path
  end

  def crop!
    original = Magick::Image.read(@path).first
    cropped = original.crop(335, 387, 250, 250)
    FileUtils.chmod(0777, @path)
    cropped.write(@path)
    cropped.destroy!
  end

  def upload
    slack_client.files_upload(
      channels: slacl_channel_name,
      file: Faraday::UploadIO.new(@path, 'image/jpeg'),
      filename: File.basename(@path)
    )
  end

  def mark_as_fail!
    FileUtils.mv(@path, failed_image_dir)
  end

  def rm!
    File.delete(@path)
  end

  def slack_client
    return @slack_client if defined?(@slack_client)
    Slack.configure{|c| c.token = slack_token}
    @slack_client = Slack::Web::Client.new
  end

  def const
    @const ||= Hashie::Mash.new(YAML.load_file("/var/motion/scripts/lib/const.yml"))
  end

  def image_root_dir
    const.motion.image_root_dir
  end

  def failed_image_dir
    File.join(image_root_dir, const.motion.failed_image_dir_name)
  end

  def slacl_channel_name
    const.slack.chennel_name
  end

  def slack_token
    const.slack.token
  end
end
