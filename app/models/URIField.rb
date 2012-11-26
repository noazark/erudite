class URIField

  attr_reader :string

  def initialize(string)
    @string = string
  end

  def mongoize
    URIField.normalize string
  end

  def to_s
    mongoize
  end

  class << self
    def normalize(string)
      URI.parse(string).normalize.to_s rescue string.to_s
    end

    def demongoize(object)
      URIField.new(object)
    end

    def mongoize(object)
      case object
      when URIField then object.mongoize
      when String then normalize object
      else object
      end
    end

    def evolve(object)
      case object
      when URIField then object.mongoize
      when String then normalize object
      else object
      end
    end
  end
end