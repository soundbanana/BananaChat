//
//  ChatsViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import Foundation
import Combine

class ChatsViewModel {
    private let chatService: ChatService
    private let coordinator: ChatsCoordinator

    var chats: [Chat] = []

    private var chatsSubject = PassthroughSubject<[Chat], Never>()
    var chatsPublisher: AnyPublisher<[Chat], Never> {
        chatsSubject.eraseToAnyPublisher()
    }

    @Published var isSelectionModeEnabled = false
    
    private var cancellables = Set<AnyCancellable>()

    init(chatService: ChatService, coordinator: ChatsCoordinator) {
        self.chatService = chatService
        self.coordinator = coordinator

        fetchChats()
    }

    func fetchChats() {
        chatService.fetchChats()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure:
                print("failure")
            }
        }, receiveValue: { [weak self] value in
            self?.chats = value
            self?.chatsSubject.send(value) // Notify the ChatsViewController with the fetched chats
        })
        .store(in: &cancellables)
    }

    var numberOfChats: Int {
        return chats.count
    }

    func chat(at index: Int) -> Chat {
        return chats[index]
    }

    func didSelectChat(_ index: Int) {
        coordinator.showChat(chats[index])
    }

    func toggleSelectionMode() {
        isSelectionModeEnabled.toggle()
    }

    func openProfile() {
        coordinator.showProfile()
    }
}
