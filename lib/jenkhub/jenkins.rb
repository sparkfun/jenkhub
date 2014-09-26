module Jenkhub
  class Jenkins
    attr_accessor :url, :token, :job

    def initialize(ref, num = 0, parameter_build = false)
      @parameter_build = parameter_build
      @github_issue = num
      @branch = ref
    end

    def create_job
      created = `curl -s -i -X POST "#{url}" | grep -c 'Created'`.chomp.to_i

      if created == 0
        puts "[ERROR] Could not create Jenkins job"
      else
        puts "[INFO] Job created"
      end
    end

    def full_url
      "#{JENKINS_URL}/job/#{@job}"
    end

    def url
      if @parameter_build
        return "#{full_url}/buildWithParameters?token=#{@token}&git_rev=#{@branch}&github_issue=#{@github_issue}"
      else
        return "#{full_url}/build?token=#{@token}"
      end
    end

  end
end
