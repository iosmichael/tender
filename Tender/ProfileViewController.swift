//
//  ProfileViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    var currentViewController: UIViewController?
    var allViewControllers: [UIViewController]?
    var priorSegmentIndex: NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segment.selectedSegmentIndex = 0
        priorSegmentIndex = 0
        let serviceController = SegmentTableViewController()
        let ongoingController = SegmentTableViewController()
        let completeController = SegmentTableViewController()
        allViewControllers = [serviceController,ongoingController,completeController]
        self.cycleFromViewController(oldVC: self.currentViewController, newVC: self.allViewControllers![priorSegmentIndex!], dir: true)
        self.segment.addTarget(self, action: #selector(indexDidChangeForSegmentedControl(sender:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
