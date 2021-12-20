class GildedRose
  def initialize(items)
    @items = items
  end

  def normal_update(item)
    item.sell_in -= 1
    item.quality -= 1
    item.quality -= 1 if item.sell_in.negative?
    item.quality = 0 if item.quality.negative?
  end

  def brie_update(item)
    item.sell_in -= 1
    item.quality += 1
    item.quality = 50 if item.quality > 50
  end

  def passes_update(item)
    item.sell_in -= 1
    item.quality += 1

    item.quality += 1 if item.sell_in < 10
    item.quality += 1 if item.sell_in < 5
    item.quality = 0 if item.sell_in.negative?

    item.quality = 50 if item.quality > 50
  end

  def sulfuras_update(item);end

  def update_quality
    @items.each do |item|
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
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end
end
