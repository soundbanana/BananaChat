//
//  MessageService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import Foundation
import Combine

protocol MessageService {
    func sendMessage(_ message: String)
    func fetchMessages() -> [Message]
    var messagesPublisher: AnyPublisher<[Message], Never> { get }
}

class MessageServiceImpl: MessageService {
    private var messages: [Message] = []
    private let messagesSubject = PassthroughSubject<[Message], Never>()

    var messagesPublisher: AnyPublisher<[Message], Never> {
        return messagesSubject.eraseToAnyPublisher()
    }

    func sendMessage(_ content: String) {
        let message = Message(sender: "User", content: content, isSentByUser: true)
        messages.reverse()
        messages.append(message)
        messages.reverse()
        messagesSubject.send(messages)
    }

    func fetchMessages() -> [Message] {
        return messages
    }
}
