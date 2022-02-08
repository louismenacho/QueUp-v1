//
//  FirestoreRepository.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreRepository<Object: FirestoreDocument>: RemoteRepository {
    
    var collectionReference: CollectionReference
    var collectionListener: ListenerRegistration?
    
    init(collectionPath: String) {
        collectionReference = Firestore.firestore().collection(collectionPath)
    }
    
    func get(id: String, completion: @escaping (Result<Object, RepositoryError>) -> Void) {
        collectionReference.document(id).getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(.readError(error)))
                return
            }
                        
            do {
                if let data = try documentSnapshot?.data(as: Object.self) {
                    completion(.success(data))
                } else {
                    completion(.failure(.notFound(objectType: Object.self)))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }
    
    func list(_ query: Query? = nil, completion: @escaping (Result<[Object], RepositoryError>) -> Void) {
        (query ?? collectionReference).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(.readError(error)))
                return
            }
            
            guard let query = querySnapshot else {
                completion(.success([]))
                return
            }
            
            do {
                let dataList = try query.documents.compactMap { try $0.data(as: Object.self) }
                completion(.success(dataList))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }
    
    func create(_ object: Object, completion: @escaping (RepositoryError?) -> Void) {
        do {
            if let id = object.documentID {
                try collectionReference.document(id).setData(from: object) { error in
                    if let error = error {
                        completion(.writeError(error))
                        return
                    }
                    completion(nil)
                }
            } else {
                _ = try collectionReference.addDocument(from: object) { error in
                    if let error = error {
                        completion(.writeError(error))
                        return
                    }
                    completion(nil)
                }
            }
        } catch {
            completion(.encodingError(error))
        }
    }
    
    func update(_ object: Object, completion: @escaping (RepositoryError?) -> Void) {
        guard let id = object.documentID else {
            print("FirestoreDocument has no documentID")
            return
        }
        do {
            try collectionReference.document(id).setData(from: object) { error in
                if let error = error {
                    completion(.writeError(error))
                    return
                }
                completion(nil)
            }
        } catch {
            completion(.encodingError(error))
        }
    }
    
    func delete(_ object: Object, completion: @escaping (RepositoryError?) -> Void) {
        guard let id = object.documentID else {
            print("FirestoreDocument has no documentID")
            return
        }
        collectionReference.document(id).delete() { error in
            if let error = error {
                completion(.writeError(error))
                return
            }
            completion(nil)
        }
    }
    
    func addListener(id: String, completion: @escaping (Result<Object, RepositoryError>) -> Void) {
        collectionListener = collectionReference.document(id).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(.readError(error)))
                return
            }
            
            do {
                if let data = try documentSnapshot?.data(as: Object.self) {
                    completion(.success(data))
                } else {
                    completion(.failure(.notFound(objectType: Object.self)))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }

    func addListener(_ query: Query? = nil, completion: @escaping (Result<[Object], RepositoryError>) -> Void) {
        collectionListener = (query ?? collectionReference).addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(.readError(error)))
                return
            }
            
            guard let query = querySnapshot else {
                completion(.success([]))
                return
            }
            
            do {
                let dataList = try query.documents.compactMap { try $0.data(as: Object.self) }
                completion(.success(dataList))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }
    
    func removeListener() {
        collectionListener?.remove()
    }
}
