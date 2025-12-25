# frozen_string_literal: true

require_relative 'node'
require_relative 'helpers'

class Tree
  include Helpers
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def insert(data, root = self.root)
    inserted_node = Node.new(data)

    # if tree is empty assign inserted node to root
    return self.root = inserted_node if self.root.nil?
    return inserted_node if root.nil?

    if data < root.data
      root.left = insert(data, root.left)
    elsif data > root.data
      root.right = insert(data, root.right)
    end
    root
  end

  def delete(data)
    targeted_node = find(data)
    return unless targeted_node

    return delete_leaf_node(data) if targeted_node.leaf?

    return delete_one_child_node(data) if targeted_node.one_child?

    delete_two_children_node(data) if targeted_node.two_children?
  end

  def find(data, root = self.root)
    return if root.nil?

    return root if root.data == data

    if data < root.data
      find(data, root.left)
    else
      find(data, root.right)
    end
  end

  def depth(data, root = self.root, depth = 0)
    return if root.nil?

    return depth if root.data == data

    if data < root.data
      depth(data, root.left, depth + 1)
    else
      depth(data, root.right, depth + 1)
    end
  end

  def height(data, root = find(data), heights = [], height = 0)
    return heights.max if root.nil?

    height(data, root.left, heights, height + 1)
    heights << height
    height(data, root.right, heights, height + 1)
  end

  def level_order(root = self.root, queue = [root], values = [], &block)
    return values if root.nil?

    queue << root.left if root.left
    queue << root.right if root.right

    current_value = queue.shift.data
    current_value = yield current_value if block_given?
    values << current_value if current_value

    level_order(queue.first, queue, values, &block)
  end

  def preorder(root = self.root, values = [], &block)
    return values if root.nil?

    if block_given?
      current_value = yield root.data
      values << current_value if current_value
    else
      values << root.data
    end
    preorder(root.left, values, &block)
    preorder(root.right, values, &block)
  end

  def inorder(root = self.root, values = [], &block)
    return values if root.nil?

    inorder(root.left, values, &block)
    if block_given?
      current_value = yield root.data
      values << current_value if current_value
    else
      values << root.data
    end
    inorder(root.right, values, &block)
  end

  def postorder(root = self.root, values = [], &block)
    return values if root.nil?

    postorder(root.left, values, &block)
    postorder(root.right, values, &block)
    if block_given?
      current_value = yield root.data
      values << current_value if current_value
    else
      values << root.data
    end
  end

  def balanced?(root = self.root)
    left = height(root.data, root.left)
    right = height(root.data, root.right)

    p [left, right]
    return true if (left - right).between?(-1, 1)

    false
  end

  def rebalance
    return if balanced?

    array_of_values = inorder
    self.root = build_tree(array_of_values)
  end
end

tree = Tree.new((1..9).to_a)

tree.display
p tree.balanced?
p tree.height(5)
tree.insert(2.5)
tree.insert(2.6)
tree.insert(2.5)
tree.insert(1.8)
tree.insert(0.8)
tree.insert(0.2)
tree.insert(0.2)
tree.insert(0.4)
tree.display
p tree.balanced?
tree.rebalance
tree.display

print 'Level order =>'
p(tree.level_order { |e| e + 1 })

print 'Preorder => '
p(tree.preorder { |e| e + 1 })

print 'Inorder => '
p(tree.inorder { |e| e + 1 })

print 'Postorder => '
p(tree.postorder { |e| e + 1 })
