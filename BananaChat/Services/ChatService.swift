//
//  ChatService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 04.07.2023.
//

import Foundation
import Combine

class ChatService {
    func fetchChats() -> Future<[Chat], Error> {
        let chat1 = Chat(id: "1", title: "John Doe", lastMessage: "Hello!", timestamp: randomDate())
        let chat2 = Chat(id: "2", title: "Alice Johnson", lastMessage: "How are you?", timestamp: randomDate())
        let chat3 = Chat(id: "3", title: "Bob Smith", lastMessage: "What's up?", timestamp: randomDate())
        let chat4 = Chat(id: "4", title: "Emily Brown", lastMessage: "Long time no see!", timestamp: randomDate())
        let chat5 = Chat(id: "5", title: "Michael Wilsonsdfsdsdfsdfsdff", lastMessage: "Do you have any plans for the weekend? Do you have any plans for the weekend? Do you have any plans for the weekend?", timestamp: randomDate())

        func randomDate() -> Date {
            let randomTimeInterval = TimeInterval.random(in: 0...1000000)
            let randomDate = Date().addingTimeInterval(randomTimeInterval)
            return randomDate
        }

        let chats = [chat1, chat2, chat3, chat4, chat5]

        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                promise(.success(chats))
            }
        }
    }
}