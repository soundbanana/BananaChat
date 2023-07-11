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

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.systemBlue, for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private lazy var menu = UIMenu(children: elements)

    private lazy var selectMessages = UIAction(
        title: "Select Messages",
        image: UIImage(systemName: "checkmark.circle")) { [weak self] _ in
        self?.viewModel.toggleSelectionMode()
        self?.showCustomTabBarButtonTapped()  // TODO
    }

    private lazy var editNameAndPhoto = UIAction(
        title: "Edit Name and Photo",
        image: UIImage(systemName: "person.circle")) { [weak self] _ in
        self?.viewModel.openProfile()
    }

    private var customTabBar: UIView?

    private lazy var elements: [UIAction] = [selectMessages, editNameAndPhoto]

    init(viewModel: ChatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    @objc private func showCustomTabBarButtonTapped() {
        showCustomTabBar()
    }

    @objc private func hideCustomTabBarButtonTapped() {
        hideCustomTabBar()
    }

    private func setupBindings() {
        viewModel.chatsPublisher
            .sink { [weak self] chats in
            self?.updateTableView(with: chats)
        }
            .store(in: &cancellables)

        viewModel.$isSelectionModeEnabled
            .sink { [weak self] isEnabled in
            self?.setupNavigationItem(with: isEnabled)
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

    private func setupNavigationItem(with isSelectionMode: Bool) {
        if isSelectionMode {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
            hideCustomTabBar()
        } else {
            editButton.menu = menu
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: editButton)
            hideCustomTabBar()
        }
    }

    private func showCustomTabBar() {
        if customTabBar == nil {
            let tabBarHeight: CGFloat = 80

            let customTabBar = UIView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: tabBarHeight))
            customTabBar.backgroundColor = .systemGray
            customTabBar.autoresizingMask = [.flexibleTopMargin, .flexibleWidth] // Ensure the tab bar resizes properly

            UIView.animate(withDuration: 0.3) {
                self.view.addSubview(customTabBar)
                self.customTabBar = customTabBar

                customTabBar.frame.origin.y -= tabBarHeight
            }
        }
    }

    private func hideCustomTabBar() {
        guard let customTabBar = customTabBar else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            customTabBar.frame.origin.y += customTabBar.bounds.height
        }, completion: { _ in
            customTabBar.removeFromSuperview()
            self.customTabBar = nil
        })
    }

    @objc private func doneButtonTapped() {
        viewModel.toggleSelectionMode()
        hideCustomTabBar() // TODO
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
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectChat(indexPath.row)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unread = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] _, _, completionHandler in
            self?.handleMarkAsUnread()
            completionHandler(true)
        }

        unread.image = UIImage(systemName: "message.badge.fill")
        unread.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [unread])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let mute = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] _, _, completionHandler in
            self?.handleMarkAsMuted()
            completionHandler(true)
        }
        mute.image = UIImage(systemName: "bell.slash.fill")
        mute.backgroundColor = .systemIndigo

        let moveToTrash = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completionHandler in
            self?.handleMoveToTrash()
            completionHandler(true)
        }
        moveToTrash.image = UIImage(systemName: "trash.fill")
        moveToTrash.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [moveToTrash, mute])
    }

    private func handleMarkAsUnread() {
        print("Marked as unread")
    }

    private func handleMarkAsMuted() {
        print("Marked as muted")
    }

    private func handleMoveToTrash() {
        print("Moved to trash")
    }
}
