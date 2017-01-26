//
//  NotificationTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    
    var tableStructure = [("Michael Liu","Photoshop",NotificationType.finish),
                          ("Michael Liu","Photoshop",NotificationType.affirm),
                          ("Michael Liu","Photoshop",NotificationType.info),
                          ("Michael Liu","Photoshop",NotificationType.request)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotiCell")
        self.tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableStructure.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView(input: "Message")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotificationTableViewCell
        let (whom, service, type) = tableStructure[indexPath.row]
        cell.fillType(whom: whom, service: service, type: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (whom, service, type) = tableStructure[indexPath.row]
        let cell = NotificationTableViewCell()
        return cell.getCellHeight(whom: whom, service: service, type: type)
    }

}
