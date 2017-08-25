//
//  KZSegmentedPageViewDelegate.swift
//  KZSegmentedPageView
//
//  Created by Zonily Jame Pesquera on 04/12/2016.
//  Copyright © 2016 kz. All rights reserved.
//

import UIKit

public protocol KZSegmentedPageViewDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter segmentedPageViewController: the segmentedPageViewController instance
     - parameter count: the total number of pages.
     */
    func segmentedPageView(_ segmentedPageView: KZSegmentedPageView, didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter segmentedPageViewController: the segmentedPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func segmentedPageView(_ segmentedPageView: KZSegmentedPageView, didUpdateSegmentIndex index: Int)
    
    /**
     Called when the current index will update.
     
     - parameter segmentedPageViewController: the segmentedPageViewController instance
     - parameter index: the index of the next page to be visible.
     */
    func segmentedPageView(_ segmentedPageView: KZSegmentedPageView, willUpdatePageIndex index: Int)
    
    /**
     Called when a segment is clicked.
     
     - parameter segmentedPageViewController: the segmentedPageViewController instance
     - parameter index: the index of the segmentedControl that is clicked.
     */
    func segmentedPageView(_ segmentedPageView: KZSegmentedPageView, didSelectSegmentAtIndex index: Int)
}

public struct KZSegment {
    public let title:String
    public let viewController:UIViewController
    
    public init(title:String, viewController:UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}

extension UIView {
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
    }
}


