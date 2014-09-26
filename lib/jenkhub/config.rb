require 'yaml'

module Jenkhub

  def self.configure
    begin
       out = YAML::load(IO.read("#{ENV['XDG_CONFIG_HOME']}/jenkhub.yml"))
    rescue Errno::ENOENT
      puts "[ERROR] YAML configuration file couldn't be found. Exiting."
      exit 1
    rescue Psych::SyntaxError
      puts "[ERROR] YAML configuration file contains invalid syntax. Exiting."
      exit 1
    end

    out
  end

  CONFIG = self.configure

  AUTH_TOKEN = CONFIG['github']['token']
  REPO_NAME  = CONFIG['github']['repo']
  REPO_BASE  = "#{CONFIG['github']['account']}/"

  JENKINS_URL = CONFIG['jenkins_server_url']

end
