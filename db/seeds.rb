# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Loading Establishments"

json = ActiveSupport::JSON.decode(File.read('db/seeds/Place.json'))

json['results'].each do |establishment|
  puts Establishment.create({
    name: establishment['Name'],
    address_1: establishment['Address'],
    address_2: nil,
    city: establishment['city'] || nil,
    state: establishment['state'] || nil,
    zipcode: establishment['zip'] || nil,
    phone: establishment['Phone'] || nil,
    website: establishment['Website'] || nil,
    facebook_url: nil,
    twitter_url: nil,
    youtube_url: nil,
    description: nil
  })
  sleep(3)
end

[
  'Live Music',
  'Outdoor Seating',
  'Dance Club',
  'Brewery',
  'Live Sports',
  'Live Entertainment',
  'Irish Pub',
  'Sports Bar',
  'Live DJ',
  'Martini Bar',
  'Country Dancing',
  'Comedy',
  'Discounts',
  'Wine Bar',
  'Live Music',
  'Outdoor Seating',
  'Dance Club'
].each do |category|
    EstablishmentCategory.create(title: category)
end
