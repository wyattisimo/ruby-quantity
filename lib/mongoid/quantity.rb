class Quantity < Numeric

  # Converts an object of this instance into a database friendly value.
  def mongoize
    h = {
      value: value,
      unit:  unit,
    }
    h[:string] = @value.mongoize if @value.is_a?(BigDecimal)
    return h
  end

  class << self

    # Convert the object from its Mongo-friendly type to an instance of this class.
    def demongoize(object)
      if object.is_a?(BSON::Document)
        object[:value] = object.delete(:string).to_d if object[:unit] == FLOAT
        self.new(object)
      else
        object
      end
    end

    # Converts the given object into the Mongo-friendly value for this class.
    def mongoize(object)
      case object
      when Quantity
        object.mongoize
      when Numeric
        self.new(object).mongoize
      else
        object
      end
    end

  end

end
