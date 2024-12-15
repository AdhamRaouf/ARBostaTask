//
//  AlbumDetailsViewController.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import UIKit
import SDWebImage
import Combine


class AlbumDetailsViewController: UIViewController, UISearchBarDelegate {
    
    
    public let viewModel = AlbumDetailsViewModel()
    private let collectionView: UICollectionView
    private var cancellables = Set<AnyCancellable>()
    private let albumId: Int
    private let titlehead: String
    private let searchBar = UISearchBar()
    
    
    public var filteredPhotos: [Photo] = []
    
    
    init(albumId: Int, albumtitle: String) {
        self.albumId = albumId
        self.titlehead = albumtitle
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titlehead
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        viewModel.fetchPhotos(for: albumId)
    }
    
    
    
    private func setupUI() {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        navigationController?.navigationBar.addSubview(separator)
        
        
        searchBar.placeholder = "Search in images.."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor),
            separator.leftAnchor.constraint(equalTo: navigationController!.navigationBar.leftAnchor),
            separator.rightAnchor.constraint(equalTo: navigationController!.navigationBar.rightAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.filteredPhotos = photos
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { errorMessage in
                if let error = errorMessage {
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPhotos(by: searchText)
        
    }
    
    
    private func filterPhotos(by searchText: String) {
        
        if searchText.isEmpty {
            filteredPhotos = viewModel.photos
        } else {
            filteredPhotos = viewModel.photos.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        })
    }
}
