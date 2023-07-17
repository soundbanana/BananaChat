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
        let chat1 = Chat(id: "1", title: "John Doe", lastMessage: "Hello!", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat2 = Chat(id: "2", title: "Alice Johnson", lastMessage: "How are you?", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat3 = Chat(id: "3", title: "Bob Smith", lastMessage: "What's up?", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat4 = Chat(id: "4", title: "Emily Brown", lastMessage: "Long time no see!", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat5 = Chat(id: "5", title: "Michael Wilsons", lastMessage: "Do you have any plans for the weekend?", timestamp: Date(), unreadMessagesCount: 10)
        let chat6 = Chat(id: "6", title: "Sarah Thompson", lastMessage: "I'm looking forward to the event!", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat7 = Chat(id: "7", title: "David Lee", lastMessage: "Let's grab lunch next week.", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat8 = Chat(id: "8", title: "Olivia Davis", lastMessage: "Have you seen the latest movie?", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat9 = Chat(id: "9", title: "James Anderson", lastMessage: "Can you help me with the project?", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat10 = Chat(id: "10", title: "Sophia Martinez", lastMessage: "Happy birthday! 🎉", timestamp: randomDate(), unreadMessagesCount: 10)
        let chat11 = Chat(id: "11", title: "Daniel Wilson", lastMessage: "What time is the meeting?", timestamp: randomDate(), unreadMessagesCount: 10)

        let chats = [chat1, chat2, chat3, chat4, chat5, chat6, chat7, chat8, chat9, chat10, chat11].sorted {
            $0.timestamp < $1.timestamp
        }

        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                promise(.success(chats))
            }
        }
    }

    func randomDate() -> Date {
        let randomTimeInterval = TimeInterval.random(in: 0...1000000)
        let randomDate = Date().addingTimeInterval(randomTimeInterval)
        return randomDate
    }

    func convertToTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    }
}
