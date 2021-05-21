//
//  LoginViewModel.swift
//  Login-MVVM-C
//
//  Created by Moacir Lamego on 21/05/21.
//

import Foundation

struct LoginViewModel {
    private let model : LoginModel
    
    
    var userName : String {
        self.model.userName ?? String.empty
    }
    
    var userLogin: String {
        self.model.userLogin ?? String.empty
    }
    
    var userPassword: String {
        self.model.userPassword ?? String.empty
    }
    
    init(withModel model: LoginModel) {
        self.model = model
    }
    
    static func fetchData(user:String, pwd:String, completion: @escaping (Result<LoginViewModel, Error>) -> Void) {
        let networkManager: HTTPManagerProtocol = HTTPManager()
        
        networkManager.get(url: URL(string: "NOURL")!, completionBlock: { result in
            do {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    let model = try JSONDecoder().decode(LoginModel.self, from: data)
                    let viewModel = LoginViewModel(withModel: model)
                    completion(.success(viewModel))
                }
            } catch let error as NSError {
                completion(.failure(error))
            }
        })
    }
}
