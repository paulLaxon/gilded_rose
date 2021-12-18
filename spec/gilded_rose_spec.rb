require 'spec_helper'
require 'byebug'
require './gilded_rose'

describe GildedRose do
  describe '#update_quality' do
    item_names = [
      'Generic Item',
      '+5 Dexterity Vest',
      'Elixir of the Mongoose',
      'Aged Brie',
      'Sulfuras, Hand of Ragnaros',
      'Backstage passes to a TAFKAL80ETC concert',
    ]

    SULFURAS_QUALITY = 80.freeze
    MAX_QUALITY = 50.freeze
  
    context 'for any item' do
      items = []
      days = 1
      quality = 0
    
      item_names.each do |name|
        items.push(Item.new(name, days, quality))
      end
    
      described_class.new(items).update_quality()
  
      items.each_with_index do |item, index|
        next if item.name == item_names[4]
        puts "#{index}. #{item.name} should be #{item_names[index]}"
        it 'does not change the name' do
            expect(item.name).to eq item_names[index]
        end
        it 'does not reduce the quality to a negative' do
          expect(item.quality).to be >= 0 
        end
        it 'reduces the sell_in date by 1' do
          expect(item.sell_in).to eq days - 1
        end
      end
    end

    context 'for generic items, a +5 dexterity vest and an elixir of the mongoose' do
      days = 1
      quality = 8
      items = [
        Item.new(item_names[0], days, quality), 
        Item.new(item_names[1], days, quality),
        Item.new(item_names[2], days, quality)
      ]
      described_class.new(items).update_quality()
      items.each_with_index do |item|
        it 'decreases the sell_in date by 1' do
            expect(item.sell_in).to eq days - 1
        end
        it 'decreases the quality by 1 before the sell by date' do
          expect(item.quality).to eq quality - 1
        end
      end

      it 'decreases the quality by 2 after the sell by date' do
        described_class.new(items).update_quality()
        items.each do |item|
          expect(item.quality).to eq quality - 3
        end
      end
    end

    context 'for aged brie' do
      days = 1
      quality1 = 8
      quality2 = MAX_QUALITY
      items = [
        Item.new(item_names[3], days, quality1), 
        Item.new(item_names[3], days, quality2)
      ]
      described_class.new(items).update_quality()

      it 'increases in quality as it gets older' do
        expect(items[0].quality).to eq quality1 + 1
      end
      it 'cannot have a quality greater than 50' do
        expect(items[1].quality).to eq MAX_QUALITY
      end

      context 'after reaching sell date' do
        it 'continues to increase in quality' do
          described_class.new(items).update_quality()
          expect(items[0].quality).to eq quality1 + 3
        end
        it 'cannot have a quality greater than 50' do
          expect(items[1].quality).to eq MAX_QUALITY
        end
      end
    end

    context 'for Sulfuras, Hand of Ragnaros' do
      days = 1
      quality = 80
      items = [Item.new(item_names[4], days, quality)]
      described_class.new(items).update_quality()

      it 'has a fixed quality of 80' do
        expect(items[0].quality).to eq SULFURAS_QUALITY
      end
      it 'does not change the sell_in date' do
        expect(items[0].sell_in).to eq days
      end
    end

    context 'for Backstage passes to a TAFKAL80ETC concert' do
      days = [15, 10, 5, 0]
      quality = 47
      items = []
      days.each do |day|
        items.push(Item.new(item_names[5], day, quality))
      end
      
      described_class.new(items).update_quality()

      it 'increases in quality by 1 if sell_in date > 10' do
        expect(items[0].quality).to eq quality + 1
      end
      it 'increases in quality by 2 if sell_in date is > 5 and <= 10' do
        expect(items[1].quality).to eq quality + 2
      end
      it 'increases in quality by 3 as sell_in date is <= 5' do
        expect(items[2].quality).to eq quality + 3
      end
      it 'decreases quality to 0 after the sell_in date' do
        expect(items[3].quality).to eq 0
      end
    end

    xit context 'for Conjured Mana Cake' do
      days = 1
      quality = 15
      items = [
        Item.new(item_names[6], days, quality), 
      ]
      described_class.new(items).update_quality()

      it 'decreases in quality by 2 before sell_in date' do
        expect(items[0].quality).to eq quality - 2
      end
      it 'decreases in quality by 4 after sell_in date' do
        described_class.new(items).update_quality()
        expect(items[0].quality).to eq quality - 6
      end
    end
  end
end
