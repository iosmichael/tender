//
//  HomeTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    let categoryReuseStr:String = "CategoryCell"
    let itemReuseStr:String = "ItemCell"
    
    let listNum = 10
    let categoryList = [("creative","Creative Work"),
                        ("profession","Professional Work"),
                        ("errands","Errands"),
                        ("meal","Cooking")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: categoryReuseStr)
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemReuseStr)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func addService(_ sender: Any) {
        let vc = fetchViewControllerFromMain(withIdentifier: "Post")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? categoryList.count : listNum
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return headerView(input: "Category")
        }else{
            return headerView(input: "Most Recent")
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryReuseStr, for: indexPath) as! CategoryTableViewCell
            let (icon,name) = categoryList[indexPath.row]
            cell.initCell(title: name, icon: UIImage.init(named: icon)!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: itemReuseStr, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 40 : 65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = CategoryTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = fetchViewControllerFromMain(withIdentifier: "ServiceDetail")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension UITableViewController{
    func headerView(input:String) -> UIView{
        let height:CGFloat = 45
        let leftMargin:CGFloat = 15
        let topMargin:CGFloat = 15
        let gothamFont:UIFont = UIFont.init(name: "Gotham-Medium", size: 30)!
        let label:UILabel = UILabel.init(frame: CGRect.init(x: leftMargin, y: topMargin, width: UIScreen.main.bounds.width-2*leftMargin, height: height-topMargin))
        label.font = gothamFont
        label.text = input
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func fetchViewControllerFromMain(withIdentifier:String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return vc
    }
}
