//
//  ViewController.swift
//  Login-MVVM-C
//
//  Created by Moacir Lamego on 18/05/21.
//

import UIKit

class ViewController: UIViewController {
    lazy var nomeUsuarioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .labelColor
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func initialize(loginViewModel: LoginViewModel) {
        nomeUsuarioLabel.text = loginViewModel.userName
        
        self.view.addSubview(nomeUsuarioLabel)
        
        NSLayoutConstraint.activate([
            nomeUsuarioLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nomeUsuarioLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            nomeUsuarioLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
    }
}

