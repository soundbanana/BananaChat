//
//  ChatViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import Combine

class ChatViewModel {
    private let messageService: MessageService
    private var cancellables = Set<AnyCancellable>()

    @Published var messages: [Message] = []

    init(messageService: MessageService, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.messageService = messageService
    }

    func loadMessages() {
        messageService.getMessages()
            .sink(receiveCompletion: { _ in
            // Handle any completion events if needed
        }, receiveValue: { [weak self] messages in
                self?.messages = messages
                // Notify the view that the data has been updated
            })
            .store(in: &cancellables)
    }

    func sendMessage(_ content: String) {
        let message = Message(sender: "User", content: content)
        messageService.sendMessage(message)
            .sink(receiveCompletion: { _ in
            // Handle any completion events if needed
        }, receiveValue: { _ in
                // Perform any additional actions after sending the message
            })
            .store(in: &cancellables)
    }
}
