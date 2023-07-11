//
//  LoginViewModel.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import Foundation
import Combine

class LoginViewModel {
    private let authService: AuthService
    private let coordinator: AuthCoordinator
    private var cancellables = Set<AnyCancellable>()

    var username: String = ""
    var password: String = ""

    private let loginSuccessSubject = PassthroughSubject<Bool, Never>()

    var loginSuccessPublisher: AnyPublisher<Bool, Never> {
        loginSuccessSubject.eraseToAnyPublisher()
    }

    init(authService: AuthService, coordinator: AuthCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func login() {
        authService.login(username: username, password: password)
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
                self?.loginSuccessSubject.send(false)
            }
        }, receiveValue: { [weak self] _ in
            self?.loginSuccessSubject.send(true)
            })
        .store(in: &cancellables)
    }

    func loginSuccess() {
        coordinator.finishAuth()
    }
}
