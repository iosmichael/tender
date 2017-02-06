//
//  ProfileViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import GoogleSignIn
import UIKit

class ProfileViewController: UIViewController, SegmentTableDelegate, GIDSignInUIDelegate{

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var credits: UILabel!
    var currentViewController: UIViewController?
    var allViewControllers: [UIViewController]?
    var priorSegmentIndex: NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationHeader()
        setupThumbnailShadow()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue:"loginNotification"), object: nil)
        self.segment.selectedSegmentIndex = 0
        priorSegmentIndex = 0
        let serviceController = SegmentTableViewController()
        serviceController.segmentDelegate = self
        let ongoingController = SegmentTableViewController()
        ongoingController.segmentDelegate = self
        let completeController = HistoryTableViewController()
        allViewControllers = [serviceController,ongoingController,completeController]
        self.cycleFromViewController(oldVC: self.currentViewController, newVC: self.allViewControllers![priorSegmentIndex!], dir: true)
        self.segment.addTarget(self, action: #selector(indexDidChangeForSegmentedControl(sender:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func logout(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
        if UserDefaults.standard.value(forKey: "uid") == nil {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    func setupThumbnailShadow() {
        username.font = UIFont.init(name: "Seravek-Bold", size: 20)
        credits.font = UIFont.init(name: "Seravek-Bold", size: 23)
        if UserDefaults.standard.value(forKey: "thumbnail") == nil{
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }else{
            print("credit updated")
            thumbnail.downloadedFrom(link: UserDefaults.standard.value(forKey: "thumbnail") as! String)
            username.text = UserDefaults.standard.value(forKey: "name") as? String
            CreditManager().getCredit(uid: UserDefaults.standard.value(forKey: "uid") as! String, callback: { (credit) in
                self.credits.text = "\(credit)"
            })
        }
        thumbnail.layer.shadowColor = UIColor.flatBlack().cgColor
        thumbnail.layer.shadowOpacity = 1
        thumbnail.layer.shadowOffset = CGSize.zero
        thumbnail.layer.shadowRadius = 2
        thumbnail.layer.shouldRasterize = true
    }
    
    func refresh(){
        thumbnail.downloadedFrom(link: UserDefaults.standard.value(forKey: "thumbnail") as! String)
        username.text = UserDefaults.standard.value(forKey: "name") as? String
        CreditManager().getCredit(uid: UserDefaults.standard.value(forKey: "uid") as! String, callback: { (credit) in
            self.credits.text = "\(credit)"
        })
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

    func indexDidChangeForSegmentedControl(sender:UISegmentedControl){
        let index = sender.selectedSegmentIndex
        if UISegmentedControlNoSegment != index {
            var direction = false;
            if priorSegmentIndex! < index {
                direction = true
            }
            let incomingVC = self.allViewControllers?[index]
            self.cycleFromViewController(oldVC: self.currentViewController, newVC: incomingVC!, dir: direction)
        }
        priorSegmentIndex = index
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
    
    func displayViewController(vc: UIViewController) {
        let itemVC = vc as! ServiceViewController
        itemVC.showButton(show: false)
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
}
