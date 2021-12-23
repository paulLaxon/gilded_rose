#!/usr/bin/ruby -w

require File.join(File.dirname(__FILE__), 'gilded_rose')

puts "OMGHAI!"
items = [
  Item.new(name="+5 Dexterity Vest", days_remaining=10, quality=20),
  Item.new(name="Aged Brie", days_remaining=2, quality=0),
  Item.new(name="Elixir of the Mongoose", days_remaining=5, quality=7),
  Item.new(name="Sulfuras, Hand of Ragnaros", days_remaining=0, quality=80),
  Item.new(name="Sulfuras, Hand of Ragnaros", days_remaining=-1, quality=80),
  Item.new(name="Backstage passes to a TAFKAL80ETC concert", days_remaining=15, quality=10),
  Item.new(name="Backstage passes to a TAFKAL80ETC concert", days_remaining=10, quality=10),
  Item.new(name="Backstage passes to a TAFKAL80ETC concert", days_remaining=5, quality=10),
  # This Conjured item does not work properly yet
  Item.new(name="Conjured Mana Cake", days_remaining=3, quality=6), # <-- :O
]

days = 8
if ARGV.size > 0
  days = ARGV[0].to_i + 1
end

gilded_rose = GildedRose.new items
(0...days).each do |day|
  puts "-------- day #{day} --------"
  puts "name, sellIn, quality"
  items.each do |item|
    puts item
  end
  puts ""
  gilded_rose.update_quality
end
