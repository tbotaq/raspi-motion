require "spec_helper"
require "image"
describe Image do
  describe "const" do
    subject{Image.send(:const)}
    it "doesn't raise error" do
      expect{subject}.not_to raise_error
    end
    describe "const.motion" do
      subject{Image.send(:const).motion}
      it "is not nil" do
        is_expected.not_to be_nil
      end
      describe "const.motion.image_dir" do
        subject{Image.send(:const).motion.image_dir}
        it "returns full path of images dir" do
          is_expected.to eq("/home/pi/motion/images")
        end
        it "returns the path actually existing" do
          expect(File.exist?(subject)).to be true
        end
      end
      describe "const.motion.failed_image_dir_name" do
        subject{Image.send(:const).motion.failed_image_dir_name}
        it "returns expected string" do
          is_expected.to eq("upload_failed")
        end
      end
    end
    describe "const.slack" do
      subject{Image.send(:const).slack}
      it "is not nil" do
        is_expected.not_to be_nil
      end
      describe "const.slack.channel_name" do
        subject{Image.send(:const).slack.channel_name}
        it "starts with #" do
          is_expected.to start_with("#")
        end
      end
      describe "const.slack.token" do
        subject{Image.send(:const).slack.token}
        it "returns some value" do
          is_expected.not_to be_nil
        end
      end
    end
  end
end
