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
    func login(username: String, password: String) -> AnyPublisher<User, AuthError> {
        return Future<User, AuthError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                if username == "admin" && password == "admin" {
                    let user = User(id: 1, username: "@admin", firstName: "Admin", lastName: "Admin", avatar: nil)
                    promise(.success(user))
                } else {
                    promise(.failure(.invalidCredentials))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
