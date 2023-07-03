//
//  Coordinator.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    func start()
}
