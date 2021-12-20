require 'spec_helper'
require 'byebug'
require './gilded_rose'

GENERIC = 'Generic Items'.freeze
BRIE = 'Aged Brie'.freeze
SULFURAS = 'Sulfuras, Hand of Ragnaros'.freeze
PASSES = 'Backstage passes to a TAFKAL80ETC concert'.freeze

describe GildedRose do
  describe 'when updating normal items' do
    items = [Item.new(GENERIC, 1, 16)]
    inventory = described_class.new(items)

    it 'decreases the selling date by 1' do
      inventory = described_class.new(items)
      inventory.update_quality
      expect(items[0].sell_in).to eq(0)
    end

    context 'before the sell-by date' do
      it 'decreases the quality by 1' do
        expect(items[0].quality).to eq(15)
      end
    end

    context 'after the sell-by date' do
      it 'decreases the quality by 2' do
        inventory.update_quality
        expect(items[0].quality).to eq(13)
      end
    end

    context 'the quality' do
      it 'is never negative' do
        7.times { inventory.update_quality }
        expect(items[0].quality).to be(0)
      end
    end
  end

  describe 'when updating brie' do
    items = [Item.new(BRIE, 2, 48)]
    inventory = described_class.new(items)

    it 'the sell_in date decreases by 1' do
      inventory.update_quality
      expect(items[0].sell_in).to eq(1)
    end

    it 'the quality increases by 1 as it gets older' do
      expect(items[0].quality).to eq(49)
    end

    it 'the quality is never > 50' do
      items = [Item.new(PASSES, 3, 49)]
      inventory = described_class.new(items)
      2.times { inventory.update_quality }
      expect(items[0].quality).to eq(50)
    end
  end

  describe 'when updating passes' do
    items = [Item.new(PASSES, 11, 24)]
    inventory = described_class.new(items)

    it 'the sell_in date decreases by 1' do
      inventory.update_quality
      expect(items[0].sell_in).to eq(10)
    end

    it 'the quality increases by 1 when sell_in days is > 10' do
      expect(items[0].quality).to eq(25)
    end

    it 'the quality increases by 2 when sell_in days is > 5 and less <= 10' do
      5.times { inventory.update_quality }
      expect(items[0].quality).to eq(35)
    end

    it 'the quality increases by 3 when sell_in days is <= 5 and >= 0' do
      5.times { inventory.update_quality }
      expect(items[0].quality).to eq(50)
    end

    it 'the quality is 0 when the sell_by date < 0' do
      inventory.update_quality
      expect(items[0].quality).to eq(0)
    end

    it 'the quality is never > 50' do
      items = [Item.new(PASSES, 3, 48)]
      inventory = described_class.new(items)
      inventory.update_quality
      expect(items[0].quality).to eq(50)
    end
  end

  describe 'when updating sulfuras' do
    items = [Item.new(SULFURAS, 11, 24)]
    inventory = described_class.new(items)

    it 'never has to be sold' do
      inventory.update_quality
      expect(items[0].sell_in).to eq(11)
    end

    it 'the quality never changes' do
      expect(items[0].quality).to eq(24)
    end
  end
end

# describe '#update_quality' do
#   item_names = {
#     :generic => 'Generic Item',
#     :vest => '+5 Dexterity Vest',
#     :elixir => 'Elixir of the Mongoose',
#     :brie => 'Aged Brie',
#     :sulfura => 'Sulfuras, Hand of Ragnaros',
#     :passes => 'Backstage passes to a TAFKAL80ETC concert',
#   }

#   SULFURAS_QUALITY = 80.freeze
#   MAX_QUALITY = 50.freeze

#   context 'for any item' do
#     items = []
#     days = 1
#     quality = 0
  
#     item_names.each do |name|
#       items.push(Item.new(name, days, quality))
#     end
  
#     described_class.new(items).update_quality()

#     items.each do |item|
#       next if item.name == item_names[:sulfuras]
#       it 'does not reduce the quality to a negative' do
#         expect(item.quality).to be >= 0 
#       end
#       it 'reduces the sell_in date by 1' do
#         expect(item.sell_in).to eq days - 1
#       end
#     end
#   end

#   context 'for generic items, a +5 dexterity vest and an elixir of the mongoose' do
#     days = 1
#     quality = 8
#     items = [
#       Item.new(item_names[:generic], days, quality), 
#       Item.new(item_names[:vest], days, quality),
#       Item.new(item_names[:elixir], days, quality)
#     ]
#     described_class.new(items).update_quality()
#     items.each_with_index do |item|
#       it 'decreases the sell_in date by 1' do
#           expect(item.sell_in).to eq days - 1
#       end
#       it 'decreases the quality by 1 before the sell by date' do
#         expect(item.quality).to eq quality - 1
#       end
#     end

#     it 'decreases the quality by 2 after the sell by date' do
#       described_class.new(items).update_quality()
#       items.each do |item|
#         expect(item.quality).to eq quality - 3
#       end
#     end
#   end

#   context 'for aged brie' do
#     days = 1
#     quality1 = 8
#     quality2 = MAX_QUALITY
#     items = [
#       Item.new(item_names[:brie], days, quality1), 
#       Item.new(item_names[:brie], days, quality2)
#     ]
#     described_class.new(items).update_quality()

#     it 'increases in quality as it gets older' do
#       expect(items[0].quality).to eq quality1 + 1
#     end
#     it 'cannot have a quality greater than 50' do
#       expect(items[1].quality).to eq MAX_QUALITY
#     end

#     context 'after reaching sell date' do
#       it 'continues to increase in quality' do
#         described_class.new(items).update_quality()
#         expect(items[0].quality).to eq quality1 + 3
#       end
#       it 'cannot have a quality greater than 50' do
#         expect(items[11].quality).to eq MAX_QUALITY
#       end
#     end
#   end

#   context 'for Sulfuras, Hand of Ragnaros' do
#     days = 1
#     quality = 80
#     items = [Item.new(item_names[:sulferas], days, quality)]
#     described_class.new(items).update_quality()

#     it 'has a fixed quality of 80' do
#       expect(items[0].quality).to eq SULFURAS_QUALITY
#     end
#     it 'does not change the sell_in date' do
#       expect(items[0].sell_in).to eq days
#     end
#   end

#   context 'for Backstage passes to a TAFKAL80ETC concert' do
#     days = [15, 10, 5, 0]
#     quality = 47
#     items = []
#     days.each do |day|
#       items.push(Item.new(item_names[:passes], day, quality))
#     end
    
#     described_class.new(items).update_quality()

#     it 'increases in quality by 1 if sell_in date > 10' do
#       expect(items[0].quality).to eq quality + 1
#     end
#     it 'increases in quality by 2 if sell_in date is > 5 and <= 10' do
#       expect(items[1].quality).to eq quality + 2
#     end
#     it 'increases in quality by 3 as sell_in date is <= 5' do
#       expect(items[2].quality).to eq quality + 3
#     end
#     it 'decreases quality to 0 after the sell_in date' do
#       expect(items[3].quality).to eq 0
#     end
#   end

#   xit context 'for Conjured Mana Cake' do
#     days = 1
#     quality = 15
#     items = [
#       Item.new(item_names[:conjured], days, quality), 
#     ]
#     described_class.new(items).update_quality()

#     it 'decreases in quality by 2 before sell_in date' do
#       expect(items[0].quality).to eq quality - 2
#     end
#     it 'decreases in quality by 4 after sell_in date' do
#       described_class.new(items).update_quality()
#       expect(items[0].quality).to eq quality - 6
#     end
#   end
# end
