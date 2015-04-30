//
//  APDynamicHeaderView.swift
//
//  Created by Aaron Pang on 2015-04-26.
//  Copyright (c) 2015 Aaron Pang. All rights reserved.
//

import Foundation
import UIKit

class APDynamicHeaderView : UIView {
  
  var contentView = UIView()
  private let textLabel = UILabel()
  
  // MARK: Lifecycle
  
  /**
  Desiginated Initializer. Defaults the size of the header view to the expanded size.
  */
  init() {
    super.init(frame: CGRectZero)
    self.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1)
    
    addSubview(contentView)

    contentView.backgroundColor = .clearColor()
    contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    textLabel.text = "Title"
    textLabel.textAlignment = .Center
    textLabel.font = UIFont(name: "Helvetica Neue", size: 25)
    contentView.addSubview(textLabel)
    
    let views = ["contentView" : contentView, "textLabel" : textLabel]
    let metrics = ["statusBarHeight" : UIApplication.sharedApplication().statusBarFrame.height]
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textLabel]|", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(statusBarHeight)-[textLabel]|", options: NSLayoutFormatOptions(0), metrics: metrics, views: views))
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func expandToProgress(progress : CGFloat) {
    contentView.alpha = progress
    contentView.transform = CGAffineTransformMakeScale(progress, progress)
  }
  
}