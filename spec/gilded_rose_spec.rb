require 'spec_helper'
require 'byebug'
require './gilded_rose'

GENERIC = 'normal'.freeze
BRIE = 'Aged Brie'.freeze
SULFURAS = 'Sulfuras, Hand of Ragnaros'.freeze
PASSES = 'Backstage passes to a TAFKAL80ETC concert'.freeze
CONJURED = 'Conjured Mana Cake'.freeze

describe Items do
  describe 'when updating normal items' do
    items = [GildedRose.for(GENERIC, 8, 0)]
    inventory = described_class.new(items)
    it 'decreases the selling date by 1' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(-1)
    end

    context 'before the sell-by date' do
      it 'decreases the quality by 1' do
        expect(items[0].quality).to eq(7)
      end
    end

    context 'after the sell-by date' do
      it 'decreases the quality by 2' do
        inventory.update_quality
        expect(items[0].quality).to eq(5)
      end

      it 'the sell_by continues to decrease for every update' do
        inventory.update_quality
        expect(items[0].days_remaining).to eq(-3)
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
    items = [GildedRose.for(BRIE, 48, 2)]
    inventory = described_class.new(items)

    it 'the days_remaining date decreases by 1' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(1)
    end

    it 'the quality increases by 1 as it gets older' do
      expect(items[0].quality).to eq(49)
    end

    it 'the quality is never > 50' do
      items = [GildedRose.for(BRIE, 49, 3)]
      inventory = described_class.new(items)
      3.times { inventory.update_quality }
      expect(items[0].quality).to eq(50)
    end

    it 'the sell_by continues to decrease for every update' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(-1)
    end
  end

  describe 'when updating passes' do
    items = [GildedRose.for(PASSES, 24, 11)]
    inventory = described_class.new(items)

    it 'the days_remaining date decreases by 1' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(10)
    end

    it 'the quality increases by 1 when days_remaining days is > 10' do
      expect(items[0].quality).to eq(25)
    end

    it 'the quality increases by 2 when days_remaining days is > 5 and less <= 10' do
      5.times { inventory.update_quality }
      expect(items[0].quality).to eq(35)
    end

    it 'the quality increases by 3 when days_remaining days is <= 5 and >= 0' do
      5.times { inventory.update_quality }
      expect(items[0].quality).to eq(50)
    end

    it 'the quality is 0 when the sell_by date < 0' do
      inventory.update_quality
      expect(items[0].quality).to eq(0)
    end

    it 'the sell_by continues to decrease for every update' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(-2)
    end

    it 'the quality is never > 50' do
      items = [GildedRose.for(PASSES, 48, 3)]
      inventory = described_class.new(items)
      inventory.update_quality
      expect(items[0].quality).to eq(50)
    end
  end

  describe 'when updating sulfuras' do
    items = [GildedRose.for(SULFURAS, 80, 11)]
    inventory = described_class.new(items)

    it 'never has to be sold' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(11)
    end

    it 'the quality never changes and is always 80' do
      expect(items[0].quality).to eq(80)
    end
  end

  describe 'when updating conjured item' do
    items = [GildedRose.for(CONJURED, 8, 0)]
    inventory = described_class.new(items)
    it 'decreases the selling date by 1' do
      inventory.update_quality
      expect(items[0].days_remaining).to eq(-1)
    end

    context 'before the sell-by date' do
      it 'decreases the quality by 2' do
        expect(items[0].quality).to eq(6)
      end
    end

    context 'after the sell-by date' do
      it 'decreases the quality by 4' do
        inventory.update_quality
        expect(items[0].quality).to eq(2)
      end

      it 'the sell_by continues to decrease for every update' do
        inventory.update_quality
        expect(items[0].days_remaining).to eq(-3)
      end
    end

    context 'the quality' do
      it 'is never negative' do
        2.times { inventory.update_quality }
        expect(items[0].quality).to be(0)
      end
    end
  end
end
