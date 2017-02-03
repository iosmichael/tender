//
//  PostDetailTableViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController, PostCellProtocol {

    enum cellType {
        case credits
        case skillsetAdd
        case skillsetDelete
        case inputField
        case header
        case textLabel
    }
    
    var service:Service?
    
    let creditIndex = 5
    let titleIndex = 3
    let insertIndex = 8
    var tableStructure = [(cellType.header,"Category"),
                          (cellType.textLabel,"Creative Work"),
                          (cellType.header,"Title"),
                          (cellType.inputField,"Photoshop/ Video Editing"),
                          (cellType.header,"Credits"),
                          (cellType.credits,"1"),
                          (cellType.header,"Skill Sets"),
                          (cellType.skillsetAdd,"Adobe Photoshop")]
    
    var sCredits:String = "1"
    var destailSets:[String] = []
    var postTitle:String = "Empty Service"
    var category:String = "Creative Work"
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStructure.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = .none
        let (type, input) = tableStructure[indexPath.row]
        cell.delegate = self
        fill(cell: cell, type: type, input: input)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (type, _) = tableStructure[indexPath.row]
        return height(type: type)
    }
    
    func summary() -> Service{
        let service = Service()
        service.category = category
        service.title = postTitle
        service.credits = sCredits
        service.skills = destailSets
        return service
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

    func updateCredit(credit: String) {
        tableStructure[creditIndex] = (cellType.credits,credit)
        self.sCredits = credit
    }
    
    func addPoint(label: String) {
        tableStructure.insert((cellType.skillsetDelete,label), at: insertIndex)
        self.destailSets.append(label)
        self.tableView.reloadData()
    }
    
    func deletePoint(cell: PostTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        tableStructure.remove(at: (indexPath?.row)!)
        self.destailSets.remove(at: (indexPath?.row)! - insertIndex)
        self.tableView.reloadData()
    }
    
    func updateTitle(title: String) {
        self.postTitle = title
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        print("Done Btn Pressed")
        ServiceManager().postService(service:summary())
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
        
    func sampleData()->Service{
        let service = Service()
        service.category = "Creative Work"
        service.title = "Photoshop"
        service.credits = "20"
        service.skills = ["photoshop","web design", "video editing"]
        return service
    }
    
}
