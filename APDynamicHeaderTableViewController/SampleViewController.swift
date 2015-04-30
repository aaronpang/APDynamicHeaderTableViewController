//
//  SampleViewController.swift
//  Eurotrip
//
//  Created by Aaron Pang on 2015-04-27.
//  Copyright (c) 2015 Aaron Pang. All rights reserved.
//

import Foundation
import UIKit

class SampleViewController : APDynamicHeaderTableViewController {
  override init() {
    super.init(
    collapsedHeaderViewHeight: UIApplication.sharedApplication().statusBarFrame.height,
    expandedHeaderViewHeight: 75,
    headerExpandDelay: 100)
    
    tableView.dataSource = self
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SampleViewController : UITableViewDataSource {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
}