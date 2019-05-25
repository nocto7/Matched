//
//  CardGridInfo.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import SpriteKit

struct CardGridInfo {
    var rows: Int
    var cols: Int
    var width: CGFloat
    var height: CGFloat
    var rowSpacing: CGFloat
    var colSpacing: CGFloat
    
    var cardSize: CGSize {
        get {
            return CGSize(width: width, height: height)
        }
    }
    
    func position(row: Int, col: Int) -> CGPoint {
        let x = (width + colSpacing) * CGFloat(col) + colSpacing + width / 2
        let y = (height + rowSpacing) * CGFloat(row) + rowSpacing + height / 2
        return CGPoint(x: x, y: y)
    }
    
    init (items: Int, windowSize: CGSize)  {
        
        let screenWidth = windowSize.width
        let screenHeight = windowSize.height
        
        print("screen is \(screenWidth) x \(screenHeight)")
        
        let screenRatio = screenWidth / screenHeight
        print("screen ratio is \(screenRatio)")
        
        let bestRows = sqrt(CGFloat(items) / screenRatio)
        let bestCols = bestRows * screenRatio
        print("best num of rows, cols is \(bestRows), \(bestCols)")
        
        // err on the side of making cards taller than they are wide
        // i.e use more columns
        let numCols = Int(ceil(bestCols))
        var numRows = items / numCols
        while (numRows * numCols < items) {
            numRows += 1
        }
        print("using rows and cols \(numRows), \(numCols)")
        
        if numCols * numRows < items {
            print("there will be spaces in the layout")
        }
        
        let rowsFloat = CGFloat(numRows)
        let colsFloat = CGFloat(numCols)
        
        rows = numRows
        cols = numCols
        
        width = screenWidth /  (colsFloat + (colsFloat + 1) / 5.0)
        height = screenHeight / (rowsFloat + (rowsFloat + 1) / 5.0)
        print("card size is \(width) x \(height)")
        
        colSpacing = width / 5.0
        rowSpacing = height / 5.0
        
//        let grid = CardGridInfo(rows: numRows, cols: numCols, width: cardWidth, height: cardHeight, rowSpacing: rowSpacing, colSpacing: colSpacing)
    
    }
}
