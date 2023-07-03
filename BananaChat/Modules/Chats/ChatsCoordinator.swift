//
//  ChatsCoordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

final class ChatsCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ChatsViewModel()
        let viewController = ChatsViewController(viewModel: viewModel)
        viewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 0)
        navigationController.viewControllers = [viewController]
    }
}
