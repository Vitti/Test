//
//  FeedPhotosVC.swift
//  Test
//
//  Created by Vitaliy_mac_os on 07.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AlamofireImage

class UserPhotosVC: UIViewController {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var userPhotosViewModel: UserPhotoViewModel?
    var userViewModel: UserViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collView.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
        
        if let user = userViewModel?.user.value {
            userPhotosViewModel = UserPhotoViewModel(user)
            
            if let viewModel = userPhotosViewModel {
                
                viewModel.data.bind(to: collView.rx.items(cellIdentifier: "photoCell")) {_, model, cell in
                    
                    if let photoCell = cell as? PhotoCell, let photo = model.photo.value, let urlString = photo.urlSmall, let url = URL.init(string: urlString) {
                        photoCell.titleLabel.text = photo.name
                        photoCell.imageView.image = nil
                        photoCell.imageView.af_setImage(withURL: url)  { response in
                            
                            model.image = response.value
                        }
                    }
                    }.disposed(by: disposeBag)
                
                collView.rx.itemSelected.subscribe (onNext: { indexPath in
                    
                    let vcDetail = self.storyboard?.instantiateViewController(withIdentifier: "detailPhotoVC") as? DetailPhotoVC
                    vcDetail?.photoViewModel = viewModel.data.value[indexPath.row]
                    self.present(vcDetail!, animated: true, completion: nil)
                    
                }).disposed(by: disposeBag)
                
                collView.rx.setDelegate(self).disposed(by: disposeBag)
            }
        }
        
        backButton.rx.tap.bind {
            
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserPhotosVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height - scrollView.contentOffset.y <  UIScreen.main.bounds.size.height * 2 {
            
            userPhotosViewModel?.getNextPage()
        }
    }
}

extension UserPhotosVC : CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let widthCell = CGFloat.minimum(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / 3 - 4
        var ratio = CGFloat(1)
        if let viewModel = userPhotosViewModel, let photo = viewModel.data.value[indexPath.row].photo.value {
            ratio = CGFloat(CGFloat(photo.width) / CGFloat(photo.height))
        }
        
        return (widthCell / ratio)
    }
}

