//
//  ChatViewControler.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import UIKit
import Combine
import MessageUI

class ChatViewController: UIViewController {
    private var viewModel: ChatViewModel!
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(SentMessageBubbleCell.self, forCellReuseIdentifier: "SentMessageBubbleCell")
        tableView.register(RecievedMessageBubbleCell.self, forCellReuseIdentifier: "RecievedMessageBubbleCell")
        return tableView
    }()

    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter message"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        return textField
    }()

    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()

    private let messageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()

    init(viewModel: ChatViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        addChatContainerView()
        setupTableView()
        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
    }

    private func addChatContainerView() {
        let chatContainerView = UIView()
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatContainerView)

        NSLayoutConstraint.activate([
            chatContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        addTextFieldAndSendButton(to: chatContainerView)
        addTableView(to: chatContainerView)
    }

    private func setupTableView() {
        let padding = 16.0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -padding),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageStackView.topAnchor, constant: -padding)
        ])
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    private func addTableView(to container: UIView) {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addTextFieldAndSendButton(to container: UIView) {
        messageStackView.addArrangedSubview(messageTextField)
        messageStackView.addArrangedSubview(sendMessageButton)

        view.addSubview(messageStackView)

        let padding = 16.0

        NSLayoutConstraint.activate([
            messageStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            messageStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            messageStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            messageTextField.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor),
            messageTextField.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor),

            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func bindViewModel() {
        viewModel.$messages
            .sink { [weak self] _ in
            self?.updateMessages()
            }
        .store(in: &cancellables)
    }

    private func updateMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.reloadData()
        }
    }

    @objc private func sendMessageButtonTapped() {
        guard let messageText = messageTextField.text else { return }
        viewModel.sendMessage(messageText)
        messageTextField.text = ""
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        if message.content == "123" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecievedMessageBubbleCell", for: indexPath) as? RecievedMessageBubbleCell else {
                return UITableViewCell()
            }
            cell.configure(with: message.content)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageBubbleCell", for: indexPath) as? SentMessageBubbleCell else {
                return UITableViewCell()
            }
            cell.configure(with: message.content)
            return cell
        }
    }
}
