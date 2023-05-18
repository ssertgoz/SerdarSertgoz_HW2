//
//  SectionCell.swift
//  NewsApp
//
//  Created by serdar on 17.05.2023.
//

import UIKit
import NewsAPI

class SectionCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(section: SectionAPIURL) {
        title.text = section.rawValue
    }
}
