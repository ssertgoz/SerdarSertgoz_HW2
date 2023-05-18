//
//  NewsCell.swift
//  NewsApp
//
//  Created by serdar on 17.05.2023.
//

import UIKit
import NewsAPI
import SDWebImage

class NewsCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(news: News) {
        preparePosterImage(with: news.multimedia?[1].url ?? "")
        title.text = news.title
        des.text = news.abstract
    }
    
    private func preparePosterImage(with urlString: String?) {
        let fullPath = urlString ?? ""
        
        if let url = URL(string: fullPath) {
            image.sd_setImage(with: url)
        }
    }

}
