require_relative "./lib/image.rb"
require_relative './lib/slack.rb'

images = Image.all
exit if images.empty?

Slack.post("Start posting.")
images.each do |image|
  begin
    image.crop!
    Slack.upload(image)
    image.rm!
  rescue => e
    image.mark_as_fail!
    Slack.post(e)
  end
  sleep(5)
end
Slack.post("Done.")
