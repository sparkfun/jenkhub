require 'jenkhub/hub'
require 'jenkhub/jenkins'
require 'jenkhub/storage'

module Jenkhub
  class Issues
    def initialize(major, minor, last)
      help if major == 'help'
      help unless (major && minor && last)

      @tag = major
      @job = minor
      @token = last
      @hub = Jenkhub::Hub.instance

      @issues = @hub.get_issues(@tag);
      @storage = Jenkhub::Storage.instance
      create
    end

    private

    def create
      @issues.each do |issue|
        check_for_update(issue)
      end
    end

    def check_for_update(issue)
      ref     = @hub.get_pull(issue)
      new_sha = @hub.check_ref(ref)
      old_sha = 0

      if @storage.exists?(ref)
        old_sha = @storage.get(ref)
      end

      if new_sha != old_sha
        create_jenkins_build(new_sha, issue, ref)
      else
        puts "[INFO] No Updates for Issue #{issue}: #{ref}"
      end
    end

    def create_jenkins_build(new_sha, issue, ref)
      puts "[INFO] New Updates found for Issue #{issue}: #{ref}"
      @storage.set(ref, new_sha)
      @storage.save

      puts "New Sha: #{new_sha}, Issue: #{issue}, Ref: #{ref}"

      jenkins       = Jenkhub::Jenkins.new(ref, issue, true)
      jenkins.token = @token
      jenkins.job   = @job
      jenkins.create_job
    end

    def help
      puts %Q{
      Jenkhub Issues help
      =============
      issues <tag> <job> <token>  Check open issues tagged <tag>, create
                                  jenkins <job> using <token> if'n they
                                  need it
      }.gsub(/^ {6}/, '')
    end



  end
end
