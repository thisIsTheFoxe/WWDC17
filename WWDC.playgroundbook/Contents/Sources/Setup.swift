//
//
//  Setup.swift
//
//  Made by: Henrik Storch
//
import PlaygroundSupport
import SpriteKit
import UIKit

public enum GameBlock: Int {
    init() {
        self = .None
    }
    case None = -1  //White block, dont play music
    case Square = 0
    case TriangleDownRight = 1
    case TriangleDownLeft = 2
    case TriangleUpLeft = 3
    case TriangleUpRight = 4
}

public enum NoteValue: Int {    //see GameScene.swift line 235
    case half = 1
    case quater = 2
    case eight = 3
    case sixteenth = 4
}

public func draw(kind: GameBlock, column: Int, row: Int){
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .array([PlaygroundValue.string("draw"), PlaygroundValue.integer(kind.rawValue), PlaygroundValue.integer(column), PlaygroundValue.integer(row)])
        proxy.send(message)     //message[0] is name of function
    }
}

public func spawnBall(column: Int, row:Int){
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .array([PlaygroundValue.string("spawnBall"), PlaygroundValue.integer(column), PlaygroundValue.integer(row)])
        proxy.send(message)     //message[0] is name of function
    }
}
