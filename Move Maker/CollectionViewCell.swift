//
//  CollectionViewCell.swift
//  Move Maker
//
//  Created by Denise Goping on 2021-01-05.
//

import UIKit
import AVKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var videoLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    func configure(with videoName: String, _ imageName: UIImage){
            videoLabel.text = videoName
            backgroundImage.image = imageName
    }
}
