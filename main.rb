# frozen_string_literal: true

require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.display
puts ''
print 'Balanced =>'
p tree.balanced?

tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
tree.insert(105)
tree.insert(108)
tree.insert(1010)

puts 'Tree before balancing'
tree.display
puts ''
print 'Balanced =>'
p tree.balanced?

tree.rebalance
tree.insert(1090)
tree.display
tree.delete(105)
tree.delete(1010)

puts ''
puts 'Tree After balancing'
print 'Balanced => '
p tree.balanced?
puts ''
tree.display
print 'Balanced => '
p tree.balanced?

print 'Level order =>'
p(tree.level_order { |e| e })

print 'Preorder => '
p(tree.preorder { |e| e })

print 'Inorder => '
p(tree.inorder { |e| e })

print 'Postorder => '
p(tree.postorder { |e| e })
