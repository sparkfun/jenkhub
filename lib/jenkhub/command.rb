require 'jenkhub/master'
require 'jenkhub/issues'
require 'jenkhub/comment'

module Jenkhub
  class Command
    class << self

      attr_reader :valid_commands

      @@valid_commands = [
        'issues',
        'master',
        'comment'
      ]

      def execute(*args)
        command = args.shift
        major   = args.empty? ? nil : args.shift
        minor   = args.empty? ? nil : args.shift
        last    = args.empty? ? nil : args.join(' ')
        return help unless command

        delegate(command, major, minor, last)
      end

      def delegate(command, major, minor, last)
        help unless @@valid_commands.include? command

        begin
          Jenkhub.const_get(command.capitalize).new(major, minor, last);
        rescue NameError
          help
        end
      end

      # Command line help
      # =============
      def help
        puts %Q{
        Jenkhub help
        =============
                     issues <tag> <job> <token>  Check open issues tagged
                                                 <tag>, create jenkins <job>
                                                 using <token> if'n they
                                                 need it

                           master <job> <token>  check for updates to master
                                                 takes the the <job> and
                                                 build <token> for jenkins

        comment <issue#> <url> <(SUCCESS|FAIL)>  post success/fail link on
                                                 github issue number
        }.gsub(/^ {8}/, '')
      end

    end
  end
end
