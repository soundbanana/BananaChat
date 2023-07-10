//
//  ProfileViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 08.07.2023.
//

import Foundation
import Combine

class ProfileViewModel {
    private let userService: UserService
    private let coordinator: ChatsCoordinator

    var user: User?

    private var cancellables = Set<AnyCancellable>()

    private let personDataUpdatedSubject = PassthroughSubject<Void, Never>()
    var personDataUpdatedPublisher: AnyPublisher<Void, Never> {
        personDataUpdatedSubject.eraseToAnyPublisher()
    }

    init(coordinator: ChatsCoordinator, userService: UserService) {
        self.coordinator = coordinator
        self.userService = userService

        fetchPerson()
    }

    func fetchPerson() {
        userService.fetchUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
            self?.user = user
            self?.personDataUpdatedSubject.send()
            }
        .store(in: &cancellables)
    }
}
