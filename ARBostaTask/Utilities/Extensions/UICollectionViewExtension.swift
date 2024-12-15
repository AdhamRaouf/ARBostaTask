//
//  UICollectionViewExtension.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Foundation
import UIKit




extension AlbumDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        let photo = filteredPhotos[indexPath.item]
        
        let imageView = UIImageView(frame: cell.contentView.bounds)
        
        imageView.contentMode = .scaleAspectFill
        
        if let url = URL(string: photo.url) {
            imageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, completed: nil)
        }
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        let imageViewerVC = ImageViewerViewController(imageUrl: photo.url)
        navigationController?.pushViewController(imageViewerVC, animated: true)
    }    
}
