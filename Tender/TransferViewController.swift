//
//  TransferViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/26/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationHeader()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        UserManager().getUsers(query: searchBar.text!, callback: { users in
            self.users = users
            self.tableView.reloadData()
        })
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        let user = users[indexPath.row]
        cell.fillCellWithThumbnail(profile: user.name!, email: user.email!, thumbnailUrl: user.thumbnail!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TransferPost")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserManager().getUsers(query: searchText, callback: { users in
            self.users = users
            self.tableView.reloadData()
        })
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
