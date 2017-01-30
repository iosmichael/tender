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
    
    let categoryList = ["cat1","cat2","cat3","cat1","cat2","cat3","cat1","cat2","cat3","cat1","cat2","cat3"]
    let itemInRow: CGFloat = 3
    let itemMargins: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.collectionView.frame.size.width/3.1
        let itemHeight = itemWidth * 235 / 130
        layout.sectionInset = UIEdgeInsets.init(top: 2*itemMargins, left: itemMargins, bottom: 2*itemMargins, right: itemMargins)
        layout.minimumLineSpacing = 4
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
        let image = UIImage.init(named: categoryList[indexPath.item])
        imageView.image = image
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostDetail")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

