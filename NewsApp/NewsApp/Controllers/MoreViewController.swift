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
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        fadeBlackImageView.layer.cornerRadius = 10
        fadeBlackImageView.layer.masksToBounds = true
            
        //configure labels
        descriiptionLabel.text = desc
        dateLatel.text = date
        writerNameLabel.text = writerName
        titleLabel.text = titleString
        
        //configure button
        readMoreButton.layer.cornerRadius = 10
        readMoreButton.layer.masksToBounds = false
        
        
        
        readMoreButton.layer.shadowColor = UIColor.black.cgColor
        readMoreButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        readMoreButton.layer.shadowOpacity = 0.2
        readMoreButton.layer.shadowRadius = 6
        
        
    }

    @IBAction func onClickedRedMoreButton(_ sender: Any) {
        guard let url = URL(string: self.readMoreURL ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
}
