//
//  FriendViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/27/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    
    var currentViewController: UIViewController?
    var allViewControllers: [UIViewController]?
    var priorSegmentIndex: NSInteger?
    
    var friendId:String?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThumbnailShadow()
        priorSegmentIndex = 0
        let serviceController = SegmentTableViewController()
        if friendId != nil {
            serviceController.uid = friendId
        }
        let completeController = HistoryTableViewController()
        allViewControllers = [serviceController,completeController]
        self.cycleFromViewController(oldVC: self.currentViewController, newVC: self.allViewControllers![priorSegmentIndex!], dir: true)
        
        // Do any additional setup after loading the view.
    }
    
    func setupThumbnailShadow() {
        profileName.font = UIFont.init(name: "Seravek-Bold", size: 20)
        email.font = UIFont.init(name: "Seravek-ExtraLight", size: 17)
        if user != nil{
            self.profileName.text = user?.name!
            self.email.text = user?.email!
            self.thumbnail.downloadedFrom(link: (user?.thumbnail!)!)
        }
        thumbnail.layer.shadowColor = UIColor.flatBlack().cgColor
        thumbnail.layer.shadowOpacity = 1
        thumbnail.layer.shadowOffset = CGSize.zero
        thumbnail.layer.shadowRadius = 2
        thumbnail.layer.shouldRasterize = true
    }
    
    func cycleFromViewController(oldVC: UIViewController?, newVC: UIViewController, dir: Bool){
        // Do nothing if we are attempting to swap to the same view controller
        if newVC == oldVC {
            return
        }
        
        let viewBound = self.viewContainer?.bounds
        var newX = ((viewBound)?.minX)! - (viewBound?.width)!
        var oldX = (viewBound?.minX)! + (viewBound?.width)!
        if dir {
            let temp = oldX
            newX = oldX
            oldX = temp
        }
        newVC.view.frame = CGRect.init(x: newX, y: (viewBound?.minY)!, width: (viewBound?.width)!, height: (viewBound?.height)!)
        if oldVC != nil {
            oldVC!.willMove(toParentViewController: nil)
            self.addChildViewController(newVC)
            self.transition(from: oldVC!, to: newVC, duration: 0.15, options: .layoutSubviews, animations: {
                newVC.view.frame = oldVC!.view.frame
                oldVC!.view.frame = CGRect.init(x: oldX, y: (viewBound?.minY)!, width: (viewBound?.width)!, height: (viewBound?.height)!)
            }, completion: { (_:Bool) in
                oldVC!.removeFromParentViewController()
                newVC.didMove(toParentViewController: self)
                self.currentViewController = newVC
            })
        }else{
            newVC.view.frame = CGRect.init(x: (viewBound?.minX)!, y: (viewBound?.minY)!, width: (viewBound?.width)!, height: (viewBound?.height)!)
            self.addChildViewController(newVC)
            self.viewContainer?.addSubview(newVC.view)
            newVC.didMove(toParentViewController: self)
            self.currentViewController = newVC
        }
    }
    
    func displayViewController(vc: UIViewController) {
        let itemVC = vc as! ServiceViewController
        itemVC.showButton(show: false)
        self.navigationController?.pushViewController(itemVC, animated: true)
    }

}
