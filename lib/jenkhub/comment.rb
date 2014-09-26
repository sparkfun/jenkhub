require 'jenkhub/hub'

module Jenkhub
  class Comment
    def initialize(major, minor, last)
      unless(major && minor && last)
        help
      end

      post_comment(major, minor, last)
    end

    private

    def post_comment(num, url, result)
      if ! ['SUCCESS', 'FAIL'].include? result
        exit 1
      end
      Jenkhub::Hub.instance.post_comment(num, url, result)
    end

    def help
      puts %Q{
      Jenkhub comment help
      =============
      comment <issue#> <url> <(SUCCESS|FAIL)> post success/fail link on
                                              github issue number
      }.gsub(/^ {6}/, '')
    end

  end
end
