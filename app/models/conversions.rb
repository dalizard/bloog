module Conversions
  private
  def TagList(value)
    return value if value.is_a?(TagList)
    TagList.new(value)
  end
end

