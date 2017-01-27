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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotiCell")
        self.tableView.separatorStyle = .none
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func transferPop(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Transfer")
        self.present(vc, animated: true, completion: nil)
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
        alertStyle()
    }
    
    func lowerOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let (whom, service, type) = tableStructure[(indexPath?.row)!]
        alertStyle()
    }
}

extension NotificationTableViewController{
    
    func customAlertController() -> UIAlertController{
        let alert = UIAlertController.init(title: "Lorem ipsum", message: "Lorem ipsum dolor sit amet, no vix nemore fierent.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    func alertStyle(){
        let customPresenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.50)
            //let height = ModalSize.custom(size: 150)
            let height = ModalSize.fluid(percentage: 0.20)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = false
            //customPresenter.backgroundColor = UIColor.flatWhite()
            //customPresenter.backgroundOpacity = 0.5
            return customPresenter
        }()
        let alert = customAlertController()
        customPresentViewController(customPresenter, viewController: alert, animated: true, completion: nil)
    }
}


