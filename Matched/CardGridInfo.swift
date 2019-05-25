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
        let screenRatio = screenWidth / screenHeight
        
        let bestRows = sqrt(CGFloat(items) / screenRatio)
        let bestCols = bestRows * screenRatio
        
        var numCols: Int
        var numRows: Int
        if screenRatio < 1 {
            // err on the side of making cards taller than they are wide
            // i.e use more columns
            numCols = Int(ceil(bestCols))
            numRows = items / numCols
            while (numRows * numCols < items) {
                numRows += 1
            }
        } else {
            // err on the side of making cards wider than they are tall
            // i.e use more rows
            numRows = Int(ceil(bestRows))
            numCols = items / numRows
            while (numRows * numCols < items) {
                numCols += 1
            }
        }
        
        let rowsFloat = CGFloat(numRows)
        let colsFloat = CGFloat(numCols)
        
        rows = numRows
        cols = numCols
        
        width = screenWidth /  (colsFloat + (colsFloat + 1) / 5.0)
        height = screenHeight / (rowsFloat + (rowsFloat + 1) / 5.0)
        
        colSpacing = width / 5.0
        rowSpacing = height / 5.0
    }
}
