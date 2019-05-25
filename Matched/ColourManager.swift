//
//  ColourManager.swift
//  Matched
//
//  Created by kirsty darbyshire on 24/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import UIKit

struct ColourScheme {
    let pale: CGColor
    let palest: CGColor
    let regular: CGColor
    let dark: CGColor
    let darkest: CGColor
    let diff1: CGColor
    let diff1pale: CGColor
    let diff1dark: CGColor
}

class ColourManager {
    static let shared = ColourManager()
    private var colourScheme: ColourScheme!
    var currentColour = "Yellow"
    private let colours = ["Yellow", "Blue", "Pink", "Purple"]
    
    var pale: CGColor {
        get {
            return colourScheme.pale
        }
    }
    
    var palest: CGColor {
        get {
            return colourScheme.palest
        }
    }
    
    var regular: CGColor {
        get {
            return colourScheme.regular
        }
    }
    
    var dark: CGColor {
        get {
            return colourScheme.dark
        }
    }
    
    var darkest: CGColor {
        get {
            return colourScheme.darkest
        }
    }
    
    var diff1: CGColor {
        get {
            return colourScheme.diff1
        }
    }
    
    var diff1dark: CGColor {
        get {
            return colourScheme.diff1dark
        }
    }
    
    var diff1pale: CGColor {
        get {
            return colourScheme.diff1pale
        }
    }
    
    private init() {
        setupColourScheme()
    }
    
    
    private func setupColourScheme()  {
        
        var colour: String
        repeat {
            colour = colours.randomElement()!
        } while colour == currentColour
        let pale = UIColor(named: "My\(colour)Pale")!.cgColor
        let palest = UIColor(named: "My\(colour)Palest")!.cgColor
        let regular = UIColor(named: "My\(colour)")!.cgColor
        let dark = UIColor(named: "My\(colour)Dark")!.cgColor
        let darkest = UIColor(named: "My\(colour)Darkest")!.cgColor
        
        var anotherColour: String
        repeat {
            anotherColour = colours.randomElement()!
        } while (anotherColour == currentColour)
        let diff1 = UIColor(named: "My\(anotherColour)")!.cgColor
        let diff1pale = UIColor(named: "My\(anotherColour)Pale")!.cgColor
        let diff1dark = UIColor(named: "My\(anotherColour)Dark")!.cgColor
        colourScheme = ColourScheme(pale: pale, palest: palest, regular: regular, dark: dark, darkest: darkest, diff1: diff1, diff1pale: diff1pale, diff1dark: diff1dark)
        currentColour = colour
    }
    
    public func changeColour() {
        setupColourScheme()
    }
    
    public func getAnotherColour() -> CGColor {
        var anotherColour: String
        repeat {
            anotherColour = colours.randomElement()!
        } while (anotherColour == currentColour)
        return UIColor(named: "My\(anotherColour)")!.cgColor
    }
}
