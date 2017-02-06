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
    
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    let bottomGathomFont = UIFont.init(name: "Gotham-Medium", size: 17)
    var isInfo:Bool = false
    
    var service:Service?
    var tableStructure:[(cellType,String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationHeader()
        if isInfo {
            buttonHeight.constant = 0
        }else{
            buttonHeight.constant = 50
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        self.tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tableView.separatorStyle = .none
        setupData()
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
        return tableStructure!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableStructure!.count {
            //profile cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            cell.fillCell(profile: (service?.provider!)!, email: (service?.providerEmail!)!)
            cell.thumbnail.downloadedFrom(link: (service?.thumbnail)!)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
            cell.selectionStyle = .none
            let (type, input) = tableStructure![indexPath.row]
            fill(cell: cell as! PostTableViewCell, type: type, input: input)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableStructure!.count && !isInfo{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "Friend") as! FriendViewController
            let user = User()
            user.email = service?.providerEmail!
            user.name = service?.provider!
            user.thumbnail = service?.thumbnail!
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tableStructure!.count {
            return 45
        }
        let (type, _) = tableStructure![indexPath.row]
        return height(type: type)
    }
    
    @IBAction func getHelpButtonClicked(_ sender: Any) {
        //ASK help button clicked
        let transaction = Transaction()
        if UserDefaults.standard.value(forKey: "uid") == nil{
            return
        }
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        let username = UserDefaults.standard.value(forKey: "name") as! String
        transaction.credit = (service?.credits)!
        transaction.state = "request"
        transaction.serviceId = (service?.id!)!
        transaction.seeker = username
        transaction.provider = (service?.provider!)!
        transaction.isProvider = false
        transaction.user = (service?.uid!)!
        transaction.service = (service?.title)!
        TransactionManager().postTransaction(transaction: transaction, uid: uid)
        print("ask help button clicked")
    }

    func setupData(){
        let title:String = (service?.title!)!
        let credit:String = (service?.credits!)!
        tableStructure = [(cellType.header, "Title"),
                          (cellType.textLabel,title),
                          (cellType.header, "Credits"),
                          (cellType.textLabel,credit),
                          (cellType.header, "Skill Sets"),
                          (cellType.header,"Provider")]
        for item in (service?.skills)!{
            let skill = (cellType.skillset, item)
            tableStructure?.insert(skill, at: 5)
        }
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

    func showButton(show:Bool){
        isInfo = !show
        
    }
    
    func setupNavigationHeader(){
        let imageView = UIImageView.init(image: UIImage.init(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 126.88, height: 30))
        imageView.frame = titleView.frame
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }

}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIButton {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.setImage(image, for: .normal)
            }
            }.resume()
    }

    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
