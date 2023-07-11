//
//  PersonService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 08.07.2023.
//

import Foundation
import Combine

class UserService {
    func fetchUser() -> Future<User, Never> {
        let user = MockUser.user

        return Future<User, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                promise(.success(user))
            }
        }
    }
}
