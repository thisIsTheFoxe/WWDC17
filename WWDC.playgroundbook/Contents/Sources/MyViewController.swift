//
//
//  MyViewController.swift
//
//  Made by: Henrik Storch
//
import UIKit
import PlaygroundSupport
import SpriteKit

public class MyViewController: UIViewController {
    
    public var gameScene = GameScene()
    var skView = SKView()
    
    //var spawnedBall = false   (test)
    
    public override func viewDidLoad(){
        super.viewDidLoad()
        
        gameScene = GameScene(size: CGSize(width: 500, height: 500))
        
        gameScene.scaleMode = .aspectFit
        
        skView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: gameScene.size))
        skView.presentScene(gameScene)
        
        /* Debuging:
         skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.showsFields = true
        */
        
        skView.sizeThatFits(CGSize(width: 500, height: 500))
        
        skView.presentScene(gameScene)
        
        self.view = skView
    }
    
    public func drawDefaultGrid(){
        gameScene.drawGrid(noteValue: .eight)
        for row in 2...8{
            let rand = Int(arc4random_uniform(UInt32(15)))
            let color = rand > 9 ? -1 : rand    //
            gameScene.chnangeBlockColor(column: 0, row: row, color: color)
            gameScene.chnangeBlockColor(column: 10, row: row, color: color)
        }
        
        for column in 2...8 {
            let rand = Int(arc4random_uniform(UInt32(15)))
            let color = rand > 9 ? -1 : rand
            gameScene.chnangeBlockColor(column: column, row: 0, color: color)
            gameScene.chnangeBlockColor(column: column, row: 10, color: color)
        }
        
    }
    
    public func drawGrid(noteValue: NoteValue){
        gameScene.drawGrid(noteValue: noteValue)
    }
    
    public func spawnBall(column: Int, row:Int){
        gameScene.spawnBall(column: column, row: row)
    }
    
    public func draw(kind: GameBlock, column: Int, row: Int){
        gameScene.draw(kind: kind, column: column, row: row)
    }
    
    /*public func chnangeBlockColor(column: Int, row: Int, color: Int){  //has bug when trying to fill block (7, x)
        gameScene.chnangeBlockColor(column: column, row: row, color: color)
    }*/

    
}


extension MyViewController : PlaygroundLiveViewMessageHandler{
    public func liveViewMessageConnectionOpened() {
        // We don't need to do anything in particular when the connection opens.
    }
    
    public func liveViewMessageConnectionClosed() {
        // We don't need to do anything in particular when the connection closes.
    }
    
    public func receive(_ message: PlaygroundValue){
        switch message {
        case let .array(array):
            if case let .string(cmd) = array[0]  {
                switch cmd {    //cmd is name of function
                case "draw":
                    if case let .integer(kindValue) = array[1], case let .integer(column) = array[2], case let .integer(row) = array[3] {
                        gameScene.draw(kind: GameBlock(rawValue: kindValue)!, column: column, row: row)
                    }
                    break
                case "spawnBall":
                    if case let .integer(column) = array[1], case let .integer(row) = array[2] {
                        gameScene.spawnBall(column: column, row: row)
                    }
                    break
                case "drawGrid":
                    if case let .integer(noteRawValue) = array[1] {
                        gameScene.drawGrid(noteValue: NoteValue(rawValue: noteRawValue)!)
                    }
                /*case "chnangeBlockColor":     //bug described in line 72
                    if case let .integer(column) = array[1], case let .integer(row) = array[2], case let .integer(color) = array[3] {
                        gameScene.chnangeBlockColor(column: column, row: row, colorr: color)
                    }
                    break*/
                default:
                    //print(message)
                    break
                }
            }
            break   //end case .array
            
        default: break
        }   //end switch message
    }
}


