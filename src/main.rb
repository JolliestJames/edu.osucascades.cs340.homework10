#!/usr/bin/ruby

require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'testdb')

client.collections.each { |coll| puts coll.name }

client[:guitars].find.each { |entity| puts entity }

client.close