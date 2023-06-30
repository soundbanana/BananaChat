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

    init(viewModel: ChatViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter message"
        return textField
    }()

    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        addChatContainerView()
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

    private func addTableView(to container: UIView) {
        view.addSubview(tableView)

        let padding = 16.0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -padding),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: padding),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
            ])
        tableView.transform = tableView.transform.rotated(by: .pi)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false


        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "ChatBubbleCell")

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addTextFieldAndSendButton(to container: UIView) {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0

        stackView.addArrangedSubview(messageTextField)
        stackView.addArrangedSubview(sendMessageButton)

        view.addSubview(stackView)

        let padding = 16.0

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            messageTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            messageTextField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 80)
            ])

        messageTextField.backgroundColor = .white
        messageTextField.layer.cornerRadius = 20

        sendMessageButton.backgroundColor = .systemBlue
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 20
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleCell.reuseIdentifier, for: indexPath) as! ChatBubbleCell
        let message = viewModel.messages[indexPath.row]
        cell.configure(with: message.content, isSentByUser: message.isSentByUser)
        return cell
    }
}
