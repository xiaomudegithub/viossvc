//
//  UserPictureCollectionView.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class UserPictureItem: UICollectionViewCell {
    @IBOutlet weak var userPicture: UIImageView!
    
}


class UserPictureCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var picturesData: [String]?
    var itemHeight: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let layout = UICollectionViewFlowLayout()
        itemHeight = (UIScreen.width() - 32) / 4
        layout.itemSize = CGSizeMake(itemHeight, itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionViewLayout = layout
        delegate = self
        dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesData!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(UserPictureItem.className(), forIndexPath: indexPath)
        item.backgroundColor = UIColor.redColor()
        return item
    }
    
    func updateMyPicture(data: AnyObject, complete: CompleteBlock?) {
        picturesData = data as? [String]
        reloadData()
        if complete != nil {
            let rows = picturesData!.count / 4
            let height = itemHeight * (rows == 1 ? CGFloat(rows) : CGFloat(rows + 1) )
            complete!(height)
        }
    }
    
}