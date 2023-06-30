//
//  SceneDelegate.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let messageService = MessageServiceImpl()
        let chatViewModel = ChatViewModel(messageService: messageService)
        let chatViewController = ChatViewController(viewModel: chatViewModel)

        let navigationController = UINavigationController.init(rootViewController: chatViewController)
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

