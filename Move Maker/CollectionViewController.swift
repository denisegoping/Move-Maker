//
//  CollectionViewController.swift
//  Move Maker
//
//  Created by Denise Goping on 2021-01-05.
//

import UIKit
import AVKit

struct MoveProperties: Codable {
    let _id: String
    let name: String
    let thumbnail: String
    let video: String
}

struct Move {
    let moveProperties: MoveProperties
    var image: UIImage
}

class CollectionViewController: UICollectionViewController {
    
    let imageList: [UIImage] = [#imageLiteral(resourceName: "sideTiltPic"), #imageLiteral(resourceName: "penchéKickPic"), #imageLiteral(resourceName: "slantJumpPic"), #imageLiteral(resourceName: "pirouettePic"), #imageLiteral(resourceName: "illusionPic"), #imageLiteral(resourceName: "handstandPic")]
    let videoList: [String] =  ["sideTiltVid", "penchéKickVid", "slantJumpVid", "pirouetteVid", "illusionVid", "handstandVid"]
    let labelList: [String] = ["Side Tilt", "Penché Kick", "Slant Jump", "Pirouette", "Illusion", "Handstand"]
       
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let vidcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            vidcell.configure(with: labelList[indexPath.item], imageList[indexPath.item])
            cell = vidcell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let path = Bundle.main.path(forResource: videoList[indexPath.item], ofType: "mov") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video

            present(videoPlayer, animated: true) {
                video.play()
            }
        }
    }
}
