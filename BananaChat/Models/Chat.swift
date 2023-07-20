//
//  Chat.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 04.07.2023.
//

import Foundation

enum Section {
    case chat
}

struct Chat: Hashable {
    let id: String
    let title: String
    var lastMessage: String
    var unreadMessagesCount: Int
    var isMuted = false
    var timestamp: Date

    init(id: String, title: String, lastMessage: String, timestamp: Date, unreadMessagesCount: Int) {
        self.id = id
        self.title = title
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.unreadMessagesCount = unreadMessagesCount
    }
}
