class Array
  def filter(matrix)
    self.each_with_index.map {|item, i| item if matrix[i]}.compact
  end
end