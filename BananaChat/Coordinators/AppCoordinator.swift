//
//  Coordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

class AppCoordinator {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        self.showChats()
    }

    func showChats() {
        let chatsCoordinator = ChatsCoordinator(window: window)
        chatsCoordinator.start()
    }
}
