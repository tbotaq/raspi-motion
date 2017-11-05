require 'yaml'
require 'hashie'
module Const
  def const
    Hashie::Mash.new(YAML.load_file("/home/pi/motion/scripts/lib/const.yml"))
  end
end
