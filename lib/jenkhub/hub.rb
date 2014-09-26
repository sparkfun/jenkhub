require "singleton"
require "net/http"
require 'octokit'
require "uri"

module Jenkhub
  class Hub
    include Singleton

    attr_accessor :pull_id

    def initialize
      @client = Octokit::Client.new(:access_token => AUTH_TOKEN)
      @repo = "#{REPO_BASE}#{REPO_NAME}"
    end

    def check_ref(ref)
      #discern_method(ref)
      head = @client.commits(@repo, { :sha => ref }).shift
      head.rels[:self].get.data.sha
    end

    def get_issues(label)
      jenkins_issues = []

      issues = @client.list_issues(@repo, { 'labels' => label })

      issues.each do |issue|
        jenkins_issues << issue.rels[:self].get.data.number
      end

      jenkins_issues
    end

    def get_pull(num)
      pull = @client.pull_request(@repo, num)
      pull.rels[:self].get.data.head.ref
    end

    def post_fail_comment(num)
    end

    def post_comment(id, url, comment)
      if comment == 'SUCCESS'
        body = "{\"body\": \":+1: [Jenkins build success](#{url})\"}"
      else
        body = "{\"body\": \":-1: [Jenkins build failure](#{url})\"}"
      end

      post_github("https://api.github.com/repos/#{@repo}/issues/#{id}/comments", body)
    end

    def post_github(url, query)
      github_url = URI.parse(url)

      http = Net::HTTP.new(github_url.host, github_url.port)
      http.use_ssl = true

      headers = {
        "User-Agent" => "Jenkhub",
        "Authorization" => "token #{AUTH_TOKEN}",
      }

      request = Net::HTTP::Post.new(github_url.request_uri, headers)
      request.body = query

      http.request(request)
    end
  end
end
