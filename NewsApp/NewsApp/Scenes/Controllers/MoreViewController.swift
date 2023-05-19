//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by serdar on 18.05.2023.
//

import UIKit
import SDWebImage
import SafariServices

class MoreViewController: UIViewController {
    
    @IBOutlet weak var fadeBlackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var descriiptionLabel: UILabel!
    @IBOutlet weak var dateLatel: UILabel!
    @IBOutlet weak var writerNameLabel: UILabel!
    
    var imageURL: String?
    var readMoreURL: String?
    var titleString: String?
    var desc: String?
    var date: String?
    var writerName: String?
    
    var moreViewModel: MoreViewModelProtocol!{
        didSet {
            moreViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        // configure image
        let fullPath = imageURL ?? ""
        if let url = URL(string: fullPath) {
            imageView.sd_setImage(with: url)
        }
        imageView.layer.cornerRadius = moreViewModel.cornerRadius
        imageView.layer.masksToBounds = moreViewModel.masksToBounds
        
        fadeBlackImageView.layer.cornerRadius = moreViewModel.cornerRadius
        fadeBlackImageView.layer.masksToBounds = moreViewModel.masksToBounds
        
        //configure labels
        descriiptionLabel.text = desc
        dateLatel.text = date
        writerNameLabel.text = writerName
        titleLabel.text = titleString
        
        //configure button
        readMoreButton.layer.cornerRadius = moreViewModel.cornerRadius
        readMoreButton.layer.masksToBounds = false
        
        readMoreButton.layer.shadowColor = UIColor.black.cgColor
        readMoreButton.layer.shadowOffset = CGSize(
            width: moreViewModel.shadowOffset.width,
            height: moreViewModel.shadowOffset.height
        )
        readMoreButton.layer.shadowOpacity = moreViewModel.shadowOpacity
        readMoreButton.layer.shadowRadius = moreViewModel.shadowRadius
    }
    
    @IBAction func onClickedRedMoreButton(_ sender: Any) {
        guard let url = URL(string: self.readMoreURL ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
}

extension MoreViewController: MoreViewModelDelegate{}
