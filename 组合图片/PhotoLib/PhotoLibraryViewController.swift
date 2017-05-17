//
//  PhotoLibraryViewController.swift
//  FileManager
//
//  Created by WuYueFeng on 16/8/11.
//  Copyright © 2016年 WuYueFeng. All rights reserved.
//

import UIKit
import Photos

//extension PHAsset {
//    func img()->UIImage! {
//        let option = PHContentEditingInputRequestOptions.init()
//        var rs:UIImage! = nil
//        self.requestContentEditingInputWithOptions(option) { (contentEditingInput, _) in
//            if let input = contentEditingInput,
//                let url = input.fullSizeImageURL ,
//                let image = CIImage.init(contentsOfURL: url) {
//                rs = UIImage.init(CIImage: image)
//            }
//            
//        }
//        return rs
//    }
//}

class uploadData {
    var name:String!
    var data:Data!
}

class PhotoLibraryViewController:UINavigationController {
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//    }
    
    class func Alert(sendImgs:@escaping callBack)->PhotoLibraryViewController {
        let vc = PhotoLibraryViewController.init(rootViewController: PhotoTableViewController())
        vc.call = sendImgs
        return vc
    }
    
    

    typealias callBack = ([uploadData]) -> Void
    
    var call:callBack!
    
//    func sendImgs(back:callBack) {
//        call = back
//    }

}


class PhotoTableViewController:UITableViewController {
    
    
    var titles = [String]()
    var imgs = [UIImage!]()
    
    var dataSource = [PHAssetCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "LibTableViewCell", bundle: nil), forCellReuseIdentifier: "LibTableViewCell")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismiss_old))
        
        let Abcollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        for i in 0..<Abcollections.count {
            if let str = Abcollections[i] as? PHAssetCollection {
                self.titles.append(str.localizedTitle ?? "")
                self.dataSource.append(str)
                if let data = self.enumerateAssetsInAssetCollection(assetCollection: str) {
                    self.imgs.append(UIImage.init(data:data as Data))
                }else { self.imgs.append(nil) }

            }
        }
        
        let Addcollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        
        for i in 0..<Addcollections.count {
            if let str = Addcollections[i] as? PHAssetCollection {
                self.titles.append(str.localizedTitle ?? "")
                self.dataSource.append(str)
                if let data = self.enumerateAssetsInAssetCollection(assetCollection: str) {
                    self.imgs.append(UIImage.init(data:data as Data))
                }else {
                    self.imgs.append(nil)
                }
            }
        }
        
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        for i in 0..<collections.count {
            if let str = collections[i] as? PHAssetCollection {
                self.dataSource.append(str)
                self.titles.append(str.localizedTitle ?? "")
                if let data = self.enumerateAssetsInAssetCollection(assetCollection: str) {
                    self.imgs.append(UIImage.init(data:data as Data))
                }else { self.imgs.append(nil) }
            }
        }
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibTableViewCell", for: indexPath as IndexPath) as! LibTableViewCell
       
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.imgView.image = imgs.count > indexPath.row ? imgs[indexPath.row] : nil
        
        return cell
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = PhotoCollectViewController()
        vc.source = self.dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func enumerateAssetsInAssetCollection(assetCollection:PHAssetCollection)->NSData! {
        
        var rs:NSData! = nil
        guard let asset = PHAsset.fetchAssets(in: assetCollection, options: nil).lastObject else{ return rs }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (imgData, dataUTI, orientation, info) in
           
            rs = imgData! as NSData
        })
    
        return rs
    }
    
    func dismiss_old() {
        self.dismiss(animated: true, completion: nil)
    }
}

class PhotoCollectViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    var source:PHAssetCollection!
    
    var imgs = [NSData]()
    var names = [String]()
    
    var phassets = [PHAsset]()
    
    var colloectView:UICollectionView!
    
    var editDic = [Int:Bool]()
    
    
    lazy var numButton:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        btn.setBackgroundImage(UIImage(name:.yuan), for: UIControlState.normal)
        return btn
    }()
    
    lazy var button:UIButton = {
        let btn = UIButton.init(frame:CGRect.init(x: 0, y: 0, width: 50, height: 40))
        btn.setTitle("发送", for: UIControlState.normal)
        btn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        return btn
    }()
    
    
    private var selectNum:Int = 0 {
        didSet {
            numButton.setTitle(String(selectNum), for: UIControlState.normal)
        }
    }
    
    
    var itemSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.view.bounds.width > self.view.bounds.height {
            itemSize = CGSize.init(width: self.view.bounds.height/4, height: self.view.bounds.height/4)
        }else {
            itemSize = CGSize.init(width: self.view.bounds.width/4, height: self.view.bounds.width/4)
        }
        
        //print(itemSize.width,self.view.width)
        
        let layout = UICollectionViewFlowLayout()
        
        enumerateAssetsInAssetCollection(assetCollection: source)
        
        colloectView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        colloectView.backgroundColor = UIColor.white
        colloectView.delegate = self
        colloectView.dataSource = self
        self.view.addSubview(colloectView)
        
        colloectView.register(UINib.init(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionViewCell")
        
        
        colloectView.selectItem(at: IndexPath.init(row: imgs.count-1, section: 0), animated: false, scrollPosition: .bottom)
        
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: button),UIBarButtonItem.init(customView: numButton)]
        
        
        button.addTarget(self, action: #selector(self.send), for: UIControlEvents.touchUpInside)
        
    }
    
    func send() {
        var tempImgs = [uploadData]()

        for num in editDic {
            if num.1 {
                let temp = uploadData()
                temp.data = imgs[num.0] as Data
                temp.name = names[num.0]
                tempImgs.append(temp)
            }
        }
        
        let nav = self.navigationController as? PhotoLibraryViewController
       
        nav?.call(tempImgs)
        
        
        
    }
    
    
    func enumerateAssetsInAssetCollection(assetCollection:PHAssetCollection) {
        
        
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        for i in 0..<assets.count {
            if let asset = assets[i] as? PHAsset {
                //self.phassets.append(asset)
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (imgData, _, _, info) in
                    if imgData != nil {
                        self.imgs.append(imgData! as NSData)
                        if let str = asset.value(forKey: "filename") as? String {
                            self.names.append(str)
                        }else {
                            self.names.append("")
                        }
                    }
                    
                })
            }
        }
        //self.colloectView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        colloectView.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
        
        //cell.imgView.image = self.phassets[indexPath.row].img()
        cell.imgView.image = UIImage.init(data:imgs[indexPath.row] as Data)
        
        if editDic[indexPath.row] != nil && editDic[indexPath.row]! {
            cell.coverimg.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
            cell.buttonimg.image = UIImage.init(name: .blue_select)
        }else {
            cell.coverimg.backgroundColor = UIColor.clear
            cell.buttonimg.image = UIImage.init(name: .gray_select)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if editDic[indexPath.row] != nil {
            if editDic[indexPath.row]! {
                editDic.removeValue(forKey: indexPath.row)
                self.selectNum -= 1
                colloectView.reloadItems(at: [indexPath as IndexPath])
            }
        }else {
            if editDic.count > 7 {
                //self.alertWith("选择不多于8个")
            }else {
                editDic[indexPath.row] = true
                self.selectNum += 1
                colloectView.reloadItems(at: [indexPath as IndexPath])
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ sizeForItemAtcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

}
