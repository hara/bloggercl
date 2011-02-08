# coding: utf-8

class String
  def ends_with?(value)
    value = value.to_s
    index(value) == length - value.length
  end
end

