class GildedRose

  attr_reader :items
  
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"

      item.sell_in -= 1

      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        item.quality = calculate_quality_passes(item)
      elsif item.name == "Aged Brie"
        item.quality = calculate_quality_brie(item)
      elsif item.name == "Conjured Mana Cake"
        item.quality = calculate_quality_generic(item, 2)
      else
        item.quality = calculate_quality_generic(item, 1)
      end
    end
  end

  private

  def calculate_quality_generic(item, step)
    quality = item.quality - step
    quality -= step if item.sell_in < 0
    quality = 0 if quality < 0
    quality
  end

  def calculate_quality_passes(item)
    quality = item.quality + 1
    quality += 1 if item.sell_in < 11
    quality += 1 if item.sell_in < 6
    quality = 0 if item.sell_in < 0
    quality = 50 if quality > 50
    quality
  end

  def calculate_quality_brie(item)
    quality = item.quality + 1
    quality += 1 if item.sell_in < 0
    quality = 50 if quality > 50
    quality
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
