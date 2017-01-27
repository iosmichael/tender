//
//  TransferPostViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/26/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class TransferPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    enum cellType {
        case credits
        case skillsetAdd
        case skillsetDelete
        case inputField
        case header
        case textLabel
    }
    
    var tableStructure = [(cellType.header,"Title"),
                          (cellType.inputField,"Photoshop/ Video Editing"),
                          (cellType.header,"Credits"),
                          (cellType.credits,"16"),
                          (cellType.header,"Skill Sets"),
                          (cellType.skillsetAdd,"Adobe Photoshop")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStructure.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.selectionStyle = .none
        let (type, input) = tableStructure[indexPath.row]
        fill(cell: cell as! PostTableViewCell, type: type, input: input)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (type, _) = tableStructure[indexPath.row]
        return height(type: type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transferClick(_ sender: Any) {
        
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
