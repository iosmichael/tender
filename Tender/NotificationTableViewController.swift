//
//  NotificationTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase
import Presentr

class NotificationTableViewController: UITableViewController,NotificationButtonDelegate{
    
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    var uid:String?
    let transactionManager = TransactionManager()
    var transactionsList:[Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationHeader()
        if UserDefaults.standard.value(forKey: "uid")==nil {
            UserManager().updateUser()
        }
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotiCell")
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uid = UserDefaults.standard.value(forKey: "uid") as! String
        TransactionManager().getTransactions(uid: uid!, reloadFunc:{ data in
            self.transactionsList = data
            self.tableView.reloadData()
        })
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
        return transactionsList.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView(input: "Message")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = fetchViewControllerFromMain(withIdentifier: "Chat") as! ChatViewController
        let sender = User()
        sender.uid = uid
        sender.name = UserDefaults.standard.value(forKey: "name") as! String?
        let other = User()
        let transaction = transactionsList[indexPath.row]
        other.uid = transactionsList[indexPath.row].user
        if transaction.isProvider {
            other.name = transaction.seeker
        }else{
            other.name = transaction.provider
        }
        vc.setSenderOther(sender: sender, other: other)
        let notiCell = self.tableView(tableView, cellForRowAt: indexPath) as! NotificationTableViewCell
        vc.avatar = notiCell.avatar.image(for: .normal)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotificationTableViewCell
        let transaction = transactionsList[indexPath.row]
        if cell.notificationDelegate == nil {
            cell.notificationDelegate = self
        }
        let (description, type) = parseCellType(transaction: transaction)
        cell.setAvatarImage(uid: transaction.user)
        cell.fillType(description:description, type: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = NotificationTableViewCell()
        let transaction = transactionsList[indexPath.row]
        let (description, type) = parseCellType(transaction: transaction)
        return cell.getCellHeight(description:description, type: type)
    }

    func upperOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let transaction = transactionsList[(indexPath?.row)!]
        let alert = upperOptionAlert(transaction: transaction, uid: self.uid!)
        showAlert(alert: alert)
    }
    
    func lowerOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let transaction = transactionsList[(indexPath?.row)!]
        let alert = lowerOptionAlert(transaction: transaction, uid: self.uid!)
        showAlert(alert: alert)
    }
    
    func singleOptionTapped(cell: NotificationTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let transaction = transactionsList[(indexPath?.row)!]
        if transaction.state == "request" {
            let alert = singleOptionAlert(transaction: transaction, uid: self.uid!)
            showAlert(alert: alert)
        }else{
            transactionManager.cancelAction(transaction: transaction, uid: self.uid!)
        }
    }
    
    func thumbnailTapped(cell: NotificationTableViewCell) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Friend") as! FriendViewController
        let user = User()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NotificationTableViewController{
    
    func upperOptionAlert(transaction:Transaction, uid:String)->UIAlertController{
        let alert = UIAlertController()
        if transaction.isProvider{
            switch transaction.state {
            case "request":
                alert.title = "Request"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Accept", style: .default, handler: { (alert) in
                    self.transactionManager.requestAction(transaction: transaction, isProvider: transaction.isProvider, didAccept: true, uid: uid)
                }))
                break
            case "deliver":
                alert.title = "Deliver"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Accept", style: .default, handler: { (alert) in
                    self.transactionManager.deliverAction(transaction: transaction, isProvider: transaction.isProvider, didComplete: true, uid: uid)
                }))
                break
            default:
                break
            }
        }else{
            if transaction.state == "finish" {
                alert.title = "Finish"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Accept", style: .default, handler: { (alert) in
                    self.transactionManager.finishAction(transaction: transaction, isProvider: transaction.isProvider, didAccept: true, uid: uid)
                }))
            }
        }
        return alert
    }
    
    func lowerOptionAlert(transaction:Transaction, uid:String)->UIAlertController{
        let alert = UIAlertController()
        if transaction.isProvider {
            switch transaction.state {
            case "request":
                alert.title = "Cancel Request"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                    self.transactionManager.cancelAction(transaction: transaction, uid: uid)
                }))
                break
            case "deliver":
                alert.title = "Cancel Deliver"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                    self.transactionManager.deliverAction(transaction: transaction, isProvider: transaction.isProvider, didComplete: false, uid: uid)
                }))
                break
            default:
                break
            }
        }else{
            if transaction.state == "finish" {
                alert.title = "Cancel Finish"
                alert.message = "\(transaction.service)"
                alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                    self.transactionManager.finishAction(transaction: transaction, isProvider: transaction.isProvider, didAccept: false, uid: uid)
                }))
            }
        }
        return alert
    }
    
    func singleOptionAlert(transaction:Transaction, uid:String)->UIAlertController{
        let alert = UIAlertController()
        alert.title = "Cancel Request"
        alert.message = "\(transaction.service)"
        alert.addAction(UIAlertAction.init(title: "OK", style: .destructive, handler: { (alertAction) in
            self.transactionManager.cancelAction(transaction: transaction, uid: uid)
        }))
        return alert
    }
    
    func showAlert(alert:UIAlertController){
        let customPresenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.50)
            let height = ModalSize.fluid(percentage: 0.20)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = false
            return customPresenter
        }()
        customPresentViewController(customPresenter, viewController: alert, animated: true, completion: nil)
    }
    
    func setupNavigationHeader(){
        let imageView = UIImageView.init(image: UIImage.init(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 126.88, height: 30))
        imageView.frame = titleView.frame
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(gradientStyle: .topToBottom, withFrame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64), andColors: [UIColor.init(hexString: "FDD155"),UIColor.init(hexString: "E2A602")])
    }
}

extension NotificationTableViewController{
    func parseCellType(transaction:Transaction) -> (String, NotificationType) {
        var description:String = ""
        if transaction.isProvider {
            //this is provider alert
            let othername = transaction.seeker
            switch transaction.state {
            case "request":
                description = "\(othername) has requested for your help with \(transaction.service)"
                return (description, NotificationType.double)
            case "cancel":
                description = "\(othername) has cancelled request for \(transaction.service)"
                return (description, NotificationType.single)
            case "deliver":
                description = "Did you finish helping \(othername) with \(transaction.service)?"
                return (description, NotificationType.double)
            case "finish":
                description = "Thank you for helping \(othername) with \(transaction.service)"
                return (description, NotificationType.single)
            case "refund":
                description = "\(othername) has requested a refund for your service"
                return (description, NotificationType.single)
            default:
                return ("This is a Wrong Message",NotificationType.singleInfo)
            }
        }else{
            let othername = transaction.provider
            switch transaction.state {
            case "request":
                description = "You have requested \(othername) for help with \(transaction.service)"
                return (description, NotificationType.single)
            case "cancel":
                description = "You have cancelled your reuqest for \(transaction.service)"
                return (description, NotificationType.single)
            case "deliver":
                description = "\(othername) has accepted your request for \(transaction.service)"
                return (description, NotificationType.singleInfo)
            case "finish":
                description = "Did \(othername) finished helping you with \(transaction.service)?"
                return (description, NotificationType.double)
            case "refund":
                description = "You have requested a refund for \(transaction.service)"
                return (description, NotificationType.single)
            default:
                return ("This is a Wrong Message",NotificationType.singleInfo)
            }
        }
    }
    
    
}


