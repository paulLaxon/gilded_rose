class Items
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality
    @new_items = @items.map(&:update)
  end
end

module GildedRose
  def self.for(name, quality, days_remaining)
    (SPECIALIZED_CLASSES[name] || DEFAULT_CLASS).new(quality, days_remaining)
  end

  class Item
    attr_accessor :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality = quality
      @days_remaining = days_remaining
    end

    def update; end
  end

  class Normal < Item
    def update
      @quality -= 1
      @quality -= 1 if @days_remaining.negative?
      @quality = 0 if @quality.negative?
      @days_remaining -= 1
    end
  end

  class Passes < Item
    def update
      @days_remaining -= 1
      @quality += 1

      @quality += 1 if @days_remaining < 10
      @quality += 1 if @days_remaining < 5
      @quality = 0 if @days_remaining.negative?

      @quality = 50 if @quality > 50
    end
  end

  class Brie < Item
    def update
      @days_remaining -= 1
      @quality += 1
      @quality = 50 if @quality > 50
    end
  end

  class Conjured < Item
    def update
      @quality -= 2
      @quality -= 2 if @days_remaining.negative?
      @quality = 0 if @quality.negative?
      @days_remaining -= 1
    end
  end

  DEFAULT_CLASS = Item
  SPECIALIZED_CLASSES = {
    'normal' => Normal,
    'Aged Brie' => Brie,
    'Backstage passes to a TAFKAL80ETC concert' => Passes,
    'Conjured Mana Cake' => Conjured
  }.freeze
end
