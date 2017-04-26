//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 In the same way you can make the blocks.
 
 To do so you can use the `draw(kind: Kind, column: Int, row: Int)` function.
 
 The kind or [type](glossary://type) of a block can either be `.Square` or `.TriangleDirection`.
 
 The `Direction` is the direction the [hypotenuse](glossary://hypotenuse) is facing (e.g. `DownLeft` meaning that the triangle has a right angle in the top right corner of the block).
 
 
 * callout(Notice):
 To change the balls direction you need to set a triangle block.
 
 Now try making your own [rhythmic](glossary://rhythm) music loop.
 - - -
 If you are done you can check out the **[last page](@next)**.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, spawnBall(column:row:), draw(kind:column:row:), GameBlock, Square, TriangleDownLeft, TriangleUpLeft, TriangleDownRight, TriangleUpRight)



//#-end-hidden-code
//making the 4 corners:
draw(kind: .TriangleDownLeft, column: 9, row: 9)
draw(kind: .TriangleUpRight, column: 1, row: 1)
draw(kind: .TriangleDownRight, column: 1, row: 9)
draw(kind: .TriangleUpLeft, column: 9, row: 1)

//#-editable-code Tap to add/edit the Code

spawnBall(column: 5, row: 9)

draw(kind: .TriangleUpLeft, column: 4, row: 1)
draw(kind: .TriangleUpRight, column: 6, row: 1)
draw(kind: .TriangleDownRight, column: 2, row: 4)
draw(kind: .TriangleDownRight, column: 6, row: 1)
draw(kind: .TriangleDownRight, column: 6, row: 4)
draw(kind: .TriangleDownLeft, column: 8, row: 4)
draw(kind: .TriangleDownLeft, column: 4, row: 4)
for i in 1...4 {
    draw(kind: .Square, column: 5, row: i)
}
for i in 2...8 {
    draw(kind: .Square, column: i, row: 5)
}
//#-end-editable-code
