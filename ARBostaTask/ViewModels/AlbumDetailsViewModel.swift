//
//  AlbumDetailsViewModel.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Combine

class AlbumDetailsViewModel {
   
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func fetchPhotos(for albumId: Int) {
        NetworkManager.shared.fetchPhotos(albumId: albumId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
    }
}
