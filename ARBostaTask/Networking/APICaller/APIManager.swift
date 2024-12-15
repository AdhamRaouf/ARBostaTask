//
//  APIManager.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Moya
import Combine
import CombineMoya

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<APIService>()
    
    private init() {}
    
    
    func fetchRandomUser() -> AnyPublisher<User, Error> {
        return provider.requestPublisher(.getUsers)
            .map([User].self)
            .mapError { $0 as Error }
            .compactMap { $0.randomElement() }
            .eraseToAnyPublisher()
    }
    
    
    
    
    func fetchAlbums(userId: Int) -> AnyPublisher<[Album], Error> {
        return provider.requestPublisher(.getAlbums(userId: userId))
            .map([Album].self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    
    
    
    func fetchPhotos(albumId: Int) -> AnyPublisher<[Photo], Error> {
        return provider.requestPublisher(.getPhotos(albumId: albumId))
            .map([Photo].self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
