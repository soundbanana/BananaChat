//
//  TabBarCoordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

final class TabBarCoordinator: UITabBarController {
    let chatsCoordinator = ChatsCoordinator(UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .systemGray
        self.tabBar.backgroundImage = UIImage()

        chatsCoordinator.start()

        viewControllers = [chatsCoordinator.navigationController]
    }
}
