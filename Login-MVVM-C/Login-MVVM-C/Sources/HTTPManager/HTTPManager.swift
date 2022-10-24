//
//  HTTPManager.swift
//  Login-MVVM-C
//
//  Created by Moacir Lamego on 21/05/21.
//

import Foundation

protocol HTTPManagerProtocol {
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
}

class HTTPManager: HTTPManagerProtocol {
    public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let data = Data("{\"userName\": \"Moacir Lamego\",\"userLogin\": \"Moa\"}".utf8)
            completionBlock(.success(data))
        }
    }
}
