# frozen_string_literal: true

require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def insert(data, root = self.root)
    inserted_node = Node.new(data)
    return self.root = inserted_node if self.root.nil? # if tree is empty assign inserted node to root
    return root if root == inserted_node # prevents inserting a duplicate
    return inserted_node if root.nil?

    if data < root.data
      root.left = insert(data, root.left)
    else

      root.right = insert(data, root.right)
    end
    root
  end

  def display(node = @root, prefix = '', is_left = true)
    display(node&.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node&.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node&.data}"
    display(node&.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node&.left
  end

  private

  def build_tree(array)
    unique_sorted_array = array.sort.uniq
    sorted_array_to_bst(unique_sorted_array)
  end

  def sorted_array_to_bst(array, start_point = 0, end_point = array.length - 1)
    return if start_point > end_point

    middle = (start_point + end_point) / 2
    root = Node.new(array[middle])

    root.left = sorted_array_to_bst(array, start_point, middle - 1)
    root.right = sorted_array_to_bst(array, middle + 1, end_point)

    root
  end
end
