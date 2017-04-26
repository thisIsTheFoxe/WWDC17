//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 
 Now it's time to vary even more by changing the total size of the grid.
 
 To do so, use the:
 
 `drawGrid(noteValue: NoteValue)` function.
 
 The `noteValue` tells how long a block is played. And scince one full column or one full row is one [beat](glossary://beat), there is space for:
 * two `.half` notes (or blocks)
 * four `.quater` notes (or blocks) 
 * and so on...
 
 With the function `getEdgeBlockCount(noteValue: NoteValue)` you can get the total count of "spaces" in one column/row.
 
 Also you can programatically change the note of a block with the `chnangeBlockColor(column: Int, row: Int, color: Int)` function. The color equals the note which are 10 in total (so from 0 to 9) as mentioned in [the beginning](How%20pentatonics%20work).
 
 Try playing around with different [rhythms](glossary://rhythm) and notes.
 
 * * *
 
 Have fun and thank you for your attention! :)
 
 This is:
 
 ### **The End**
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, contoller)
//#-code-completion(identifier, show, GameBlock, Square, TriangleDownLeft, TriangleUpLeft, TriangleDownRight, TriangleUpRight)
//#-code-completion(identifier, show, NoteValue, half, quater, sixteenth, eight)

import PlaygroundSupport
import UIKit

let contoller = MyViewController()
PlaygroundPage.current.liveView = contoller

func drawGrid(noteValue: NoteValue) {
    contoller.drawGrid(noteValue: noteValue)
}

public func draw(kind: GameBlock, column: Int, row: Int){
    contoller.draw(kind: kind, column: column, row: row)
}

public func spawnBall(column: Int, row:Int){
    contoller.spawnBall(column: column, row: row)
}

public func chnangeBlockColor(column: Int, row: Int, color: Int){
    contoller.gameScene.chnangeBlockColor(column: column, row: row, color: color)
}

public func getEdgeBlockCount(noteValue: NoteValue) -> Int{
    return Int(pow(2, CGFloat(noteValue.rawValue))) + 3 //see also gameScene.swift line 332
}

public func random(to: Int) -> Int{
    return Int(arc4random_uniform(UInt32(to)))
}

//#-end-hidden-code
//#-editable-code
drawGrid(noteValue: .eight)
let blockCount = getEdgeBlockCount(noteValue: .eight)

spawnBall(column: 7, row: 7)

draw(kind: .TriangleDownLeft, column: blockCount - 2, row: blockCount - 2)
draw(kind: .TriangleUpRight, column: 1, row: 1)
draw(kind: .TriangleDownRight, column: 1, row: blockCount - 2)
draw(kind: .TriangleUpLeft, column: blockCount - 2, row: 1)

for i in 2...blockCount - 3 {
    let rand = random(to: 20) //random number between 0 and 20
    let color = rand > 9 ? -1 : rand //10...20 -> 50% chance of playing nothing
    chnangeBlockColor(column: 0, row: i, color: color)
    chnangeBlockColor(column: blockCount - 1, row: i, color: color)
    chnangeBlockColor(column: i, row: 0, color: color)
    chnangeBlockColor(column: i, row: blockCount - 1, color: color)
}

//#-end-editable-code
