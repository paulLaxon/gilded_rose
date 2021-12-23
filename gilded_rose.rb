class GildedRose
  def initialize(items)
    @items = items

    def klass_for(name)
      case name
      when 'normal'
        Normal
      when 'Aged Brie'
        Brie
      when 'Backstage passes to a TAFKAL80ETC concert'
        Passes
      when 'Sulfuras, Hand of Ragnaros'
        Sulfuras
      end
    end
  end

  def update_item(item)
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      sulfuras_item = Sulfuras.new(item.quality, item.days_remaining)
      sulfuras_item.update
      item.quality = sulfuras_item.quality
      item.days_remaining = sulfuras_item.days_remaining
      item
    when 'Backstage passes to a TAFKAL80ETC concert'
      passes_item = Passes.new(item.quality, item.days_remaining)
      passes_item.update
      item.quality = passes_item.quality
      item.days_remaining = passes_item.days_remaining
      item
    when 'Aged Brie'
      brie_item = Brie.new(item.quality, item.days_remaining)
      brie_item.update
      item.quality = brie_item.quality
      item.days_remaining = brie_item.days_remaining
      item
    else
      normal_item = Normal.new(item.quality, item.days_remaining)
      normal_item.update
      item.quality = normal_item.quality
      item.days_remaining = normal_item.days_remaining
      item
    end
  end

  class Sulfuras
    attr_accessor :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality = quality
      @days_remaining = days_remaining
    end

    def update
    end
  end

  class Passes
    attr_accessor :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality = quality
      @days_remaining = days_remaining
    end

    def update
      @days_remaining -= 1
      @quality += 1

      @quality += 1 if @days_remaining < 10
      @quality += 1 if @days_remaining < 5
      @quality = 0 if @days_remaining.negative?

      @quality = 50 if @quality > 50
    end
  end

  class Normal
    attr_accessor :quality, :days_remaining

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

  class Brie
    attr_accessor :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality = quality
      @days_remaining = days_remaining
    end

    def update
      @days_remaining -= 1
      @quality += 1
      @quality = 50 if @quality > 50
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
