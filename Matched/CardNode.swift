//
//  CardNode.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import SpriteKit
import UIKit

class CardNode: SKSpriteNode {
    var faceImage: UIImage!
    var backImage: UIImage!
    var text: String = ""
    var matched = false
    var revealed = false
    
    func setup(text: String, back: UIImage) {
        self.text = text
        name = text
       // self.isUserInteractionEnabled = true
        faceImage = drawCardFace(size: size)
        self.backImage = back
        texture = SKTexture(image: backImage)
    }
    
    func drawCardFace(size: CGSize) -> UIImage {
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
            print("picked \(fontSize) font")
            attrs = [
                .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                .paragraphStyle: paragraphStyle
            ]
            
            attributedString = NSAttributedString(string: text, attributes: attrs)
            stringSize = attributedString.size()
            attributedString.draw(at: CGPoint(x: (size.width - stringSize.width) / 2, y: (size.height - stringSize.height) / 2))
            
        }
        return img
    }
    

    func revealCard(completion: @escaping () -> Void) {
        let flip1 = SKAction.scaleX(to: 0, duration: 0.5)
        let face = SKAction.setTexture(SKTexture(image: faceImage))
        let flip2 = SKAction.scaleX(to: 1, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.2)
        let complete = SKAction.run(completion)
        let sequence = SKAction.sequence([flip1, face, flip2, wait, complete])
        run(sequence)
    }
    
    func concealCard() {
        let flip1 = SKAction.scaleX(to: 0, duration: 0.5)
        let face = SKAction.setTexture(SKTexture(image: backImage))
        let flip2 = SKAction.scaleX(to: 1, duration: 0.5)
        let sequence = SKAction.sequence([flip1, face, flip2])
        run(sequence)
    }
    
    func removeCard() {
        let vanish = SKAction.scale(to: 0, duration: 1.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([vanish, remove])
        run(sequence)
    }
}
