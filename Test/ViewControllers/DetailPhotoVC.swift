//
//  DetailPhotoVC.swift
//  Test
//
//  Created by v.sova on 11.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class DetailPhotoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    ///details
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var closeDetailButton: UIButton!
    
    var photoViewModel: PhotoViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = photoViewModel {
            
            viewModel.photo.asObservable().subscribe(onNext: { (photo) in
                
                if let urlStr = photo?.urlFull, let url = URL.init(string: urlStr) {
                    
                    self.imageView.af_setImage(withURL: url, placeholderImage: viewModel.image)
                }
                
                if let isLike = photo?.likedByUser {
                
                    self.likeButton.setTitle(isLike ? "Unlike" : "Like", for: .normal)
                }
                
            }).disposed(by: disposeBag)
            
            viewModel.statistics.asObservable().subscribe(onNext: { (statistic) in
                
                guard let s = statistic else {
                    return
                }
                
                self.likesLabel.text = "\(s.likes)"
                self.downloadsLabel.text = "\(s.downloads)"
                self.viewsLabel.text = "\(s.views)"
            }).disposed(by: disposeBag)
        }
        
        closeButton.rx.tap.bind {
            
            self.dismiss(animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
        
        likeButton.rx.tap.bind {
            
            self.photoViewModel?.likeOrUnlike()
            
        }.disposed(by: disposeBag)
        
        infoButton.rx.tap.bind {
            
            self.photoViewModel?.updateStatistics()
            self.detailsView.isHidden = false

        }.disposed(by: disposeBag)
        
        closeDetailButton.rx.tap.bind {
            
            self.detailsView.isHidden = true
        }.disposed(by: disposeBag)
    }
}
