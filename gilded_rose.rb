class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item.sell_in -= 1
      calculate_quality(item)
    end
  end

  private

  def calculate_quality(item)
    case item.name
    when "Sulfuras, Hand of Ragnaros"
      item.sell_in += 1
    when "Backstage passes to a TAFKAL80ETC concert"
      item.quality = item.quality + 1
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
      item.quality = 0 if item.sell_in < 0
      item.quality = 50 if item.quality > 50
    when "Aged Brie"
      item.quality = item.quality + 1
      item.quality += 1 if item.sell_in < 0
      item.quality = 50 if item.quality > 50
    else
      item.quality = item.quality - 1
      item.quality -= 1 if item.sell_in < 0
      item.quality = 0 if item.quality < 0
    end
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
