//
//  LoginService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import Foundation
import Combine

enum AuthError: Error {
    case invalidCredentials
}

class AuthService {
    func login(username: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0) {
                if username == "admin" && password == "admin" {
                    let user = User(id: 1, username: "admin", firstName: "Admin", lastName: "Admin", avatar: nil)
                    MockUser.user = user  // TODO Make an appropriate way to store user credentials
                    promise(.success(()))
                } else {
                    promise(.failure(.invalidCredentials))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
