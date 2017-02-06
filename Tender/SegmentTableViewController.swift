//
//  SegmentTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

protocol SegmentTableDelegate {
    func displayViewController(vc: UIViewController)
}

class SegmentTableViewController: UITableViewController {

    var segmentDelegate:SegmentTableDelegate?
    var services:[Service] = []
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if uid == nil {
            uid = UserDefaults.standard.value(forKey: "uid") as! String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uid = UserDefaults.standard.value(forKey: "uid") as! String
        ServiceManager().getMyServices(uid: uid!, callback: { data in
            self.services = data
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let service = services[indexPath.row]
        cell.fillCell(title: service.title!, provider: service.provider!, labelDate: service.date!, credit: service.credits!)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Service") as! ServiceViewController
        vc.service = services[indexPath.row]
        self.segmentDelegate?.displayViewController(vc: vc)
    }

}
