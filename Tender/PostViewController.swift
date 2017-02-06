//
//  PostViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var provideServiceTitle: UILabel!
    @IBOutlet weak var chooseCategory: UILabel!
    
    let categoryList = [("cat1","Creative Work"),
                        ("cat2","Professional Work"),
                        ("cat3","Creative Work"),
                        ("cat1","Creative Work"),
                        ("cat2","Creative Work"),
                        ("cat3","Creative Work"),
                        ("cat1","Creative Work"),
                        ("cat2","Creative Work"),
                        ("cat3","Creative Work")]
    let itemInRow: CGFloat = 3
    let itemMargins: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationHeader()
        self.provideServiceTitle.font = UIFont.init(name: "Seravek-Bold", size: 24)
        self.chooseCategory.font = UIFont.init(name: "Seravek-ExtraLight", size: 20)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.collectionView.frame.size.width/3.1
        let itemHeight = itemWidth * 235 / 130
        layout.sectionInset = UIEdgeInsets.init(top: itemMargins, left: itemMargins, bottom: itemMargins, right: 0)
        layout.minimumLineSpacing = 1.5
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelPopup(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        let imageView = UIImageView.init(frame: cell.contentView.frame)
        let (imageName,_) = categoryList[indexPath.item]
        let image = UIImage.init(named: imageName)
        imageView.image = image
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostDetail") as! PostDetailTableViewController
        let (_,categoryName) = categoryList[indexPath.item]
        vc.category = categoryName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
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

