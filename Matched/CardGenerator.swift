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
    
    func getSymbols(number: Int) -> [String] {
        let emojis = "❤️😀🐶⭐️🍏🏳️‍🌈📕📱🏖⛵️🚛🧩🏄🏾‍♂️🤸🏼‍♀️💙💚💛🧡💝😂🥰😜😎🥶🤗☠️👻🎃😺😻👍💋👧🏾👀👵🏼👳🏾‍♀️🧕🏽👮🏽‍♂️👩🏻‍⚕️👩🏽‍🎤👩🏻‍💻👩🏼‍🔬👰🏿🦹🏿‍♀️🧟‍♀️🧟‍♂️🤱🏽💇🏽‍♀️💆🏿‍♂️👯‍♂️🚶🏼‍♀️💃🏾🦊🐷🐸🐰🐹🙊🐔🐣"
        var possSymbols = [String]()
        
        for char in emojis {
            possSymbols.append(String(char))
        }
        print("there are \(possSymbols.count) possible emojis")
        possSymbols.shuffle()
        var symbols = [String]()
        for _ in 0..<number {
            symbols.append(possSymbols.popLast()!)
        }
        return symbols
    }
    
    func drawCardBack(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let cornerRadius = size.width / 10
            let roundedRect = UIBezierPath(roundedRect: rectangle, cornerRadius: cornerRadius)
            ctx.cgContext.setFillColor(ColourManager.shared.regular)
            ctx.cgContext.setStrokeColor(ColourManager.shared.pale)
            ctx.cgContext.setLineWidth(5)
            
            //ctx.cgContext.addRect(rectangle)
            ctx.cgContext.addPath(roundedRect.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        return img
    }
    
    func getFaceImage(text: String, size: CGSize) -> UIImage {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        var attributedString: NSAttributedString
        var attrs: [NSAttributedString.Key: Any]
        var fontSize = 36
        var stringSize = CGSize(width: 0, height: 0)
        while stringSize.width < size.width {
            fontSize += 2
            attrs = [
                .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                .paragraphStyle: paragraphStyle
            ]
            
            attributedString = NSAttributedString(string: text, attributes: attrs)
            stringSize = attributedString.size()
        }
        print("now picked \(fontSize) font")
        attrs = [
            .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
            .paragraphStyle: paragraphStyle
        ]
        
        attributedString = NSAttributedString(string: text, attributes: attrs)
        stringSize = attributedString.size()
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            attributedString.draw(at: CGPoint(x: (size.width - stringSize.width) / 2, y: (size.height - stringSize.height) / 2))
        }
        return img
    }
    
}
