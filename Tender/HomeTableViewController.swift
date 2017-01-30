//
//  HomeTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeTableViewController: UITableViewController, GIDSignInUIDelegate, UICollectionViewDataSource, UICollectionViewDelegate{

    let categoryReuseStr:String = "CategoryCell"
    let itemReuseStr:String = "ItemCell"
    
    let listNum = 10
    let categoryList = ["cat1","cat2","cat3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryReuseStr)
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemReuseStr)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        let services = ServiceManager().getMostRecentServices()
        print(services)
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
        return section == 0 ? 1 : listNum
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return headerView(input: "Most Recent")
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 60 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryReuseStr, for: indexPath) as! CategoryTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: itemReuseStr, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : 45
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = fetchViewControllerFromMain(withIdentifier: "Service")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        let imageView = UIImageView.init(frame: cell.contentView.bounds)
        imageView.image = UIImage.init(named: categoryList[indexPath.item])
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        //add image and button here
        cell.contentView.addSubview(imageView)
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let categoryCell = cell as! CategoryTableViewCell
            categoryCell.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, indexPath: indexPath)
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
        label.textColor = .white
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.init(hexString: "27A877")
        return headerView
    }
    
    func fetchViewControllerFromMain(withIdentifier:String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return vc
    }
}

