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
    let genre: String
}

struct Move {
    let moveProperties: MoveProperties
    var image: UIImage
}

class CollectionViewController: UICollectionViewController {
    
    let serverLink: String = "ngrok URL here"
    var moveList: [Move] = []
    
    // Gets image from URL, returns as a class of type Data
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Adds image to the Move in moveList
    func downloadImage(from url: URL, moveIndex: Int) {
        getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.moveList[moveIndex].image = UIImage(data: data)!
                self?.collectionView.reloadData()
            }
        }
    }
    
    // Gets moveProperties from server and adds them to moveList
    // For each move received, gets associated image
    func getMoves(_ link: String) {
        moveList.removeAll()
        if let url = URL(string: link) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let movePropertiesList = try JSONDecoder().decode([MoveProperties].self, from: data)
                    for (index, moveProperties) in movePropertiesList.enumerated() {
                        let move = Move(moveProperties: moveProperties, image: #imageLiteral(resourceName: "White-Square"))
                        self.moveList.append(move)
                        let url = URL(string: move.moveProperties.thumbnail)!
                        self.downloadImage(from: url, moveIndex: index)
                    }
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
 
    @IBAction func allGenres(_ sender: Any) {
        getMoves(serverLink)
    }
    
    @IBAction func jazzGenre(_ sender: Any) {
        getMoves(serverLink + "/Jazz")
    }
    
    @IBAction func contemporaryGenre(_ sender: Any) {
        getMoves(serverLink + "/Contemporary")
    }
    
    @IBAction func acroGenre(_ sender: Any) {
        getMoves(serverLink + "/Acro")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoves(serverLink)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moveList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let vidcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            vidcell.configure(with: moveList[indexPath.item].moveProperties.name, moveList[indexPath.item].image)
            cell = vidcell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: moveList[indexPath.item].moveProperties.video)!

        let video = AVPlayer(url: url)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = video

        present(videoPlayer, animated: true) {
            video.play()
        }
    }
}
