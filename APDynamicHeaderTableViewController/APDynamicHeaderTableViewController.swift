//
//  APDynamicHeaderTableViewController.swift
//
//  Created by Aaron Pang on 2015-04-27.
//  Copyright (c) 2015 Aaron Pang. All rights reserved.
//

import Foundation
import UIKit

class APDynamicHeaderTableViewController : UIViewController {
  let headerView = APDynamicHeaderView ()
  let tableView = UITableView (frame: CGRectZero, style: .Plain)
  
  private var headerViewHeightConstraint = NSLayoutConstraint()
  private var headerBeganCollapsed = false
  private var collapsedHeaderViewHeight : CGFloat = UIApplication.sharedApplication().statusBarFrame.height
  private var expandedHeaderViewHeight : CGFloat = 75
  private var headerExpandDelay : CGFloat = 100
  private var tableViewScrollOffsetBeginDraggingY : CGFloat = 0.0
  
  /**
  Designated Initializer. Initializes table view controller and header view.
  
  :param: collapsedHeaderViewHeight Height of header view when collapsed.
  :param: expandedHeaderViewHeight Height of header view when expanded.
  :param: headerExpandDelay Delay for header view to begin expanding when user is scrolling up.
  
  */
  init(collapsedHeaderViewHeight : CGFloat, expandedHeaderViewHeight : CGFloat, headerExpandDelay :CGFloat) {
    self.collapsedHeaderViewHeight = collapsedHeaderViewHeight
    self.expandedHeaderViewHeight = expandedHeaderViewHeight
    self.headerExpandDelay = headerExpandDelay
    super.init(nibName: nil, bundle: nil)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  /**
  Initializes table view controller and header view with default values.
  */
  init () {
    super.init(nibName: nil, bundle: nil)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
        
    headerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    view.addSubview(headerView)
    view.addSubview(tableView)
    tableView.backgroundColor = UIColor.whiteColor()
    
    let views = ["headerView" : headerView, "tableView" : tableView]
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[headerView][tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))

    headerViewHeightConstraint = NSLayoutConstraint(item: headerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: expandedHeaderViewHeight)
    view.addConstraint(headerViewHeightConstraint)
  }
  
  func animateHeaderViewHeight () -> Void {
    // Animate the header view to collapsed or expanded if it is dragged only partially
    var headerViewHeightDestinationConstant : CGFloat = 0.0
    if (headerViewHeightConstraint.constant < ((expandedHeaderViewHeight - collapsedHeaderViewHeight) / 2.0 + collapsedHeaderViewHeight)) {
      headerViewHeightDestinationConstant = collapsedHeaderViewHeight
    } else {
      headerViewHeightDestinationConstant = expandedHeaderViewHeight
    }
    if (headerViewHeightConstraint.constant != expandedHeaderViewHeight && headerViewHeightConstraint.constant != collapsedHeaderViewHeight) {
      let animationDuration = 0.25
      UIView.animateWithDuration(animationDuration, animations: { () -> Void in
        self.headerViewHeightConstraint.constant = headerViewHeightDestinationConstant
        let progress = (self.headerViewHeightConstraint.constant - self.collapsedHeaderViewHeight) / (self.expandedHeaderViewHeight - self.collapsedHeaderViewHeight)
        self.headerView.expandToProgress(progress)
        self.view.layoutIfNeeded()
      })
    }
  }
}

extension APDynamicHeaderTableViewController : UITableViewDelegate {
  
}

extension APDynamicHeaderTableViewController : UIScrollViewDelegate {
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    // Clamp the beginning point to 0 and the max content offset to prevent unintentional resizing when dragging during rubber banding
    tableViewScrollOffsetBeginDraggingY = min(max(scrollView.contentOffset.y, 0), scrollView.contentSize.height - scrollView.frame.size.height)
    
    // Keep track of whether or not the header was collapsed to determine if we can add the delay of expansion
    headerBeganCollapsed = (headerViewHeightConstraint.constant == collapsedHeaderViewHeight)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    // Do nothing if the table view is not scrollable
    if tableView.contentSize.height < CGRectGetHeight(tableView.bounds) {
      return
    }
    var contentOffsetY = tableView.contentOffset.y - tableViewScrollOffsetBeginDraggingY
    // Add a delay to expanding the header only if the user began scrolling below the allotted amount of space to actually expand the header with no delay (e.g. If it takes 30 pixels to scroll up the scrollview to expand the header then don't add the delay of the user started scrolling at 10 pixels)

    if tableViewScrollOffsetBeginDraggingY > ((expandedHeaderViewHeight - collapsedHeaderViewHeight) + headerExpandDelay) && contentOffsetY < 0 && headerBeganCollapsed {
      contentOffsetY = contentOffsetY + headerExpandDelay
    }
    // Calculate how much the header height will change so we can readjust the table view's content offset so it doesn't scroll while we change the height of the header
    let changeInHeaderViewHeight = headerViewHeightConstraint.constant - min(max(headerViewHeightConstraint.constant - contentOffsetY, collapsedHeaderViewHeight), expandedHeaderViewHeight)
    headerViewHeightConstraint.constant = min(max(headerViewHeightConstraint.constant - contentOffsetY, collapsedHeaderViewHeight), expandedHeaderViewHeight)
    let progress = (headerViewHeightConstraint.constant - collapsedHeaderViewHeight) / (expandedHeaderViewHeight - collapsedHeaderViewHeight)
    headerView.expandToProgress(progress)

    // When the header view height is changing, freeze the content in the table view
    if headerViewHeightConstraint.constant != collapsedHeaderViewHeight && headerViewHeightConstraint.constant != expandedHeaderViewHeight {
        tableView.contentOffset = CGPointMake(0, tableView.contentOffset.y - changeInHeaderViewHeight)
    }
  }
  
  // Animate the header view when the user ends dragging or flicks the scroll view 
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    animateHeaderViewHeight()
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    animateHeaderViewHeight()
  }
}

extension APDynamicHeaderTableViewController : UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var tableViewCell : UITableViewCell
    if let dequeuedTableViewCell = tableView.dequeueReusableCellWithIdentifier("Identifier") as? UITableViewCell {
      tableViewCell = dequeuedTableViewCell
    } else {
      tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Identifier")
      tableViewCell.selectionStyle = .None
    }
    tableViewCell.textLabel?.text = String(indexPath.row)
    return tableViewCell
  }
}
