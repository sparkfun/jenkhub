require 'jenkhub/hub'
require 'jenkhub/jenkins'
require 'jenkhub/storage'

module Jenkhub
  class Master

    def initialize(major, minor, last)
      help if (major == 'help' || last)
      help unless (major && minor)

      @job = major
      @token = minor

      @storage = Jenkhub::Storage.instance
      check_for_update
    end

    private

    def check_for_update
      new_sha = Jenkhub::Hub.instance.check_ref('master')
      old_sha = 0

      if @storage.exists?('master')
        old_sha = @storage.get('master')
      end

      if new_sha != old_sha
        create_jenkins_build(new_sha)
      else
        puts "[INFO] No Updates"
      end
    end

    def create_jenkins_build(new_sha)
      puts "[INFO] New Updates"
      @storage.set('master', new_sha)
      @storage.save

      jenkins       = Jenkhub::Jenkins.new('master', 0, false)
      jenkins.job   = @job
      jenkins.token = @token
      jenkins.create_job
    end

    def help
      puts %Q{
      Jenkhub master help
      =============
      master <job> <token> check for updates to master takes the
                           the <job> nand build <token> for jenkins
      }.gsub(/^ {6}/, '')
    end

  end
end
