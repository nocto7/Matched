//
//  CardFaceGenerator.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import UIKit

class CardGenerator {
    static let shared = CardGenerator()
    
    func getNewCardNames(number items: Int) -> [CardType] {
        let shapes = ["circle", "square"]
        let shades = ["pale","dark","diffpale","diffdark"]
        let numbers = Array(1...4)
        // numoptions = 4*4*2
        var cardTypes = [CardType]()
        for _ in 0..<items {
            var cardType: CardType
            repeat {
                let shape = shapes.randomElement()!
                let shade = shades.randomElement()!
                let number = numbers.randomElement()!
                let name = "\(shape)-\(shade)-\(number)"
                cardType = CardType(name: name, shape: shape, shade: shade, number: number)
            } while cardTypes.contains(where: { (ct) -> Bool in
                let sameShape = (ct.shape == cardType.shape)
                let sameNumber = (ct.number == cardType.number)
                let sameShade = (ct.shade == cardType.shade)
                return sameShape && sameNumber && sameShade
            })
            cardTypes.append(cardType)
        }
        return cardTypes
    }
    
    func drawCardBack(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let cornerRadius = size.width / 10
            let roundedRect = UIBezierPath(roundedRect: rectangle, cornerRadius: cornerRadius)
            ctx.cgContext.setFillColor(ColourManager.shared.dark)
            ctx.cgContext.setStrokeColor(ColourManager.shared.pale)
            ctx.cgContext.setLineWidth(5)
            
            ctx.cgContext.addPath(roundedRect.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        return img
    }
    
    func getNewFaceImage(type: CardType, size: CGSize) -> UIImage {
        // card images go in an inner rectangles
        var innerSquares = [CGRect]()
        let minDimension = min(size.width, size.height)
        let innerDimension = 2 * minDimension / 3
        let xGutter = (size.width - innerDimension) / 2
        let yGutter = (size.height - innerDimension) / 2
        if type.number == 1 {
            innerSquares.append(CGRect(x: xGutter, y: yGutter, width: innerDimension, height: innerDimension))
        } else if type.number == 2 {
            innerSquares.append(CGRect(x: xGutter, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
            innerSquares.shuffle()
            innerSquares.remove(at: 1)
            innerSquares.remove(at: 2)
        } else if type.number == 3 {
            innerSquares.append(CGRect(x: xGutter, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
            innerSquares.shuffle()
            innerSquares.remove(at: 1)
        } else if type.number == 4 {
            innerSquares.append(CGRect(x: xGutter, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
            innerSquares.append(CGRect(x: xGutter + innerDimension/2, y: yGutter + innerDimension/2, width: innerDimension/2, height: innerDimension/2))
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            if type.shade == "pale" {
                ctx.cgContext.setFillColor(ColourManager.shared.palest)
                ctx.cgContext.setStrokeColor(ColourManager.shared.pale)
            } else if type.shade == "dark" {
                ctx.cgContext.setFillColor(ColourManager.shared.darkest)
                ctx.cgContext.setStrokeColor(ColourManager.shared.dark)
            } else if type.shade == "diffpale" {
                ctx.cgContext.setFillColor(ColourManager.shared.diff1pale)
                ctx.cgContext.setStrokeColor(ColourManager.shared.diff1)
            } else if type.shade == "diffdark" {
                ctx.cgContext.setFillColor(ColourManager.shared.diff1dark)
                ctx.cgContext.setStrokeColor(ColourManager.shared.diff1)
            }
            ctx.cgContext.setLineWidth(5)
            for innerSquare in innerSquares {
                if type.shape == "circle" {
                    ctx.cgContext.addEllipse(in: innerSquare)
                } else if type.shape == "square" {
                    ctx.cgContext.addRect(innerSquare)
                }
            }
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img
    }
}
