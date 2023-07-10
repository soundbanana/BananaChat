//
//  AuthCoordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import UIKit

final class AuthCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    func start() {
        let viewModel = LoginViewModel(authService: AuthService(), coordinator: self)
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
