//
//  NotificationTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Presentr


class NotificationTableViewController: UITableViewController,NotificationButtonDelegate{
    
    var tableStructure = [("Michael Liu","Photoshop",NotificationType.finish),
                          ("Michael Liu","Photoshop",NotificationType.affirm),
                          ("Michael Liu","Photoshop",NotificationType.info),
                          ("Michael Liu","Photoshop",NotificationType.request)]
   
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()

    
    var alertController = Presentr.alertViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotiCell")
        self.tableView.separatorStyle = .none
        setupAlertController()
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = fetchViewControllerFromMain(withIdentifier: "Chat")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotificationTableViewCell
        if cell.notificationDelegate == nil {
            cell.notificationDelegate = self
        }
        let (whom, service, type) = tableStructure[indexPath.row]
        cell.fillType(whom: whom, service: service, type: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (whom, service, type) = tableStructure[indexPath.row]
        let cell = NotificationTableViewCell()
        return cell.getCellHeight(whom: whom, service: service, type: type)
    }

    func upperOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let (whom, service, type) = tableStructure[(indexPath?.row)!]
        
    }
    
    func lowerOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let (whom, service, type) = tableStructure[(indexPath?.row)!]
        
    }
}

extension NotificationTableViewController{
    func setupAlertController(){
        alertController.titleText = "Are you sure? ⚠️"
        alertController.bodyText = "This action can't be undone!"
        alertController.addAction(AlertAction(title: "NO, SORRY! 😱", style: .cancel) { alert in
            print("CANCEL!!")
        })
        alertController.addAction(AlertAction(title: "DO IT! 🤘", style: .destructive) { alert in
            print("OK!!")
        })
    }
    
    func alertStyle(){
        let customPresenter: Presentr = {
            let width = ModalSize.full
            //let height = ModalSize.custom(size: 150)
            let height = ModalSize.fluid(percentage: 0.20)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .coverVerticalFromTop
            customPresenter.roundCorners = false
            customPresenter.backgroundColor = UIColor.flatBlack()
            customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        customPresentViewController(customPresenter, viewController: alertController, animated: true, completion: nil)
    }
}


