//
//  SelectBG.swift
//  LovePostalCard
//
//  Created by Seyed Samad Gholamzadeh on 11/4/1394 AP.
//  Copyright © 1394 AP Seyed Samad Gholamzadeh. All rights reserved.
//

import UIKit

class SelectBGLayout: UICollectionViewFlowLayout {
    
    private let numpW: CGFloat = 2
    private let numpH: CGFloat = 2.5
    private let numpWPad: CGFloat = 2
    private let numpHPad: CGFloat = 2

    
    private var PageWidth: CGFloat {
        get {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                if UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height {
                    return UIScreen.mainScreen().bounds.width/numpWPad
                } else {
                    return UIScreen.mainScreen().bounds.height/numpWPad
              }

            } else {
                if UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height {
                    return UIScreen.mainScreen().bounds.width/numpW
                } else {
                    return UIScreen.mainScreen().bounds.height/numpW
              }
            }
        }
    }
    private var PageHeight: CGFloat {
        get {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                if UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height {
                    return UIScreen.mainScreen().bounds.height/numpHPad
                } else {
                    return UIScreen.mainScreen().bounds.width/numpHPad
                }
            } else {
                if UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height {
                    return UIScreen.mainScreen().bounds.height/numpH
                } else {
                    return UIScreen.mainScreen().bounds.width/numpH
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        itemSize = CGSize(width: PageWidth, height: PageHeight)
        minimumInteritemSpacing = 10
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: collectionView!.bounds.width / 2 - PageWidth / 2, bottom: 0, right: collectionView!.bounds.width / 2 - PageWidth / 2)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let original = super.layoutAttributesForElementsInRect(rect)
        let array = NSArray.init(array: original!, copyItems: true)  as! [UICollectionViewLayoutAttributes]
        for attributes in array {
            let frame = attributes.frame
            let distance = abs((collectionView?.contentOffset.x)! + (collectionView?.contentInset.left)! - frame.origin.x)
            let scale = 0.9 * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
        }
        return array
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Snap cells to centre
        
        var newOffset = CGPoint()
        let layOut = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let width = UIScreen.mainScreen().bounds.width/numpW + layOut.minimumLineSpacing
        var offset = proposedContentOffset.x + (collectionView?.contentInset.left)!

        if velocity.x > 0 {
            //ceil returns next biggest number
            offset = width * ceil(offset/width)
        } else if velocity.x == 0 {
            //rounds the argument
            offset = width * round(offset / width)
        } else if velocity.x < 0 {
            //removes decimal part of argument
            offset = width * floor(offset/width)
        }
        newOffset.x = offset - (collectionView?.contentInset.left)!
        newOffset.y = proposedContentOffset.y

        return newOffset
    }
}
