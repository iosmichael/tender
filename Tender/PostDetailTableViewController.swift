//
//  PostDetailTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    enum cellType {
        case credits
        case skillsetAdd
        case skillsetDelete
        case inputField
        case header
        case textLabel
    }
    
    var tableStructure = [(cellType.header,"Category"),
                          (cellType.textLabel,"Creative Work"),
                          (cellType.header,"Title"),
                          (cellType.inputField,"Photoshop/ Video Editing"),
                          (cellType.header,"Credits"),
                          (cellType.credits,"16"),
                          (cellType.header,"Skill Sets"),
                          (cellType.skillsetAdd,"Adobe Photoshop"),
                          (cellType.skillsetDelete,"Web Design"),
                          (cellType.skillsetDelete,"Adobe Lightroom")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableStructure.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.selectionStyle = .none
        let (type, input) = tableStructure[indexPath.row]
        fill(cell: cell as! PostTableViewCell, type: type, input: input)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (type, _) = tableStructure[indexPath.row]
        return height(type: type)
    }
    
    func summary() -> [String: Any]{
        
        return ["":""]
    }
    
    /*
     case credits
     case skillsetAdd
     case skillsetDelete
     case inputField
     case header
     case textLabel
     */
    func fill(cell:PostTableViewCell,type:cellType, input:String){
        switch type {
        case .credits:
            cell.credits(inputStr: input)
            break
        case .skillsetAdd:
            cell.skillsetAdd(labelStr: input)
            break
        case .skillsetDelete:
            cell.skillsetDelete(labelStr: input)
            break
        case .inputField:
            cell.inputField(labelStr: input)
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
        case .credits:
            return cell.getCreditHeight()
        case .skillsetAdd:
            return cell.getSkillsetHeight()
        case .skillsetDelete:
            return cell.getSkillsetHeight()
        case .inputField:
            return cell.getinputHeight()
        case .header:
            return cell.getHeaderHeight()
        case .textLabel:
            return cell.gettextFieldHeight()
        }
    }


}
