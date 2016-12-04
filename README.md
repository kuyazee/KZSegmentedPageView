# KZSegmentedView

[![Twitter](https://img.shields.io/badge/Twitter-%40kuyazee-blue.svg)](http://twitter.com/kuyazee)
[![Github](https://img.shields.io/badge/Github-kuyazee-blue.svg)](https://github.com/kuyazee)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-red.svg)](#installation)

KZSegmentedView is a UIView Subclass that combines the functionality of UISegmentedControl and UIPageViewController

## Table of Contents
- **[Installation](#installation)**
- **[How to Use](#how-to-use)**
- **[Delegates](#refresh-ui/data)**
- **[On logout](#on-logout)**
- **[Performing something on Logout](#performing-something-on-logout)**
- **[Performing something if still LoggedIn](#performing-something-if-still-loggedin)**


## Installation

To install KZViewController via cocoapods, simply use the add this in your podfile and then run `pod install`

```Cocoapods
pod 'KZSegmentedView'
```

## How to Use

Simply Subclass your UIViewController with KZViewController instead if using UIViewController.

```swift
class SomeViewController: KZRefreshViewController { 

}
```

On your AppDelegate if you want to see logs of KZViewController's `userDidLogout()`, `userStillLoggedIn()`, `loggedOutNotification`, `viewDidRefresh()` and `viewWillRefresh()` just add this snippet inside `didFinishLaunchingWithOptions`

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // this automatically defaults to false if not set
    KZVCHelper.sharedInstance.showLogs = true 
    
    return true
}
```

KZViewController is a UIViewController subclass

## Refresh UI/Data

Inside your `SomeViewController` class simply override the `refresh()` function like this

```swift

// this function is called on viewWillAppear
override func viewWillRefresh() {
    super.viewWillRefresh()
    // do refresh of variables and user interface here
}

// this function is called by viewWillRefresh
override func viewDidRefresh() {
    super.viewDidRefresh()
    // do something after refresh
}
```

**Quick note** these functions are only called once and you'd need to call KZVCHelper.logOut() again to refresh all `UIViewControllers` sublcassed with `KZRefreshViewController`

## On logout

Simply call this function when logging out so that `viewWillRefresh()` will be called on `viewWillAppear()` of your `SomeViewController` class

```swift

//inside some logout block
KZVCHelper.logOut()

```

## Performing something on Logout

You can do some other stuff if the user has logged out by overriding `userDidLogout()` function

```swift
override func userDidLogout() {
    super.userDidLogout()
    //do something if user has logout
}
```

## Performing something if still LoggedIn

You can do some other stuff if the user is still LoggedIn out by overriding `userStillLoggedIn()` function

```swift
override func userStillLoggedIn() {
    super.userStillLoggedIn()
    //do something if still loggedIn
}
```
