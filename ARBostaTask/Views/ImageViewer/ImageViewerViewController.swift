//
//  ImageViewerViewController.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import UIKit
import SDWebImage

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let imageUrl: String
    
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        loadImage()
    }
    
    
    private func setupUI() {

        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.10
        scrollView.maximumZoomScale = 10.0
        scrollView.contentSize = imageView.frame.size
        view.addSubview(scrollView)
        
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    
    private func loadImage() {
        guard let url = URL(string: imageUrl) else { return }
        
        imageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, completed: { [weak self] image, error, _, _ in
            guard let self = self else { return }
            
            if let image = image {
                let originalSize = image.size
                let scaleFactor: CGFloat = 0.35
                
                let newSize = CGSize(width: originalSize.width * scaleFactor, height: originalSize.height * scaleFactor)
                
                self.imageView.frame = CGRect(origin: .zero, size: newSize)
                self.scrollView.contentSize = newSize
                self.centerImageInScrollView()
            } else {
                print("Failed to load image: \(String(describing: error))")
            }
        })
        
    }
    
    
    private func centerImageInScrollView() {
        let offsetX = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
        let offsetY = (scrollView.bounds.height - scrollView.contentSize.height) * 0.25
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollView()
    }
    
    
    @objc private func shareImage() {
        let activityViewController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .postToFacebook, .postToTwitter]
        present(activityViewController, animated: true, completion: nil)
    }
}

