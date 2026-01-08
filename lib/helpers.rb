module Helpers
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

  def delete_leaf_node(data, current_node = root)
    return if current_node&.data == data

    if data < current_node.data
      current_node.left = delete_leaf_node(data, current_node.left)
    else
      current_node.right = delete_leaf_node(data, current_node.right)
    end
    current_node
  end

  def delete_one_child_node(node)
    if node.left
      left = node.left
      node.left = nil
      left
    else
      right = node.right
      node.right = nil
      right
    end
  end

  def delete_two_children_node(node)
    successor = get_successor(node)
    successor_data = successor.data

    delete(successor_data)
    node.data = successor_data
  end

  def get_successor(node)
    targeted_node = node.right
    targeted_node = targeted_node.left until targeted_node.left.nil?
    targeted_node
  end

  def balanced?(current_node = root, sum = [])
    return true if current_node.nil?

    left = height(current_node.data, current_node.left)
    right = height(current_node.data, current_node.right)

    balanced?(current_node.left, sum)
    balanced?(current_node.right, sum)
    sum << (left - right).abs
    sum.max <= 1
  end

  def display(node = @root, prefix = '', is_left = true)
    display(node&.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node&.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node&.data}"
    display(node&.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node&.left
  end
end
