//
//  SectionCell.swift
//  NewsApp
//
//  Created by serdar on 17.05.2023.
//

import UIKit

class SectionCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    func configure(sectionName: String) {
        title.text = sectionName
    }
}
