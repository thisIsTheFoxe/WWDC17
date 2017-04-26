//
//
//  Sound.swift
//
//  Made by: Henrik Storch
//
import Foundation
import SpriteKit

class Sound {
    
    enum Instrument {
        case pianoChord, guitarNote
    }
    
    enum Key {
        case Am, F, C, G
    }
    
    
    let guitarURLs = ["guitarA1", "guitarC1", "guitarD1", "guitarE1", "guitarG1", "guitarF1", "guitarB1"]
    let guitar2URLs = ["guitarA2", "guitarC2", "guitarD2", "guitarE2", "guitarG2", "guitarF2", "guitarB2", "guitarC3"]  //C3 is never played
    
    
    let pianoURLs = ["pianoA",  "pianoC",   "pianoE", "pianoF",  "pianoG",  "pianoB",  "pianoD"]
    
    var playableNotes:[String] = []
    
    var notes: [SKAudioNode] = []
    
    init(instument: Instrument, key: Key) {
        switch instument {
        case .guitarNote:
            switch key {
            case .Am:
                playableNotes = [guitarURLs[0], guitarURLs[1], guitarURLs[2], guitarURLs[3], guitarURLs[4]]
                
                playableNotes += [guitar2URLs[0], guitar2URLs[1], guitar2URLs[2], guitar2URLs[3], guitar2URLs[4]]
                break
            case .C:
                playableNotes = [guitarURLs[1], guitarURLs[2], guitarURLs[3], guitarURLs[4], guitarURLs[0]]
                playableNotes += [guitar2URLs[1], guitar2URLs[2], guitar2URLs[3], guitar2URLs[4], guitar2URLs[0], guitar2URLs[7]]
                break
            case .F:
                playableNotes = [guitarURLs[5], guitarURLs[4], guitarURLs[0], guitarURLs[1], guitarURLs[2]]
                playableNotes += [guitar2URLs[5], guitar2URLs[4], guitar2URLs[0], guitar2URLs[1], guitar2URLs[2]]
                break
            case .G:
                playableNotes = [guitarURLs[4], guitarURLs[0], guitarURLs[6], guitarURLs[2], guitarURLs[3]]
                playableNotes += [guitar2URLs[4], guitar2URLs[0], guitar2URLs[6], guitar2URLs[2], guitar2URLs[3]]
                break
            }
            break
        case .pianoChord:
            switch key {
            case .Am:
                playableNotes = [pianoURLs[0], pianoURLs[1], pianoURLs[2]]
                break
            case .C:
                playableNotes = [pianoURLs[1], pianoURLs[2], pianoURLs[4]]
                break
            case .F:
                playableNotes = [pianoURLs[3], pianoURLs[0], pianoURLs[1]]
                break
            case .G:
                playableNotes = [pianoURLs[4], pianoURLs[5], pianoURLs[6]]
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func play(note: Int?) -> [SKAudioNode]{
        if note != nil {
            //play guitarURLs[note]
            let url = Bundle.main.url(forResource: playableNotes[note!], withExtension: "wav")
            notes = [SKAudioNode(url: url!)]
            
        }else{
            notes.removeAll()
            for pianoNote in playableNotes {
                //play pianoNotes
                notes.append(SKAudioNode(fileNamed: pianoNote))
                
            }
        }
        return notes
    }
    
}
