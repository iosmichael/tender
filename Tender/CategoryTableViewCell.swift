//
//  CategoryTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/29/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
class CategoryCollectionView:UICollectionView{
    var indexPath:IndexPath?
}

class CategoryTableViewCell: UITableViewCell {

    var collectionView:CategoryCollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 1.5, bottom: 10, right: 1.5)
        layout.itemSize = CGSize.init(width: 130, height: 235)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        self.collectionView = CategoryCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.contentView.addSubview(self.collectionView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView?.frame = self.contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCollectionViewDataSourceDelegate(dataSource:UICollectionViewDataSource, delegate:UICollectionViewDelegate, indexPath:IndexPath){
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = delegate
        self.collectionView?.indexPath = indexPath
        self.collectionView?.reloadData()
    }

}
