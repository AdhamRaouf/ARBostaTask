//
//  AlbumService.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Foundation
import Moya

enum APIService {
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
}

extension APIService: TargetType {
    
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getAlbums:
            return "/albums"
        case .getPhotos:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        case .getAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .getPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}
