//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 
 Next, try to change the [parameter](glossary://parameter) from the:
 
 `spawnBall(column: Int, row: Int)` [function](glossary://function) to set the start position from the ball.
 
 The `column` and `row` describes the position of the ball and can be seen as [coordinates](glossary://coordinates) of a 2-dimensional [array](glossary://array).
 They can be any values between 1 and 8 which are the corners. E.g. (1, 1) is the corner on the bottom left where the triangle is.
 
 Once the ball is created, he wants to get as fast away from the center of the grid as possible.
 
 * callout(Notice):
 You cannot spawn the ball inside another block or outside the grid.
 - - -
 **Challenge:** Try to spawn the ball inside the inner square.
 - - -
 By clicking: **[here :D](@next)** you can come to the next page.
 */

//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, spawnBall(column:row:))

draw(kind: .TriangleDownLeft, column: 9, row: 9)
draw(kind: .TriangleUpRight, column: 1, row: 1)
draw(kind: .TriangleDownRight, column: 1, row: 9)
draw(kind: .TriangleUpLeft, column: 9, row: 1)

for i in 4...8 {
    draw(kind: .Square, column: 7, row: i)
}

for i in 4...7{
    draw(kind: .Square, column: i, row: 3)
}

for i in 3...6{
    draw(kind: .Square, column: 3, row: i)
}


draw(kind: .TriangleUpLeft, column: 6, row: 4)
draw(kind: .TriangleDownLeft, column: 6, row: 8)


draw(kind: .TriangleUpRight, column: 4, row: 4)
draw(kind: .Square, column: 4, row: 6)

//#-end-hidden-code
//#-editable-code
spawnBall(column: 8, row: 6)
//#-end-editable-code
