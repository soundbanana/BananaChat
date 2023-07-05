//
//  Chat.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 04.07.2023.
//

import Foundation

struct Chat {
    let id: String
    let title: String
    var lastMessage: String
    var unreadCount: Int = 0
    var isMuted = false
    var timestamp: Date

    init(id: String, title: String, lastMessage: String, timestamp: Date) {
        self.id = id
        self.title = title
        self.lastMessage = lastMessage
        self.timestamp = timestamp
    }
}
