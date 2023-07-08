//
//  ChatsViewController.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit
import Combine

class ChatsViewController: UIViewController {
    private var viewModel: ChatsViewModel
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        return tableView
    }()

    init(viewModel: ChatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.chatsPublisher
            .sink { [weak self] chats in
                self?.updateTableView(with: chats)
            }
        .store(in: &cancellables)
    }

    private func updateTableView(with chats: [Chat]) {
        tableView.reloadData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfChats
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        cell.configure(for: viewModel.chats[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectChat(indexPath.row)
    }
}
