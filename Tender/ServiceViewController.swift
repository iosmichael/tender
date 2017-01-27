//
//  ServiceViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/26/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    enum cellType {
        case skillset
        case header
        case textLabel
    }
    
    let bottomGathomFont = UIFont.init(name: "Gotham-Medium", size: 17)
    
    var tableStructure = [(cellType.header, "Title"),
                          (cellType.textLabel,"Photoshop/ Video Editing"),
                          (cellType.header, "Credits"),
                          (cellType.textLabel,"16 tc."),
                          (cellType.header, "Skill Sets"),
                          (cellType.skillset, "Adobe Lightroom"),
                          (cellType.header,"Provider")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        self.tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tableView.separatorStyle = .none
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //additional one is profile table view cell
        return tableStructure.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableStructure.count {
            //profile cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
            cell.selectionStyle = .none
            let (type, input) = tableStructure[indexPath.row]
            fill(cell: cell as! PostTableViewCell, type: type, input: input)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tableStructure.count {
            return 65
        }
        let (type, _) = tableStructure[indexPath.row]
        return height(type: type)
    }
    
    @IBAction func getHelpButtonClicked(_ sender: Any) {
        //ASK help button clicked
        print("ask help button clicked")
    }

    
    
    /*
     case skillset
     case header
     case textLabel
     */
    func fill(cell:PostTableViewCell,type:cellType, input:String){
        switch type {
        case .skillset:
            cell.skillset(labelStr: input)
            break
        case .header:
            cell.headerText(labelStr: input)
            break
        case .textLabel:
            cell.textField(labelStr: input)
            break
        }
    }
    
    func height(type:cellType)->CGFloat{
        let cell = PostTableViewCell()
        switch type {
        case .skillset:
            return cell.getSkillsetHeight()
        case .header:
            return cell.getHeaderHeight()
        case .textLabel:
            return cell.gettextFieldHeight()
        }
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
