//
//  ProfileViewModel.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Combine

class ProfileViewModel {
 
    @Published var user: User?
    @Published var albums: [Album] = []
    @Published var errorMessage: String?
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func fetchRandomUserAndAlbums() {
        NetworkManager.shared.fetchRandomUser()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.fetchAlbums(for: user.id)
            }
            .store(in: &cancellables)
    }
    
    
    private func fetchAlbums(for userId: Int) {
        NetworkManager.shared.fetchAlbums(userId: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] albums in
                self?.albums = albums
            }
            .store(in: &cancellables)
    }
}
