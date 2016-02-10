# APDynamicHeaderTableViewController

A simple table view controller with a header view made as a recreation of the Instagram header written in Swift. It's a very simple control that I whipped up in a few days and the header is simply a UIView so you can tweak it, add images, or even make it a tableview. I loved the way the Instagram header was so simple and how it collapsed and expanded when you scrolled so I made a simple clone of it. 

<p align="center">
<img src="https://raw.github.com/aaronpang/APDynamicHeaderTableViewController/master/Gifs/one.gif"/>
<img src="https://raw.github.com/aaronpang/APDynamicHeaderTableViewController/master/Gifs/two.gif"/>
</p>

## How to Install ##

Support for CocoaPods! Simply add the following to your Podfile:

<code>pod 'APDynamicHeaderTableViewController', '~>0.1.1'</code>

Drag and drop the APDynamicHeaderTableViewController.swift and APDynamicHeaderView.swift into your project. Subclass the APDynamicHeaderTableViewController class and set the tableview's data source and delegate to the new subclass.

## Usage ##

To use the APDynamicHeaderTableViewController simply subclass it and call one of the two initializers. Then, override the tableview's data source to input your own data and cells.

```swift
 override init() {
    super.init(
    collapsedHeaderViewHeight: UIApplication.sharedApplication().statusBarFrame.height,
    expandedHeaderViewHeight: 75,
    headerExpandDelay: 100)
    
    tableView.dataSource = self
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
```

There are 2 initializers. The first one is the default init() function that sets all the default values. The second one lets you pass in 3 parameters, the collapsed header height, the expanded header height, and the delay for the header to be expanded when the user is scrolling up.

```swift
  init ()
  
  init(collapsedHeaderViewHeight : CGFloat, expandedHeaderViewHeight : CGFloat, headerExpandDelay :CGFloat)
```

## Properties

***APDynamicTableViewController***

```swift
let headerView
```

The header view at the top of the table view. Set the content view of this header view to be anything you like. The default is simply a text label in the middle.

```swift
let tableView
```

The table view. Simply set the data source and delegate for the table view and adjust the info in the table view when need be.

***APDynamicHeaderView***

```swift
var contentView
```

The content of the header view. Set this content view to be any UIView you like. Default is a text label in the middle.

## Contact

* [@aaronpango](https://twitter.com/AaronPango) on Twitter
* <a href="mailTo:pang.aaron56@gmail.com">pang.aaron56 [at] gmail [dot] com</a>

## License

MIT License
