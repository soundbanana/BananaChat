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

    @Published private(set) var messages: [Message] = []

    init(messageService: MessageService) {
        self.messageService = messageService

        messages = messageService.fetchMessages()

        messageService.messagesPublisher
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
    }

//    func loadMessages() {
//        messageService.getMessages()
//            .sink(receiveCompletion: { _ in
//            // Handle any completion events if needed
//        }, receiveValue: { [weak self] messages in
//                self?.messages = messages
//                // Notify the view that the data has been updated
//            })
//            .store(in: &cancellables)
//    }

    func sendMessage(_ content: String) {
        if !content.isEmpty {
            messageService.sendMessage(content)
        }
    }
}
