//
//  PersonService.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 08.07.2023.
//

import Foundation
import Combine

class PersonService {
    func fetchPerson() -> Future<Person, Never> {
        let person = Person(id: 1, username: "johnDoe", firstName: "John", lastName: "Doe", avatar: "avatar1", isOnline: true)

        return Future<Person, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                promise(.success(person))
            }
        }
    }
}