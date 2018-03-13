#!/usr/bin/ruby

require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'testdb')

client.collections.each { |c| puts c.name }

client[:guitars].find.each { |g| puts g }

client.close