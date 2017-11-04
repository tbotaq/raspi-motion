require_relative "./lib/image.rb"
require_relative './lib/slack.rb'

Slack.post("Start posting.")
Image.all.each do |image|
  sleep(5)
  begin
    image.crop!
    Slack.upload(image)
    image.rm!
  rescue => e
    image.mark_as_fail!
    Slack.post(e)
    next
  end
end
Slack.post("Done.")
