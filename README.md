# Jenkhub

Monitors our github, kicks off jenkins jobs and posts comments for pull requests.

This runs via cron on our Jenkins master instance.

Keeps a log of all the current SHA files under "$HOME/.jenkhub"

**/home/jenkins/jenkhub**

```javascript
{
  "master": "123abccurrenthash",
  "branch": "345latestpushedhash"
}
```

## Installation

    $ bundle && rake build && sudo rake install

## Config file

`jenkhub` expects to find a `jenkhub.yml` file under `$XDG_CONFIG_HOME`. The
required file format is:

```yaml
github:
  token: <github api-token>
  account: <github account name>
  repo: <github repo to watch>

jenkins_server_url: <url of your jenkins server>
```

**Example Config file**:

```yaml
github:
  token: abc123gentoken
  account: sparkfun
  repo: jenkhub

jenkins_server_url: http://my-internal.jenkins.server.dns.or.ip
```

More info about the github developer api is available
on [developer.github.com](https://developer.github.com/)

More info on the github token available
on [github help](https://help.github.com/articles/creating-an-access-token-for-command-line-use)

## Usage

Check for commits to master since you last ran `jenkhub`, run a build
named `<jenkins-job-name>` using the job build token `<jenkins-build-token>`
if there are new commits

    $ jenkhub master <jenkins-job-name> <jenkins-build-token>

Check for any pull requests with the supplied tag  and run a dynamic build
with the supplied jenkins job name and token if there are new commits
since you last ran `jenkhub`

    $ jenkhub issues <github-tag> <jenkins-job-name> <jenkins-build-token>

Post comment Jenkins success or fail comment on an issue

    $ jenkhub <github-issue-number> <link-url> <('SUCCESS'|'FAIL')>

Example:

    $ jenkhub 542 http://jenkins/job/JobName/18 SUCCESS

Produces the comment on issue 542:

    :+1: (Jenkins build success)[http://jenkins/job/JobName/18]
