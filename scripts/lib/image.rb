require 'rmagick'
require_relative './const.rb'
class Image
  class << self
    include Const

    def all
      all_paths.map{|path| new(path)}
    end

    private

    def all_paths
      Dir.glob( File.join(const.motion.image_dir, "*.jpg") ).sort
    end
  end

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def crop!
    original = Magick::Image.read(path).first
    cropped = original.crop(870, 1200, 700, 700)
    FileUtils.chmod(0777, path)
    cropped.write(path)
    cropped.destroy!
  end

  def mark_as_fail!
    FileUtils.chmod(0777, path)
    FileUtils.mv(path, failed_image_dir)
  end

  def rm!
    File.delete(path)
  end

  private

  def failed_image_dir
    motion_const = self.class.const.motion
    File.join(motion_const.image_dir, motion_const.failed_image_dir_name)
  end
end
