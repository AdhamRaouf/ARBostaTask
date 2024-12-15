//
//  ProfileViewController.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    
    public let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupConstraints()
        bindViewModel()
        viewModel.fetchRandomUserAndAlbums()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    private func bindViewModel() {
        viewModel.$user
            .sink { [weak self] user in
                guard let user = user else { return }
                self?.nameLabel.text = user.name
                self?.addressLabel.text = user.address.fullAddress
            }
            .store(in: &cancellables)
        
        viewModel.$albums
        
        
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
                
            }
            .store(in: &cancellables)
    }
    
    
    private func setupNavigationBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    
    
    private func setupConstraints() {
        view.addSubview(nameLabel)
        view.addSubview(addressLabel)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

