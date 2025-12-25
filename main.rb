# frozen_string_literal: true

require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.display
puts ''
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
tree.insert(105)
tree.insert(108)
tree.insert(1010)
tree.display
puts ''

puts ''

tree.rebalance
tree.display

print 'Balanced => '
p tree.balanced?

print 'Level order =>'
p(tree.level_order { |e| e + 1 })

print 'Preorder => '
p(tree.preorder { |e| e + 1 })

print 'Inorder => '
p(tree.inorder { |e| e + 1 })

print 'Postorder => '
p(tree.postorder { |e| e + 1 })
