//
//  Coordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit
import Combine

class AppCoordinator {
    var window: UIWindow
    private var authCoordinator: AuthCoordinator?
    private var chatsCoordinator: ChatsCoordinator?

    private var cancellables = Set<AnyCancellable>()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let user = User(id: 1, username: "admin", firstName: "Admin", lastName: "Admin", avatar: nil)
        MockUser.user = user
        showChats(with: user)
        //        self.showAuth()
    }

    func showAuth() {
        let authCoordinator = AuthCoordinator(window: window)
        self.authCoordinator = authCoordinator

        authCoordinator.didFinish
            .sink { [weak self] user in
                self?.handleAuthCompletion(user: user)
            }
            .store(in: &cancellables)

        authCoordinator.start()
    }

    func handleAuthCompletion(user: User?) {
        authCoordinator = nil

        if let user = user {
            showChats(with: user)
        }
    }

    func showChats(with user: User) {
        let chatsCoordinator = ChatsCoordinator(window: window)
        self.chatsCoordinator = chatsCoordinator

        chatsCoordinator.start()
    }
}
