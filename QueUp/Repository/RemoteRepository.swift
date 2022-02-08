//
//  RemoteRepository.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/21.
//

import Foundation

protocol RemoteRepository {
    associatedtype Object
    associatedtype Query
    
    // read
    func get(id: String, completion: @escaping (Result<Object, RepositoryError>) -> Void)
    func list(_ query: Query?, completion: @escaping (Result<[Object], RepositoryError>) -> Void)
    
    // write
    func create(_ object: Object, completion: @escaping (RepositoryError?) -> Void)
    func update(_ object: Object, completion: @escaping (RepositoryError?) -> Void)
    func delete(_ object: Object, completion: @escaping (RepositoryError?) -> Void)
}
