# frozen_string_literal: true

require_relative 'node'
require_relative 'helpers'

class Tree
  include Helpers
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def insert(data, curent_node = root)
    inserted_node = Node.new(data)

    # if tree is empty assign inserted node to root
    return self.root = inserted_node if root.nil?
    return inserted_node if curent_node.nil?

    if data < curent_node.data
      curent_node.left = insert(data, curent_node.left)
    elsif data > curent_node.data
      curent_node.right = insert(data, curent_node.right)
    end
    curent_node
  end

  def delete(data, current_node = root)
    return current_node if current_node.nil?

    if data < current_node.data
      current_node.left = delete(data, current_node.left)
    elsif data > current_node.data
      current_node.right = delete(data, current_node.right)
    else
      return delete_one_child_node(current_node) if current_node.one_child?

      delete_two_children_node(current_node) if current_node.two_children?
    end
    current_node
  end

  def find(data, current_node = root)
    p "Called on #{current_node&.data}"
    return if current_node.nil?

    return current_node if current_node.data == data

    if data < current_node.data
      find(data, current_node.left)
    else
      find(data, current_node.right)
    end
  end

  def depth(data, current_node = root, depth = 0)
    return if current_node.nil?

    return depth if current_node.data == data

    if data < current_node.data
      depth(data, current_node.left, depth + 1)
    else
      depth(data, current_node.right, depth + 1)
    end
  end

  def height(data, current_node = find(data), heights = [], height = 0)
    return 0 if current_node.nil?

    height(data, current_node.left, heights, height + 1)
    heights << height
    height(data, current_node.right, heights, height + 1)
    heights.max
  end

  def level_order(current_node = root, queue = [root], values = [], &block)
    return values if current_node.nil?

    queue << current_node.left if current_node.left
    queue << current_node.right if current_node.right

    current_value = queue.shift.data
    current_value = yield current_value if block_given?
    values << current_value if current_value

    level_order(queue.first, queue, values, &block)
  end

  def preorder(current_node = root, values = [], &block)
    return values if current_node.nil?

    if block_given?
      current_value = yield current_node.data
      values << current_value if current_value
    else
      values << current_node.data
    end
    preorder(current_node.left, values, &block)
    preorder(current_node.right, values, &block)
  end

  def inorder(current_node = root, values = [], &block)
    return values if current_node.nil?

    inorder(current_node.left, values, &block)
    if block_given?
      current_value = yield current_node.data
      values << current_value if current_value
    else
      values << current_node.data
    end
    inorder(current_node.right, values, &block)
  end

  def postorder(current_node = root, values = [], &block)
    return values if current_node.nil?

    postorder(current_node.left, values, &block)
    postorder(current_node.right, values, &block)
    if block_given?
      current_value = yield current_node.data
      values << current_value if current_value
    else
      values << current_node.data
    end
  end

  def balanced?(root = self.root, sum = [])
    return true if root.nil?

    left = height(root.data, root.left)
    right = height(root.data, root.right)

    balanced?(root.left, sum)
    balanced?(root.right, sum)
    sum << (left - right).abs
    sum.max <= 1
  end

  def rebalance
    return if balanced?

    array_of_values = inorder
    self.root = build_tree(array_of_values)
  end
end
