//
//  LoginCoordinator.swift
//  Login-MVVM-C
//
//  Created by Moacir Lamego on 18/05/21.
//

import Foundation
import UIKit

public class LoginCoordinator: Coordinator {
    let navigationController: UINavigationController
   
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        goViewController()
    }
    
    private func goViewController() {
        let viewController = LoginViewController()

        viewController.onTryingToLogin = { user, pwd  in
            
            LoginViewModel.fetchData(user: user, pwd: pwd, completion: {data in
                switch data {
                case .failure: fatalError()
                case .success(let loginViewModel):
                    print("Nome do Usuario: \(loginViewModel.userName)")
                    
                    self.goToHome(loginViewModel: loginViewModel)
                }
            })
        }

        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func goToHome(loginViewModel: LoginViewModel) {
        let coordinator = HomeCoordinator(navigationController: self.navigationController, loginViewModel: loginViewModel)
        coordinator.start()
    }
}
