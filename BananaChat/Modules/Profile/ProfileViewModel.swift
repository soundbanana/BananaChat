//
//  ProfileViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 08.07.2023.
//

import Foundation
import Combine

class ProfileViewModel {
    private let personService: PersonService
    private let coordinator: ChatsCoordinator

    var person: Person?

    private var cancellables = Set<AnyCancellable>()

    private let personDataUpdatedSubject = PassthroughSubject<Void, Never>()
    var personDataUpdatedPublisher: AnyPublisher<Void, Never> {
        personDataUpdatedSubject.eraseToAnyPublisher()
    }

    init(coordinator: ChatsCoordinator, personService: PersonService) {
        self.coordinator = coordinator
        self.personService = personService

        fetchPerson()
    }

    func fetchPerson() {
        personService.fetchPerson()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] person in
            self?.person = person
            self?.personDataUpdatedSubject.send()
            }
        .store(in: &cancellables)
    }
}
