//
//  ChatsCoordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

final class ChatsCoordinator {
    func start() -> UIViewController {
        let viewModel = ChatsViewModel()
        let viewController = ChatsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
