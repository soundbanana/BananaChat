//
//  ChatsViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import Foundation
import Combine
import UIKit

class ChatsViewModel {
    private let chatService: ChatService
    private let coordinator: ChatsCoordinator

//    var chats: [Chat] = []

    var dataSource: UITableViewDiffableDataSource<Section, Chat>!

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

    func configureDataSource(for tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, chat in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
                return UITableViewCell()
            }
            cell.configure(for: chat)
            return cell
        }
    }

    private func updateTableView(with chats: [Chat]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Chat>()
        snapshot.appendSections([.chat])
        snapshot.appendItems(chats, toSection: .chat)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func fetchChats() {
        chatService.$chats
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                self?.updateTableView(with: chats)
            }
            .store(in: &cancellables)

        chatService.fetchChats()
    }

    var numberOfChats: Int {
        dataSource.snapshot().itemIdentifiers(inSection: .chat).count
    }

    func chat(at index: Int) -> Chat {
        dataSource.snapshot().itemIdentifiers(inSection: .chat)[index]
    }

    func didSelectChat(_ index: Int) {
        coordinator.showChat(chat(at: index))
    }

    func toggleSelectionMode() {
        isSelectionModeEnabled.toggle()
    }

    func openProfile() {
        coordinator.showProfile()
    }

    func markAsUnread(id: String) {
        chatService.markChatAsUnread(id: id)
        fetchChats()
    }

    func markAsRead(id: String) {
        chatService.markChatAsRead(id: id)
        fetchChats()
    }

    func markAsMuted(id: String) {
        chatService.markChatAsMuted(id: id)
        fetchChats()
    }

    func markAsUnmuted(id: String) {
        chatService.markChatAsUnmuted(id: id)
        fetchChats()
    }
}
