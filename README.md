# KZSegmentedView

[![Twitter](https://img.shields.io/badge/Twitter-%40kuyazee-blue.svg)](http://twitter.com/kuyazee)
[![Github](https://img.shields.io/badge/Github-kuyazee-blue.svg)](https://github.com/kuyazee)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-red.svg)](#installation)

KZSegmentedPageView is a UIView Subclass that combines the functionality of UISegmentedControl and UIPageViewController

## Table of Contents
- **[Installation](#installation)**
- **[How to Use](#how-to-use)**
- **[Adding Segments](#adding-segments)**
- **[Delegation](#refresh-ui/data)**
- **[Delegate Functions](#delegate-functions)**
- **[Customization](#customization)**


## Installation

To install KZSegmentedPageView via cocoapods, simply use the add this in your podfile and then run `pod install`

```Cocoapods
pod 'KZSegmentedPageView'
```

## How to Use

After installing through Cocoapods simply import `KZSegmentedPageView` in your ViewController class 

```
import KZSegmentedPageView
```

Then create a variable of type `KZSegmentedPageView` inside your ViewController

```
class ViewController:UIViewController {
    ...
    var segmentedPageView:KZSegmentedPageView!   
    ...
}
```

And finally initialize it inside the `viewDidLoad()` function of your class and add it as a subView to your ViewController's view

```
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedPageView = KZSegmentedPageView()
        segmentedPageView.frame = self.view.bounds
        segmentedPageView.delegate = self
        view.addSubview(segmentedPageView)
    }
    ...
```

Together The code would look like this

```
import UIKit
import KZSegmentedPageView

class ViewController: UIViewController {

    var segmentedPageView:KZSegmentedPageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedPageView = KZSegmentedPageView()
        segmentedPageView.frame = self.view.bounds
        view.addSubview(segmentedPageView)
    }
}
```

## Adding Segments

To add segments we need to make use of the `KZSegment` struct and add them to our `KZSegmentedPageView`. 

KZSegment is a struct containing only 2 variables `title:String` and `viewController:UIViewController`

Initializing a KZSegment would look like this `KZSegment(title: "First VC", viewController: SomeViewController())`

To add segments we need to create an array of KZSegments and place add them to the `KZSegmentedPageView` after initialization like this:

```
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        
        // Let's make our ViewControllers first
        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = UIColor.greenColor()
        
        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = UIColor.orangeColor()
        
        // After making our UIViewController next we'll add them to the `segments` property of our KZSegmentedPageView
        segmentedPageView.segments = [
            KZSegment(title: "First VC", viewController: firstViewController),  
            KZSegment(title: "Second VC", viewController: secondViewController)
        ]
        
        ...
    }
```

## Delegation

To recieve the delegate function's you need to set the `KZSegmentedPageView`'s delegate to self

```
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        segmentedPageView.delegate = self
        ...
    }
```

But this will create an error message because we still haven't implemented our Delegate methods. To have access to the delegate methods we need to SubClass our ViewController to `KZSegmentedPageViewDelegate`

```
class ViewController:UIViewController, KZSegmentedPageViewDelegate {
    ...
}
```

or

```
extension ViewController, KZSegmentedPageViewDelegate {
    ...
}
```

## Delegate Functions

There are Four Delegate functions
- didUpdatePageCount
- didUpdateSegmentIndex
- willUpdatePageIndex
- didSelectSegmentAtIndex


**didUpdatePageCount** will be triggered if we set the segments property of the `segmentedPageView`
```
    func segmentedPageView(segmentedPageView: KZSegmentedPageView, didUpdatePageCount count: Int) {
        print("Page count:", count)
        // do some code here
    }
```

**didUpdateSegmentIndex** will be triggered if you've successfully changed from one segment/page to another
```
    func segmentedPageView(segmentedPageView: KZSegmentedPageView, didUpdateSegmentIndex index: Int) {
        
    }
```

**willUpdatePageIndex** will be triggered if you're currently trying to swipe left/right
```    
    func segmentedPageView(segmentedPageView:KZSegmentedPageView, willUpdatePageIndex index:Int) {
        print("Will Update Page Index To", index, "with title", segmentedPageView.segments[index].title)
    }
```

**didSelectSegmentAtIndex** will be triggered if we tap/click the `UISegmentedControl` of our `KZSegmentedPageView`
```
    func segmentedPageView(segmentedPageView:KZSegmentedPageView, didSelectSegmentAtIndex index:Int) {
        
    }
```

## Customization

We can customize how the `KZSegmentedPageView` would look like using these variables
- scHeight
   This will customize the SegmentedControl's height
- scTintColor
   This will customize the SegmentedControl's tintColor
- scBackgroundColor
   This will customize the SegmentedControl's backgroundColor
- viewBackgroundColor
   This will customize the backgroundView's backgroundColor (view behind SegmentedControl)
- scPaddingTop, scPaddingLeft, scPaddingRight, scPaddingBottom
   This will customize the SegmentedControl's Padding


```
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        segmentedPageView.scHeight = 45
        segmentedPageView.scTintColor = UIColor.GreyColor()
        segmentedPageView.scBackgroundColor = UIColor.BlueColor()
        segmentedPageView.scPaddingTop = 8
        segmentedPageView.scPaddingLeft = 8
        segmentedPageView.scPaddingRight = 8
        segmentedPageView.scPaddingBottom = 8
        segmentedPageView.viewBackgroundColor = UIColor.ClearColor()
        ...
    }
```

**Quick Note** These properties should be `IBInspectable` but I'm still fixing some issue with Cocoapods regarding `IBDesignable`s 
