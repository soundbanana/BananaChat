//
//  MessageService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import Foundation
import Combine


protocol MessageService {
    func getMessages() -> AnyPublisher<[Message], Error>
    func sendMessage(_ message: Message) -> AnyPublisher<Void, Error>
}

class MessageServiceImpl: MessageService {
    private var messagesSubject = PassthroughSubject<[Message], Error>()

    func getMessages() -> AnyPublisher<[Message], Error> {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let messages = [
                Message(sender: "User1", content: "Hello"),
                Message(sender: "User2", content: "Hi"),
                Message(sender: "User1", content: "How are you?")
            ]

            self.messagesSubject.send(messages)
            self.messagesSubject.send(completion: .finished)
        }
        return messagesSubject.eraseToAnyPublisher()
    }

    func sendMessage(_ message: Message) -> AnyPublisher<Void, Error> {
        let sendMessageSubject = PassthroughSubject<Void, Error>()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sendMessageSubject.send(())
            sendMessageSubject.send(completion: .finished)
        }

        return sendMessageSubject.eraseToAnyPublisher()
    }
}
