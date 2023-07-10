//
//  LoginViewController.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}
