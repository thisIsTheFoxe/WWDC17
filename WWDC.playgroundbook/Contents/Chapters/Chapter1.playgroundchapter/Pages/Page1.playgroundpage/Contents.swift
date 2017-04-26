//#-hidden-code
//
//  Contents.swift
//
//  Made by: Henrik Storch
//
//#-end-hidden-code
/*:
 # **Hello and welcome to my Scholarship PlaygroundBook.**
    
 Today I want to show you a pretty cool way to make music by yourself.
 
 This "way" is called [pentatonics](glossary://pentatonics). And as the name already reveals is pentatonics all about five notes from a "normal" [music scale](glossary://scale).
 The pentatonic scale is different for every new [chord](glossary://chord).
 But these five notes have always the same [interval](glossary://interval) to the [root note](glossary://root%20note) (e.g. in a major chord: 1,3,4,5 and 7).
 
 These different five notes are represented through the different colors of the little square blocks (one color for two notes in two [octaves](glossary://octave) so in total 10 notes for each chord).
 
 **You can change the color of a block by touching it.**
 
 The chord pattern is always the same and the chords change when the ball hits a triangle.
 
 * * *
 
 But thats enough theory let's get started! :D
 
 - - -
 
 When you are finished go to the **[next page](@next)**.
 
*/


//#-hidden-code
//#-code-completion(everything, hide)
//drawGrid(noteValue: .eight)

draw(kind: .TriangleDownLeft, column: 9, row: 9)
draw(kind: .TriangleUpRight, column: 1, row: 1)
draw(kind: .TriangleDownRight, column: 1, row: 9)
draw(kind: .TriangleUpLeft, column: 9, row: 1)
spawnBall(column: 2, row: 2)

//#-end-hidden-code
//#-end-editable-code
