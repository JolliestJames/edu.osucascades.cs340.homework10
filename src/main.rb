#!/usr/bin/ruby

require 'mongo'
require 'redis'

$redis = Redis.new

def print_all_guitars(guitars)
	guitars.each do |g|
		puts $redis.hgetall g
	end
end

def seed_guitars
	$redis.hmset 'g1', 'name', 'Telecaster', 'make', 'Fender', 'price', '1200'
	$redis.hmset 'g2', 'name', 'Stratocaster', 'make', 'Fender', 'price', '1500'
	$redis.hmset 'g3', 'name', 'Les Paul', 'make', 'Gibson', 'price', '4000'
	$redis.hmset 'g4', 'name', 'Stratoblaster', 'make', 'Walmart', 'price', '100'
end

def delete_guitar(guitar_keys, index)
	$redis.del guitar_keys[index]
	guitar_keys.delete_at(index)
end

def update_guitar(guitar_keys, index, key, value)
	$redis.hset guitar_keys[index], key, value
end

def add_guitar(guitar_keys, guitar_key, name, make, price)
	$redis.hmset guitar_key, 'name', name, 'make', make, 'price', price
	guitar_keys << guitar_key
end

guitar_keys = ['g1', 'g2', 'g3', 'g4']

puts 'Inserting guitars...'
seed_guitars
puts 'Here are some guitars'
print_all_guitars(guitar_keys)
puts 'Adding a guitar'
add_guitar(guitar_keys, 'g5', 'SG', 'Gibson', '1200')
print_all_guitars(guitar_keys)
puts 'Updating a guitar'
update_guitar(guitar_keys, 1, 'price', '2000')
print_all_guitars(guitar_keys)
puts 'Deleting a guitar'
delete_guitar(guitar_keys, 3)
print_all_guitars(guitar_keys)

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'testdb')

client.collections.each { |c| puts c.name }

client[:guitars].find.each { |g| puts g }

client.close
