//
//  ChatViewControler.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import UIKit
import Combine

class ChatViewController: UIViewController {
    private var viewModel: ChatViewModel!
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
    }

    private func bindViewModel() {
        viewModel.$messages
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }
            .store(in: &cancellables)
    }

    @IBAction func sendMessageButtonTapped(_ sender: UIButton) {
        let messageText = "test"
        // Get the message text from the input field else { return }
        viewModel.sendMessage(messageText)
    }
}

