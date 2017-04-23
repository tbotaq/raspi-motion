require 'slack-ruby-client'
module Slack
  class << self
    include Const

    def post(message)
      slack_client.chat_postMessage(
        channel: slack_channel_name,
        text: message
      )
    end

    def upload(image)
      slack_client.files_upload(
        channels: slack_channel_name,
        file: Faraday::UploadIO.new(image.path, 'image/jpeg'),
        filename: File.basename(image.path)
      )
    end

    def slack_client
      return @slack_client if defined?(@slack_client)
      Slack.configure{|c| c.token = slack_token}
      @slack_client = Slack::Web::Client.new
    end

    def slack_channel_name
      const.slack.channel_name
    end

    def slack_token
      const.slack.token
    end
  end
end
