require 'singleton'
require 'yajl'
require 'fileutils'

module Jenkhub
  class Storage
    include Singleton

    JSON_FILE = "#{ENV['HOME']}/.jenkhub"
    attr_writer :hash

    def initialize()
      @hash = {}
      bootstrap
      populate
    end

    def json_file
      JSON_FILE
    end

    def exists?(name)
      !@hash[name].nil?
    end

    def delete(name)
      @hash.delete(name)
    end

    def set(name, value)
      @hash[name] = value
    end

    def get(name)
      @hash[name]
    end

    def populate
      file = File.new(json_file, 'r')
      @hash = Yajl::Parser.parse(file)
    end

    def bootstrap
      return if File.exist?(json_file) && !File.zero?(json_file)
      FileUtils.touch json_file
      save
    end

    def save
      File.open(json_file, 'w') { |f| f.write(to_json) }
    end

    def to_json
      Yajl::Encoder.encode(@hash, :pretty => true)
    end
  end
end
