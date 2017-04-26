//
//
//  GameScene.swift
//
//  Made by: Henrik Storch
//

import UIKit
import SpriteKit
import AVFoundation

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct physicsConatcts {
        static let block: UInt32 = 0x1 << 0
        static let ball: UInt32 = 0x1 << 1
        //static let frame: UInt32 = 0x1 << 2   //for the scene itself
    }
    
    var musicKey = Sound.Key.Am     //start with A minor chord
    
    var ballSpawned = false
    
    var totalcolumns:CGFloat = 0     //Must alway be 2^x + 2
    var totalRows:CGFloat = 0      // and both must be same!
    
    let globalGravity = CGVector(dx: 6, dy: 5)  //value of gravity. The 'strength' says the same, only directions changes
    
    var grid = Array<Array<SKShapeNode>>()      //array of every 'block' but aren't added to scene, only to get frame etc.
    var blocks = Array<Array<GameBlock>>()      //array that tells which block is which. .None means there is no block
    var blockColors = Array<Array<Int>>()      //Index for color arrayfor the block
    
    let pentatonicColors:[UIColor] = [
     .init(colorLiteralRed: 119/255,    green: 15/255,  blue: 0/255,    alpha: 1),  //root note
     .init(colorLiteralRed: 0/255,      green: 83/255,  blue: 33/255,   alpha: 1),
     .init(colorLiteralRed: 0/255,      green: 55/255,  blue: 97/255,   alpha: 1),
     .init(colorLiteralRed: 82/255,     green: 6/255,   blue: 68/255,   alpha: 1),
     .init(colorLiteralRed: 145/255,    green: 82/255,  blue: 9/255,    alpha: 1),
     .init(colorLiteralRed: 227/255,    green: 6/255,   blue: 19/255,   alpha: 1),  // root note + one octave
     .init(colorLiteralRed: 0/255,      green: 150/255, blue: 64/255,   alpha: 1),
     .init(colorLiteralRed: 0/255,      green: 105/255, blue: 180/255,  alpha: 1),
     .init(colorLiteralRed: 149/255,    green: 27/255,  blue: 129/255,  alpha: 1),
     .init(colorLiteralRed: 149/255,    green: 135/255, blue: 5/255,    alpha: 1)]
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        
        if let posInArray = blockInGrid(pos: location!) {
            let type = blocks[posInArray.column][posInArray.row]
            
            if type == .Square {
                chnangeBlockColor(column: posInArray.column, row: posInArray.row, color: nil)
            }
        }
        
    }
    
    
    override public func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = globalGravity
        
        physicsWorld.speed = 0.5
        
        backgroundColor = .black
        
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node as! SKShapeNode
        let bodyB = contact.bodyB.node as! SKShapeNode
        
        if bodyA.name == "block" || bodyB.name == "block" {
            let theBlock = bodyA.name == "block" ? bodyA : bodyB
            let index = blockInGrid(pos: CGPoint(x: theBlock.frame.midX, y: theBlock.frame.midY))
            let type = blocks[(index?.column)!][(index?.row)!]
            
            let isMoovingUpOrDown = abs(physicsWorld.gravity.dx) > abs(physicsWorld.gravity.dy) ? true : false      //if true the ball ball is moving verticaly, if false ball is moving horizontaly
            
            switch type {
            case .TriangleDownLeft, .TriangleDownRight, .TriangleUpLeft, .TriangleUpRight:
                
                switch musicKey {
                case .Am: musicKey = .C
                case .C: musicKey = .F
                case .F: musicKey = .G
                case .G: musicKey = .Am
                }
                let pianoSound = Sound(instument: .pianoChord, key: musicKey)
                let pianoSoundNodes = pianoSound.play(note: nil)
                for audioNode in pianoSoundNodes {
                    audioNode.autoplayLooped = false
                    theBlock.addChild(audioNode)
                    audioNode.run(SKAction.sequence([SKAction.play(), .wait(forDuration: 2), .removeFromParent()])) //one sound is ca. 2s
                }
            default:
                break
            }
            
            
            switch type {
            case .TriangleDownLeft:
                if isMoovingUpOrDown{
                    physicsWorld.gravity = CGVector(dx: -globalGravity.dy, dy: globalGravity.dx)
                }else{
                    physicsWorld.gravity = CGVector(dx: globalGravity.dx, dy: -globalGravity.dy)
                }
                
            case .TriangleDownRight:
                if isMoovingUpOrDown{
                    physicsWorld.gravity = CGVector(dx: globalGravity.dy, dy: globalGravity.dx)
                }else{
                    physicsWorld.gravity = CGVector(dx: -globalGravity.dx, dy: -globalGravity.dy)
                }
                
            case .TriangleUpLeft:
                if isMoovingUpOrDown{
                    physicsWorld.gravity = CGVector(dx: -globalGravity.dy, dy: -globalGravity.dx)
                }else{
                    physicsWorld.gravity = CGVector(dx: globalGravity.dx, dy: globalGravity.dy)
                }
                
            case .TriangleUpRight:
                if isMoovingUpOrDown{
                    physicsWorld.gravity = CGVector(dx: globalGravity.dy, dy: -globalGravity.dx)
                }else{
                    physicsWorld.gravity = CGVector(dx: -globalGravity.dx, dy: globalGravity.dy)
                }
                
                
            case .Square:
                
                if blockColors[(index?.column)!][(index?.row)!] >= 0{
                    let guitarSound = Sound(instument: .guitarNote, key: musicKey)
                    
                    let guitarSoundNode = guitarSound.play(note: blockColors[(index?.column)!][(index?.row)!])[0]
                    
                    guitarSoundNode.autoplayLooped = false
                    theBlock.addChild(guitarSoundNode)
                    guitarSoundNode.run(SKAction.sequence([SKAction.play(), .wait(forDuration: 2), .removeFromParent()]))   //one sound is ca. 2s
                }
                
                
            default:
                break
            }
            
            let startAction = self.changeColorSKAction(fromColor: theBlock.fillColor, toColor: .gray)
            
            theBlock.name = "coloredBlock"      //so a block is only be played once not all the time while the ball keeps touching it
            
            theBlock.run(SKAction.sequence([startAction, .wait(forDuration: 0.7), SKAction.run {
                theBlock.run(self.changeColorSKAction(fromColor: theBlock.fillColor, toColor: self.getColorForBlock(column: (index?.column)!, row: (index?.row)!)))
                theBlock.name = "block"     //reseting so block can be played again
                }]))
            }
    }
    
    func lerp(a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat{
        return (b-a) * fraction + a
    }
    
    func changeColorSKAction(fromColor : UIColor, toColor : UIColor, duration : Double = 0.2) -> SKAction {
        
        var frgba = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        var trgba = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        
        fromColor.getRed(&frgba[0], green: &frgba[1], blue: &frgba[2], alpha: &frgba[3])
        toColor.getRed(&trgba[0], green: &trgba[1], blue: &trgba[2], alpha: &trgba[3])
        
        return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let transColor = UIColor(red: self.lerp(a: frgba[0], b: trgba[0], fraction: fraction),
                                     green: self.lerp(a: frgba[1], b: trgba[1], fraction: fraction),
                                     blue: self.lerp(a: frgba[2], b: trgba[2], fraction: fraction),
                                     alpha: self.lerp(a: frgba[3], b: trgba[3], fraction: fraction))
            (node as! SKShapeNode).fillColor = transColor
        })
    }
    
    func getColorForBlock(column: Int, row: Int) -> UIColor{
        let colorIdx = blockColors[column][row]
        if colorIdx == -1 {
            return .white
        }else{
            return pentatonicColors[colorIdx]
        }
    }
    
    public func chnangeBlockColor(column: Int, row: Int, color: Int?){
        let pos = posInGrid(column: column, row: row)
        if color == nil {
            var blockColor = blockColors[column][row]
            let theBlock = nodes(at: pos)[0] as! SKShapeNode
            
            blockColor += 1
            
            if blockColor >= pentatonicColors.count {
                blockColors[column][row] = -1
                theBlock.fillColor = .white
            }else{
                theBlock.fillColor = pentatonicColors[blockColor]
                blockColors[column][row] = blockColor
            }
        }else{
            let theBlock = nodes(at: pos)[0] as! SKShapeNode
            blockColors[column][row] = color!
            theBlock.fillColor = color == -1 ? .white : pentatonicColors[color!]
        }
    }
    
/*  public func didEnd(_ contact: SKPhysicsContact) {
     
    }
     */
    
    
    func drawGrid(noteValue: NoteValue){
        if totalRows != 0 && totalcolumns != 0 {
            return
        }
        
        totalcolumns = pow(2, CGFloat(noteValue.rawValue)) + 3   //blocks between 2 Triangles are 2^2 - 1 (+ 2 for the frame and + 2 for the Triangles (one for each side)) => + 3
        totalRows = pow(2, CGFloat(noteValue.rawValue)) + 3
        
        grid = Array(repeating: Array(repeating: SKShapeNode(), count: Int(totalRows)), count: Int(totalcolumns))    //init Arrays
        blocks = Array(repeating: Array(repeating: GameBlock(), count: Int(totalRows)), count: Int(totalcolumns))
        blockColors = Array(repeating: Array(repeating: Int(), count: Int(totalRows)), count: Int(totalcolumns))
        
        let line = SKShapeNode()
        //line.alpha = 0.2
        let path = CGMutablePath()
        for row in 1...Int(totalRows) - 1 {
            path.move(to: CGPoint(x: frame.minX, y: frame.height/totalRows*CGFloat(row)))
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.height/totalRows*CGFloat(row)))
            line.path = path
            addChild(line.copy() as! SKShapeNode)
        }
        
        for column in 1...Int(totalcolumns) - 1 {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: frame.width/totalcolumns*CGFloat(column), y: frame.minY))
            path.addLine(to: CGPoint(x: frame.width/totalcolumns*CGFloat(column), y: frame.maxY))
            line.path = path
            addChild(line.copy() as! SKShapeNode)
        }
        
        for column in 0...Int(totalcolumns) - 1 {
            for row in 0...Int(totalRows) - 1 {
                grid[column][row] = SKShapeNode(rect: CGRect(x: frame.height/totalcolumns * CGFloat(column), y: frame.width/totalRows * CGFloat(row), width: frame.width/totalcolumns, height: frame.width/totalcolumns))
                blockColors[column][row] = -1    //make all blocks white, meaning they dont play any notes
            }
        }
        
        for row in 1...Int(totalRows) - 2 { // - 2 -> leave corners empty
            draw(kind: .Square, column: 0, row: row)
            draw(kind: .Square, column: Int(totalcolumns) - 1, row: row)
        }
        
        for column in 1...Int(totalcolumns) - 2 { // - 2 -> leave corners empty
            draw(kind: .Square, column: column, row: 0)
            draw(kind: .Square, column: column, row: Int(totalRows) - 1)
        }
        //make corners only once:
        draw(kind: .Square, column: 0, row: 0)
        draw(kind: .Square, column: 0, row: Int(totalRows) - 1)
        draw(kind: .Square, column: Int(totalcolumns) - 1, row: 0)
        draw(kind: .Square, column: Int(totalcolumns) - 1, row: Int(totalRows) - 1)
        
    }
    
    func posInGrid(column: Int, row: Int) -> CGPoint {
        let gX = frame.height/CGFloat(totalcolumns) * CGFloat(column) + frame.height/(totalcolumns * 2)
        let gY = frame.width/CGFloat(totalRows) * CGFloat(row) + frame.width/(totalRows * 2)
        
        return CGPoint(x: gX, y: gY)
    }
    
    func blockInGrid(pos: CGPoint) -> (column: Int, row: Int)? {
        for column in 0...Int(totalcolumns) - 1 {
            for row in 0...Int(totalRows) - 1 {
                if grid[column][row].frame.contains(pos) {
                    return (column, row)
                }
            }
        }
        return nil      //block not found
    }
    
    
    func spawnBall(column: Int, row: Int) {
        
        if totalcolumns == 0 || totalRows == 0{
            drawGrid(noteValue: .eight)
        }
        
        let center = posInGrid(column: column, row: row)
        for child in children {
            if child.name == "block" && child.frame.contains(center){
                fatalError("Ball cannot be placed at: \(column, row)")   //FIXME: error is not shown on ipad
            }else if child.name == "ball"{
                child.removeFromParent()
            }
        }
        
        if center.x < frame.width/2 {
            physicsWorld.gravity.dx *= -1
        }
        if center.y < frame.height/2 {
            physicsWorld.gravity.dy *= -1
        }
        
        //gravity = based on spawnpoint from Ball
        
        let rad = frame.width/(totalcolumns*2.5)
        let ball = SKShapeNode(circleOfRadius: rad)
        
        ball.name = "ball"
        ball.position = center
        ball.zPosition = 1
        ball.fillColor = .init(colorLiteralRed: 255/255, green: 237/255, blue: 0/255, alpha: 1)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: rad)
        ball.physicsBody?.contactTestBitMask = physicsConatcts.block
        ball.physicsBody?.categoryBitMask = physicsConatcts.ball
        ball.physicsBody?.collisionBitMask = physicsConatcts.block
        ball.physicsBody?.isDynamic = true
        //to make the ball less bouncy:
        ball.physicsBody?.density = 37
        ball.physicsBody?.linearDamping = 1
        
        addChild(ball)
        
        
    }
    
    func draw(kind: GameBlock, column: Int, row: Int, color: UIColor = .white) {
        
        if totalcolumns == 0 || totalRows == 0 {
            drawGrid(noteValue: .eight)
        }
        
        if column < 0 || column >= Int(totalcolumns) || row < 0 || column >= Int(totalRows) {   //if ball is youtside the grid
            fatalError("Block cannot be placed at: \(column, row)")  //FIXME: error is not shown on ipad
        }
        
        if blocks[column][row] == .None{ //only make new block if there is no block before
            let rect = grid[column][row].frame
            var block = SKShapeNode()
            blocks[column][row] = kind
            
            switch kind {
            case .Square:
                block = SKShapeNode(rect: rect)
            case .TriangleUpLeft:
                let path = CGMutablePath()
                path.move(to: rect.origin)
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                block = SKShapeNode(path: path)
                
            case .TriangleUpRight:
                let path = CGMutablePath()
                path.move(to: rect.origin)
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
                path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
                block = SKShapeNode(path: path)
                
            case .TriangleDownLeft:
                let path = CGMutablePath()
                path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.origin.y))
                block = SKShapeNode(path: path)
                
            case .TriangleDownRight:
                let path = CGMutablePath()
                path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.origin.x, y: rect.maxY))
                path.addLine(to: rect.origin)
                block = SKShapeNode(path: path)
                
            default:
                return
            }
            
            block.name = "block"
            block.fillColor = color
            block.strokeColor = .blue   //TODO: make invisible?
            block.physicsBody = SKPhysicsBody(edgeLoopFrom: block.path!)
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
            block.physicsBody?.collisionBitMask = physicsConatcts.ball
            block.physicsBody?.categoryBitMask = physicsConatcts.block
            block.physicsBody?.contactTestBitMask = physicsConatcts.ball
            
            addChild(block)
            
        }
        
    }
    
}
