//
//  KZSegmentedPageView.swift
//  Practice
//
//  Created by Zonily Jame Pesquera on 04/12/2016.
//
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

open class KZSegmentedPageView: UIView {
    open weak var delegate: KZSegmentedPageViewDelegate?
    
    fileprivate var view: UIView!
    fileprivate var pageViewControllerView: UIView!
    open var segmentedControl: UISegmentedControl!
    open var pageViewController:UIPageViewController!
    
    var segmentedHeighConstraint: NSLayoutConstraint!
    var segmentedTopPaddingConstraint: NSLayoutConstraint!
    var segmentedLeftPaddingConstraint: NSLayoutConstraint!
    var segmentedRightPaddingConstraint: NSLayoutConstraint!
    var segmentedBottomPaddingToPageViewControllerConstraint: NSLayoutConstraint!
    
    open func configure(_ owner: UIViewController, segments: [KZSegmentedPageView.Segment]) {
        owner.addChildViewController(pageViewController)
        self.segments = segments
    }
    
    @IBInspectable open var scHeight: CGFloat = 29 {
        didSet {
            segmentedHeighConstraint.constant = scHeight
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable open var scPaddingLeft: CGFloat = 8 {
        didSet {
            segmentedLeftPaddingConstraint.constant = scPaddingLeft
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable open var scPaddingRight: CGFloat = 8 {
        didSet {
            segmentedRightPaddingConstraint.constant = scPaddingRight
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable open var scPaddingTop: CGFloat = 8 {
        didSet {
            segmentedTopPaddingConstraint.constant = scPaddingTop
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable open var scPaddingBottom: CGFloat = 8 {
        didSet {
            segmentedBottomPaddingToPageViewControllerConstraint.constant = scPaddingBottom
            view.layoutIfNeeded()
        }
    }
    
    @IBInspectable open var scTintColor: UIColor = UIColor(colorLiteralRed: 0, green: 122/255, blue: 1, alpha: 1) {
        didSet {
            segmentedControl.tintColor = scTintColor
        }
    }
    
    @IBInspectable open var scBackgroundColor: UIColor = UIColor.clear {
        didSet {
            segmentedControl.backgroundColor = scBackgroundColor
            segmentedControl.clipsToBounds = true
            segmentedControl.layer.cornerRadius = 4
        }
    }
    
    @IBInspectable open var viewBackgroundColor: UIColor = UIColor.white {
        didSet {
            view.backgroundColor = viewBackgroundColor
        }
    }
    
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        delegate?.segmentedPageView(self, didSelectSegmentAtIndex: sender.selectedSegmentIndex)
        scrollToViewController(index: sender.selectedSegmentIndex)
    }
    
    fileprivate var transitionInProgress:Bool = false
    open var isTransitioning:Bool {
        return transitionInProgress
    }
    
    open var segments: [KZSegmentedPageView.Segment] = [] {
        didSet {
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            if let initialViewController = segments.first?.viewController {
                scrollToViewController(initialViewController, direction: .forward)
            }
            delegate?.segmentedPageView(self, didUpdatePageCount: segments.count)
            
            segmentedControl.removeAllSegments()
            for i in 0..<segments.count {
                segmentedControl.insertSegment(withTitle: segments[i].title, at: i, animated: false)
            }
            
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = pageViewControllerView.bounds
        pageViewControllerView.addSubview(pageViewController.view)
        
//        pageViewController.view.bindFrameToSuperviewBounds()
        
        pageViewControllerView.layoutIfNeeded()
    }
    
    func loadViewFromNib() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
//        view.frame = bounds
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        pageViewControllerView = UIView(frame: CGRect(x: 0, y: 44, width: 375, height: 623))
        pageViewControllerView.backgroundColor = UIColor.clear
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl = UISegmentedControl(frame: CGRect(x: 8, y: 8, width: 359, height: 29))
        segmentedControl.insertSegment(withTitle: "Segment 1", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Segment 2", at: 1, animated: false)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        view.addSubview(pageViewControllerView)
        view.addSubview(segmentedControl)
        
        let pvLeftConstraint = NSLayoutConstraint(
            item: pageViewControllerView,
            attribute: .leading, 
            relatedBy: .equal, 
            toItem: view,
            attribute: .leading, 
            multiplier: 1, 
            constant: 0)
        
        let pvRightConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .trailing, 
            relatedBy: .equal, 
            toItem: view,
            attribute: .trailing, 
            multiplier: 1, 
            constant: 0)
        
        let pvBottomConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .bottom, 
            relatedBy: .equal, 
            toItem: view, 
            attribute: .bottom, 
            multiplier: 1, 
            constant: 0)
        view.addConstraints([pvLeftConstraint, pvRightConstraint, pvBottomConstraint])
        
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlClicked(_:)), for: .valueChanged)
        
        segmentedTopPaddingConstraint = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .top,
            relatedBy: .equal,
            toItem: view, 
            attribute: .top,
            multiplier: 1,
            constant: 8)
        
        segmentedRightPaddingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: segmentedControl,
            attribute: .trailing,
            multiplier: 1,
            constant: 8)
        
        segmentedLeftPaddingConstraint =  NSLayoutConstraint(
            item: segmentedControl, 
            attribute: .leading, 
            relatedBy: .equal, 
            toItem: view, 
            attribute: .leading, 
            multiplier: 1, 
            constant: 8)
        
        segmentedBottomPaddingToPageViewControllerConstraint = NSLayoutConstraint(
            item: pageViewControllerView, 
            attribute: .top, 
            relatedBy: .equal, 
            toItem: segmentedControl,
            attribute: .bottom, 
            multiplier: 1,
            constant: 8)
        
        segmentedHeighConstraint = NSLayoutConstraint(
            item: segmentedControl,
            attribute: .height, 
            relatedBy: .equal, 
            toItem: nil, 
            attribute: .notAnAttribute, 
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
            let currentIndex = segments.index(where: { $0.viewController == firstViewController }) {
            let direction: UIPageViewControllerNavigationDirection = newIndex > currentIndex ? .forward : .reverse
            let nextViewController = segments[newIndex].viewController
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController, direction: UIPageViewControllerNavigationDirection) {
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
    fileprivate func notifytimelineDelegateOfNewIndex() {
        if let firstViewController = pageViewController.viewControllers?.first,
            let index = segments.index(where: { $0.viewController == firstViewController }) {
            delegate?.segmentedPageView(self, didUpdateSegmentIndex: index)
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
    /**
     Scrolls to the next view controller.
     */
    public func scrollViewController(_ direction:UIPageViewControllerNavigationDirection) {
        if let visibleViewController = pageViewController.viewControllers?.first,
            let nextViewController = pageViewController(pageViewController, viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController, direction: direction)
        }
    }
}

extension KZSegmentedPageView: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstViewController = pendingViewControllers.first,
            let index = segments.index(where: { $0.viewController == firstViewController }) {
            delegate?.segmentedPageView(self, willUpdatePageIndex: index)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifytimelineDelegateOfNewIndex()
    }
}

extension KZSegmentedPageView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = segments.index(where: { $0.viewController == viewController }) else {
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
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = segments.index(where: { $0.viewController == viewController }) else {
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

// MARK: - Models
extension KZSegmentedPageView {
    public struct Segment {
        public let title:String
        public let viewController:UIViewController
        
        public init(title:String, viewController:UIViewController) {
            self.title = title
            self.viewController = viewController
        }
    }
    
}
