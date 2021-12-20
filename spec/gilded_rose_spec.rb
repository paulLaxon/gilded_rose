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
    items = [Item.new(SULFURAS, 11, 80)]
    inventory = described_class.new(items)

    it 'never has to be sold' do
      inventory.update_quality
      expect(items[0].sell_in).to eq(11)
    end

    it 'the quality never changes and is always 80' do
      expect(items[0].quality).to eq(80)
    end
  end
end
