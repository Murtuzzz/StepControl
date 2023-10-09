//
//  CustomLayout.swift
//  StepControl
//
//  Created by Мурат Кудухов on 29.09.2023.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    
    var previousOffset: CGFloat = 0
    var currentPage = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

        }
        
        let itemCount = 7
        var index = 7//cv.numberOfItems(inSection: 0)
        
//        if previousOffset < cv.contentOffset.x && velocity.x < 0.0 {
//            print("previous offset < \(cv.contentOffset.x)")
//            //<-
//            currentPage = max(currentPage-1, 0)
//            //currentPage = min(currentPage+1, itemCount-1)
//
//        } else if previousOffset > cv.contentOffset.x && velocity.x > 0.0 {
//            print("previous offset > \(cv.contentOffset.x)")
//            //->
//            //currentPage = max(currentPage-1, 0)
//            currentPage = min(currentPage+1, itemCount-1)
//        } else {
//            print("equal")
//        }
        
        if velocity.x > 0.0 {
            currentPage = max(currentPage-1, -1)
            index += 1
            //->
        } else if velocity.x < 0.0 {
            index -= 1
            currentPage = min(currentPage+1, itemCount)
            //<-
        }
        
        print("cv.contentOffset.x = \(cv.contentOffset.x)")
        print("previousOffset = \(previousOffset)")
        print(currentPage)
        let w = cv.frame.width
        print("w = \(w)")
        let itemW = itemSize.width
        print("itemW = \(itemW)")
        let sp = minimumLineSpacing + minimumLineSpacing/5 - 0.5
        print("sp = \(sp)")

        let edge = (w - itemW - sp*2) / 2
        print("edge = \(edge)")
        
        var item = min(282 * CGFloat(currentPage), 1980)
        print("currentPage = \(currentPage)")
        //let item = (itemW + sp) + sp
        print("item = \(Int(item))")
        
        var offset = (1980 - item)
        
        if offset < 0 {
            offset = 0
            item = 0
            //currentPage = 0
        }
        //let offset = CGFloat(Int(item) * index)
        
        print("previousOffset = \(previousOffset)")
        print("offset = \(offset)")
        
        previousOffset = offset
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
}


//import UIKit
//
//class CustomLayout: UICollectionViewFlowLayout {
//    
//    var previousOffset: CGFloat = 1980
//    var currentPage = 0
//    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let cv = collectionView else {
//            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//
//        }
//        
//        let itemCount = 7//cv.numberOfItems(inSection: 0)
//        
////        if previousOffset < cv.contentOffset.x && velocity.x < 0.0 {
////            print("previous offset < \(cv.contentOffset.x)")
////            //<-
////            currentPage = max(currentPage-1, 0)
////            //currentPage = min(currentPage+1, itemCount-1)
////            
////        } else if previousOffset > cv.contentOffset.x && velocity.x > 0.0 {
////            print("previous offset > \(cv.contentOffset.x)")
////            //->
////            //currentPage = max(currentPage-1, 0)
////            currentPage = min(currentPage+1, itemCount-1)
////        } else {
////            print("equal")
////        }
//        
//        if velocity.x > 0.0 {
//            currentPage = max(currentPage-1, 0)
//        } else if velocity.x < 0.0 {
//            currentPage = min(currentPage+1, itemCount-1)
//        }
//        
//        print(currentPage)
//        let w = cv.frame.width
//        print("w = \(w)")
//        let itemW = itemSize.width
//        print("itemW = \(itemW)")
//        let sp = minimumLineSpacing + minimumLineSpacing/5 - 0.5
//        print("sp = \(sp)")
//
//        let edge = (w - itemW - sp*2) / 2
//        print("edge = \(edge)")
//        
//        let offset = previousOffset - ((itemW + sp) * CGFloat(currentPage) + sp * CGFloat(currentPage))
//        
//        print("previousOffset = \(previousOffset)")
//        print("offset = \(offset)")
//        
////        previousOffset = offset
//        return CGPoint(x: offset, y: proposedContentOffset.y)
//    }
//}


//import UIKit
//
//class CustomLayout: UICollectionViewFlowLayout {
//    
//    var previousOffset: CGFloat = 0
//    var currentPage = 0
//    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let cv = collectionView else {
//            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//        }
//        
//        let itemCount = cv.numberOfItems(inSection: 0)
//        
//        if previousOffset > cv.contentOffset.x && velocity.x < 0.0 {
//            //<-
//            currentPage = max(currentPage-1, 0)
//            //currentPage = min(currentPage+1, itemCount-1)
//            
//        } else if previousOffset < cv.contentOffset.x && velocity.x > 0.0 {
//            //->
//            //currentPage = max(currentPage-1, 0)
//            currentPage = min(currentPage+1, itemCount-1)
//        }
//        
//        let w = cv.frame.width
//        let itemW = itemSize.width
//        let sp = minimumLineSpacing + minimumLineSpacing/5 - 0.5
//
//        let edge = (w - itemW - sp*2) / 2
//
//        ///let offset = (itemW + sp) * CGFloat(currentPage) - (edge + sp)
////        let offset = (itemW + sp) * CGFloat(currentPage) + sp * CGFloat(currentPage)
//        
//        let offset = (itemW + sp) * CGFloat(currentPage) + sp * CGFloat(currentPage)
//        print("offset = \(offset)")
//        
//        previousOffset = -offset
//        return CGPoint(x: offset, y: proposedContentOffset.y)
//    }
//}
