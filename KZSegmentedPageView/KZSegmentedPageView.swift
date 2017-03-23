//
//  KZSegmentedPageView.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 04/12/2016.
//
//

import UIKit

public class KZSegmentedPageView: UIView {
    public weak var delegate:KZSegmentedPageViewDelegate?
    
    private var view:UIView!
    private var pageViewControllerView: UIView!
    public var segmentedControl: UISegmentedControl!
    public var pageViewController:UIPageViewController!
    
    var segmentedHeighConstraint: NSLayoutConstraint!
    var segmentedTopPaddingConstraint: NSLayoutConstraint!
    var segmentedLeftPaddingConstraint: NSLayoutConstraint!
    var segmentedRightPaddingConstraint: NSLayoutConstraint!
    var segmentedBottomPaddingToPageViewControllerConstraint: NSLayoutConstraint!
    
    public func configure(owner:UIViewController, segments:[KZSegment]) {
        owner.addChildViewController(pageViewController)
        self.segments = segments
    }
    
    @IBInspectable public var scHeight:CGFloat = 29 {
        didSet {
            segmentedHeighConstraint.constant = scHeight
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var scPaddingLeft:CGFloat = 8 {
        didSet {
            segmentedLeftPaddingConstraint.constant = scPaddingLeft
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var scPaddingRight:CGFloat = 8 {
        didSet {
            segmentedRightPaddingConstraint.constant = scPaddingRight
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var scPaddingTop:CGFloat = 8 {
        didSet {
            segmentedTopPaddingConstraint.constant = scPaddingTop
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var scPaddingBottom:CGFloat = 8 {
        didSet {
            segmentedBottomPaddingToPageViewControllerConstraint.constant = scPaddingBottom
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var scTintColor:UIColor = UIColor(colorLiteralRed: 0, green: 122/255, blue: 1, alpha: 1) {
        didSet {
            segmentedControl.tintColor = scTintColor
        }
    }
    
    @IBInspectable public var scBackgroundColor:UIColor = UIColor.clearColor() {
        didSet {
            segmentedControl.backgroundColor = scBackgroundColor
            segmentedControl.clipsToBounds = true
            segmentedControl.layer.cornerRadius = 4
        }
    }
    
    @IBInspectable public var viewBackgroundColor:UIColor = UIColor.whiteColor() {
        didSet {
            view.backgroundColor = viewBackgroundColor
        }
    }
    
    
    @IBAction func segmentedControlClicked(sender: UISegmentedControl) {
        delegate?.segmentedPageView(self, didSelectSegmentAtIndex: sender.selectedSegmentIndex)
        scrollToViewController(index: sender.selectedSegmentIndex)
    }
    
    private var transitionInProgress:Bool = false
    public var isTransitioning:Bool {
        return transitionInProgress
    }
    
    public var segments:[KZSegment] = [] {
        didSet {
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            if let initialViewController = segments.first?.viewController {
                scrollToViewController(initialViewController, direction: .Forward)
            }
            delegate?.segmentedPageView(self, didUpdatePageCount: segments.count)
            
            segmentedControl.removeAllSegments()
            for i in 0..<segments.count {
                segmentedControl.insertSegmentWithTitle(segments[i].title, atIndex: i, animated: false)
            }
            
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.view.frame = pageViewControllerView.bounds
        pageViewControllerView.addSubview(pageViewController.view)
        
//        pageViewController.view.bindFrameToSuperviewBounds()
        
        pageViewControllerView.layoutIfNeeded()
    }
    
    func loadViewFromNib() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
//        view.frame = bounds
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        pageViewControllerView = UIView(frame: CGRect(x: 0, y: 44, width: 375, height: 623))
        pageViewControllerView.backgroundColor = UIColor.clearColor()
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl = UISegmentedControl(frame: CGRect(x: 8, y: 8, width: 359, height: 29))
        segmentedControl.insertSegmentWithTitle("Segment 1", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("Segment 2", atIndex: 1, animated: false)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        view.addSubview(pageViewControllerView)
        view.addSubview(segmentedControl)
        
        let pvLeftConstraint = NSLayoutConstraint(
            item: pageViewControllerView,
            attribute: .Leading, 
            relatedBy: .Equal, 
            toItem: view,
            attribute: .Leading, 
            multiplier: 1, 
            constant: 0)
        
        let pvRightConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .Trailing, 
            relatedBy: .Equal, 
            toItem: view,
            attribute: .Trailing, 
            multiplier: 1, 
            constant: 0)
        
        let pvBottomConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .Bottom, 
            relatedBy: .Equal, 
            toItem: view, 
            attribute: .Bottom, 
            multiplier: 1, 
            constant: 0)
        view.addConstraints([pvLeftConstraint, pvRightConstraint, pvBottomConstraint])
        
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlClicked(_:)), forControlEvents: .ValueChanged)
        
        segmentedTopPaddingConstraint = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view, 
            attribute: .Top,
            multiplier: 1,
            constant: 8)
        
        segmentedRightPaddingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: segmentedControl,
            attribute: .Trailing,
            multiplier: 1,
            constant: 8)
        
        segmentedLeftPaddingConstraint =  NSLayoutConstraint(
            item: segmentedControl, 
            attribute: .Leading, 
            relatedBy: .Equal, 
            toItem: view, 
            attribute: .Leading, 
            multiplier: 1, 
            constant: 8)
        
        segmentedBottomPaddingToPageViewControllerConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .Top, 
            relatedBy: .Equal, 
            toItem: segmentedControl,
            attribute: .Bottom, 
            multiplier: 1,
            constant: 8)
        
        segmentedHeighConstraint = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .Height, 
            relatedBy: .Equal, 
            toItem: nil, 
            attribute: .NotAnAttribute, 
            multiplier: 1, 
            constant: 29)
        view.addConstraints([
            segmentedTopPaddingConstraint,
            segmentedRightPaddingConstraint,
            segmentedLeftPaddingConstraint,
            segmentedBottomPaddingToPageViewControllerConstraint
            ])
        
        segmentedControl.addConstraint(segmentedHeighConstraint)
        
        view.bindFrameToSuperviewBounds()
        view.layoutIfNeeded()
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

extension KZSegmentedPageView {
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    public func scrollToViewController(index newIndex: Int) {
        if let firstViewController = pageViewController.viewControllers?.first,
            let currentIndex = segments.indexOf({ $0.viewController == firstViewController }) {
            let direction: UIPageViewControllerNavigationDirection = newIndex > currentIndex ? .Forward : .Reverse
            let nextViewController = segments[newIndex].viewController
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController, direction: UIPageViewControllerNavigationDirection) {
        if !transitionInProgress {
            pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: { (finished) -> Void in
                self.notifytimelineDelegateOfNewIndex()
                self.transitionInProgress = false
            })
        }
    }
    
    /**
     Notifies '_timelineDelegate' that the current page index was updated.
     */
    private func notifytimelineDelegateOfNewIndex() {
        if let firstViewController = pageViewController.viewControllers?.first,
            let index = segments.indexOf({ $0.viewController == firstViewController }) {
            delegate?.segmentedPageView(self, didUpdateSegmentIndex: index)
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
    /**
     Scrolls to the next view controller.
     */
    public func scrollViewController(direction:UIPageViewControllerNavigationDirection) {
        if let visibleViewController = pageViewController.viewControllers?.first,
            let nextViewController = pageViewController(pageViewController, viewControllerAfterViewController: visibleViewController) {
            scrollToViewController(nextViewController, direction: direction)
        }
    }
}

extension KZSegmentedPageView: UIPageViewControllerDelegate {
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let firstViewController = pendingViewControllers.first,
            let index = segments.indexOf({ $0.viewController == firstViewController }) {
            delegate?.segmentedPageView(self, willUpdatePageIndex: index)
        }
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifytimelineDelegateOfNewIndex()
    }
}

extension KZSegmentedPageView: UIPageViewControllerDataSource {
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = segments.indexOf({ $0.viewController == viewController }) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard segments.count != previousIndex else {
            return nil
        }
        
        guard segments.count > previousIndex else {
            return nil
        }
        
        segmentedControl.selectedSegmentIndex = previousIndex
        return segments[previousIndex].viewController
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = segments.indexOf({ $0.viewController == viewController }) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        
        guard segments.count != nextIndex else {
            return nil
        }
        
        guard segments.count > nextIndex else {
            return nil
        }
        
        segmentedControl.selectedSegmentIndex = nextIndex
        return segments[nextIndex].viewController
    }
}



