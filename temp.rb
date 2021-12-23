class GildedRose
  def initialize(items)
    @items = items
  end

  def normal_update(item)
    new_item = Normal.new(item.quality, item.days_remaining)
    new_item.update(new_item)
  end

  def brie_update(item)
    item.days_remaining -= 1
    item.quality += 1
    item.quality = 50 if item.quality > 50
  end

  def passes_update(item)
    item.days_remaining -= 1
    item.quality += 1

    item.quality += 1 if item.days_remaining < 10
    item.quality += 1 if item.days_remaining < 5
    item.quality = 0 if item.days_remaining.negative?

    item.quality = 50 if item.quality > 50
  end

  def sulfuras_update(item); end

  def update_quality
    @items.each do |item|
      update(item)
    end
  end

  def self.update(item)
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      sulfuras_update(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      passes_update(item)
    when 'Aged Brie'
      brie_update(item)
    else
      normal_update(item)
    end
  end

  class Normal
    attr_reader :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality = quality
      @days_remaining = days_remaining
    end
  
    def update
      @days_remaining -= 1
      @quality -= 1
      @quality -= 1 if @days_remaining.negative?
      @quality = 0 if @quality.negative?
    end
  end  
end

class Item
  attr_accessor :name, :days_remaining, :quality

  def initialize(name, days_remaining, quality)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end
end
