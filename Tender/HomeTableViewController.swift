//
//  HomeTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import GoogleSignIn

class HomeTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    let categoryReuseStr:String = "CategoryCell"
    let itemReuseStr:String = "ItemCell"
    
    let categoryList = [("cat1","Creative Work"),
                        ("cat2","Professional Work"),
                        ("cat3","Creative Work")]
    var services:[Service] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationHeader()
        self.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: categoryReuseStr)
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemReuseStr)
        GIDSignIn.sharedInstance().signOut()
        ServiceManager().getMostRecentServices(reloadFunc: { data in
            self.services = data
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: "uid") == nil {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
            self.present(loginVC, animated: true, completion: nil)
        }
        
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
        return section == 0 ? 1 : services.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: itemReuseStr, for: indexPath) as! ItemTableViewCell
            let service = services[indexPath.row]
            cell.fillCell(title: service.title!, provider: service.provider!, labelDate: service.date!, credit: service.credits!)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : 45
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = fetchViewControllerFromMain(withIdentifier: "Service") as! ServiceViewController
            vc.service = services[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryTableViewController()
        let (_, categoryName) = categoryList[indexPath.row]
        vc.category = categoryName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        let imageView = UIImageView.init(frame: cell.contentView.bounds)
        let (imageName, _) = categoryList[indexPath.item]
        imageView.image = UIImage.init(named: imageName)
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

extension UITableViewController{
    func headerView(input:String) -> UIView{
        let height:CGFloat = 45
        let leftMargin:CGFloat = 15
        let topMargin:CGFloat = 15
        let gothamFont:UIFont = UIFont.init(name: "Seravek-Bold", size: 30)!
        let label:UILabel = UILabel.init(frame: CGRect.init(x: leftMargin, y: topMargin, width: UIScreen.main.bounds.width-2*leftMargin, height: height-topMargin))
        label.font = gothamFont
        label.text = input
        label.textColor = UIColor.init(hexString: "26A976")
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        headerView.addSubview(label)
        headerView.backgroundColor = .white
        return headerView
    }
    
    func fetchViewControllerFromMain(withIdentifier:String) -> UIViewController{
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return vc
    }
}
