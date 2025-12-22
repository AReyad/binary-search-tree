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

  def delete(data)
    targeted_node = find(data)
    return unless targeted_node

    return delete_leaf_node(data) if targeted_node.leaf?

    return delete_one_child_node(data) if targeted_node.left.nil? || targeted_node.right.nil?

    delete_two_children_node(data) if targeted_node.left && targeted_node.right
  end

  def find(data, root = self.root)
    until root.nil? || root.data == data
      root = if data < root.data
               root.left
             else
               root.right
             end
    end
    root
  end

  def display(node = @root, prefix = '', is_left = true)
    display(node&.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node&.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node&.data}"
    display(node&.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node&.left
  end

  # private

  def delete_leaf_node(data, root = self.root)
    return if root&.data == data

    if data < root.data
      root.left = delete_leaf_node(data, root.left)
    else
      root.right = delete_leaf_node(data, root.right)
    end
    root
  end

  def delete_one_child_node(data)
    parent_node = get_parent_node(data)

    if parent_node.data > data
      parent_node.left = parent_node.left.left || parent_node.left.right
    else
      parent_node.right = parent_node.right.right || parent_node.right.left
    end
  end

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

  def delete_two_children_node(data)
    successor = get_successor(data)
    targeted_node = find(data)
    targeted_node.data = successor.data
  end

  def get_parent_node(data, root = self.root)
    return root if root.left&.data == data || root.right.data == data

    if data < root.data
      root.left = get_parent_node(data, root.left)
    else
      root.right = get_parent_node(data, root.right)
    end
  end

  def get_successor(data)
    targeted_node = find(data).right
    targeted_node = targeted_node.left until targeted_node.left.nil?
    delete(targeted_node.data)
    targeted_node
  end

  def level_order(root = self.root, queue = [], values = [])
    return if root.nil?

    queue << root
    until queue.empty?
      root = queue.first
      queue << root.left if root.left
      queue << root.right if root.right
      block_given? ? yield(queue.shift) : values << queue.shift.data
    end
    values
  end
end
