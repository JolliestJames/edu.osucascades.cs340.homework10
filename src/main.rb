#!/usr/bin/ruby

# Written by: James Martinez
# Assignment: Homework 10 - Database-Backed Applications with Redis and MongoDB

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

client = Mongo::Client.new(['127.0.0.1:27017'])
db = Mongo::Database.new(client, :guitars)

guitar_collection = Mongo::Collection.new(db, 'guitars')

guitar_collection.drop

puts "Inserting guitars"
guitar_collection.insert_one({name: "Stratocaster", make:"Fender", price: 1200})
guitar_collection.insert_one({name: "Telecaster", make:"Fender", price: 1000})
guitar_collection.insert_one({name: "Les Paul", make:"Gibson", price: 4000})
guitar_collection.insert_one({name: "Stratoblaster", make:"Walmart", price: 100})

guitar_collection.find.each do |g|
	puts  "#{g["name"]}, #{g["make"]}, #{g["price"]}"
end

puts "Deleting a guitar"
guitar_collection.find_one_and_delete({name: "Stratoblaster"})

guitar_collection.find.each do |g|
	puts  "#{g["name"]}, #{g["make"]}, #{g["price"]}"
end

puts "Updating a guitar"
guitar_collection.find_one_and_update({ name: 'Les Paul' }, { "$set" => { make: 'Epiphone', price: 600 }})

guitar_collection.find.each do |g|
	puts  "#{g["name"]}, #{g["make"]}, #{g["price"]}"
end

client.close
