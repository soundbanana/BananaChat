//
//  ChatsCoordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

final class ChatsCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = ChatsViewModel(chatService: ChatService(), coordinator: self)
        let viewController = ChatsViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showChat(_ chat: Chat) {
        let viewModel = ChatViewModel(messageService: MessageServiceImpl())
        let viewController = ChatViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showProfile() {
        let viewModel = ProfileViewModel(
            coordinator: self,
            personService: PersonService())
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController?.present(viewController, animated: true)
    }
}
