//
//  HomeCoordinator.swift
//  Login-MVVM-C
//
//  Created by Moacir Lamego on 18/05/21.
//

import UIKit

public class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController
    let loginViewModel: LoginViewModel
   
    init (navigationController: UINavigationController, loginViewModel: LoginViewModel) {
        self.navigationController = navigationController
        self.loginViewModel = loginViewModel
    }
    
    public func start() {
        goViewController()
    }
    
    private func goViewController() {
        let storyBoard = getStoryBoard(nameStoryboard: "Main")        
        
        guard let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
        
        viewController.initialize(loginViewModel: self.loginViewModel)

        self.navigationController.pushViewController(viewController, animated: true)
    }
}
