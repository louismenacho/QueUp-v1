//
//  HomeViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/23/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: NSObject {
    
    var currentMember: Member?
    var currentRoom: Room?
    
    var spotifySessionManager: SPTSessionManager?
    var spotifyInitiateSessionCompletion: ((Result<Void, Error>) -> Void)?
    var spotifyConfig: SPTConfiguration?
    var spotifyScope: SPTScope = [
        .appRemoteControl,
        .userReadCurrentlyPlaying,
        .userReadRecentlyPlayed,
        .userReadPlaybackState,
        .userModifyPlaybackState,
        .userReadPrivate
    ]
    
    var subscriptions = Set<AnyCancellable>()
    var spotifyInitiateSessionSubject = PassthroughSubject<SPTSession, Error>()
    
    func createRoom(hostName: String, onCompletion: @escaping (Error?) -> Void) {
        var newRoom = Room()
        var newMember = Member(displayName: hostName, isHost: true)
        
        authenticate()
        .flatMap { user -> Future<SPTConfiguration, Error> in
            newMember.documentID = user.uid
            newMember.id = user.uid
            newRoom.host = newMember
            return self.getSpotifyConfiguration()
        }
        .flatMap { config -> Future<SPTSession, Error> in
            self.spotifyConfig = config
            return self.initiateSpotifySession(config: config)
        }
        .flatMap { session -> Future<String, Error> in
            newRoom.spotifyToken = session.accessToken
            newRoom.spotifyTokenExpirationDate = session.expirationDate
            return self.getSpotifyUserSubscription(session: session)
        }
        .flatMap { subscription -> Future<String, Error> in
            if subscription != "premium" {
                return Future<String, Error> { $0(.failure(AppError.spotifySubscriptionError)) }
            } else {
                return self.generateRoomCode()
            }
        }
        .flatMap { newRoomCode -> Future<Void, Error> in
            newRoom.documentID = newRoomCode
            newRoom.id = newRoomCode
            return self.createRoom(newRoom)
        }
        .sink { completion in
            if case let .failure(error) = completion {
                onCompletion(error)
            }
        } receiveValue: {
            self.currentRoom = newRoom
            self.currentMember = newRoom.host
            UserDefaultsRepository().roomID = newRoom.id
            UserDefaultsRepository().displayName = newRoom.host.displayName
            onCompletion(nil)
        }
        .store(in: &subscriptions)
    }
    
    func joinRoom(room id: String, memberName: String, onCompletion: @escaping (Error?) -> Void) {
        var currentRoom = Room()
        var currentMember = Member(displayName: memberName)
        
        authenticate()
        .flatMap { user -> Future<Room, Error> in
            print("findRoom")
            currentMember.documentID = user.uid
            currentMember.id = user.uid
            return self.findRoom(id: id)
        }
        .flatMap { room -> Future<Member?, Error> in
            print("findExistingMember")
            currentRoom = room
            return self.findExistingMember(id: currentMember.id, in: currentRoom)
        }
        .flatMap { member -> Future<Void, Error> in
            print("addMember")
            if let existingMember = member {
                currentMember = existingMember
                return Future<Void, Error> { $0(.success(())) }
            } else {
                currentRoom.memberCount += 1
                return self.addMember(member: currentMember, to: currentRoom)
            }
        }
        .sink { completion in
            if case let .failure(error) = completion {
                onCompletion(error)
            }
        } receiveValue: {
            
            var publisher: AnyPublisher<Void, Error>?
            
            if !currentMember.isHost {
                publisher = self.updateRoom(room: currentRoom)
                .eraseToAnyPublisher()
            } else {
                publisher = self.getSpotifyConfiguration()
                .flatMap { config in
                    self.initiateSpotifySession(config: config)
                }
                .flatMap { session -> Future<String, Error> in
                    currentRoom.spotifyToken = session.accessToken
                    currentRoom.spotifyTokenExpirationDate = session.expirationDate
                    return self.getSpotifyUserSubscription(session: session)
                }
                .flatMap { subscription -> Future<Void, Error> in
                    if subscription != "premium" {
                        return Future<Void, Error> { $0(.failure(AppError.spotifySubscriptionError)) }
                    } else {
                        return self.updateRoom(room: currentRoom)
                    }
                }
                .eraseToAnyPublisher()
            }
            
            publisher?
            .sink { completion in
                if case let .failure(error) = completion {
                    onCompletion(error)
                }
            } receiveValue: {
                self.currentRoom = currentRoom
                self.currentMember = currentMember
                UserDefaultsRepository().roomID = currentRoom.id
                UserDefaultsRepository().displayName = currentMember.displayName
                onCompletion(nil)
            }
            .store(in: &self.subscriptions)
            
        }
        .store(in: &self.subscriptions)
    }
    
    private func authenticate() -> Future<User, Error> {
        Future { promise in
            Auth.auth().signInAnonymously { authData, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(authData!.user))
                }
            }
        }
    }
    
    private func getSpotifyConfiguration() -> Future<SPTConfiguration, Error> {
        Future { promise in
            FirestoreRepository<SpotifyConfiguration>(collectionPath: "spotify").get(id: "configuration") { result in
                promise( result.flatMap { configuration in
                    let config = SPTConfiguration(clientID: configuration.clientID, redirectURL: URL(string: configuration.redirectURL)!)
                    config.tokenSwapURL = URL(string: configuration.tokenSwapURL)
                    config.tokenRefreshURL = URL(string: configuration.tokenRefreshURL)
                    return .success(config)
                }.flatMapError { error in
                    return .failure(AppError.error(error.localizedDescription))
                })
            }
        }
    }
    
    private func initiateSpotifySession(config: SPTConfiguration) -> Future<SPTSession, Error> {
        Future { [self] promise in
            let sessionManager = SPTSessionManager(configuration: config, delegate: self)
            self.spotifySessionManager = sessionManager
            guard sessionManager.isSpotifyAppInstalled else {
                promise(.failure(AppError.spotifyAppNotFoundError))
                return
            }
            DispatchQueue.main.async {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.spotifyConfiguration = config
                sceneDelegate?.spotifySessionManager = sessionManager
                sessionManager.initiateSession(with: self.spotifyScope, options: .clientOnly)
            }
            
            spotifyInitiateSessionSubject
            .timeout(15, scheduler: DispatchQueue.main, options: nil) {
                AppError.error("Could not initiate Spotify session")
            }
            .sink { completion in
                if sessionManager.session != nil {
                    return
                }
                if case let .failure(error) = completion {
                    promise(.failure(error))
                }
            } receiveValue: { session in
                promise(.success(session))
            }
            .store(in: &subscriptions)
        }
    }
    
    private func getSpotifyUserSubscription(session: SPTSession) -> Future<String, Error> {
        Future { promise in
            let spotifyUserProfileAPI = SpotifyAPIClient<SpotifyUserProfileAPI>(auth: .bearer(token: session.accessToken))
            spotifyUserProfileAPI.request(.currentUserProfile) { (result: Result<UserProfileResponse, ClientError>) in
                promise( result.flatMap { userProfile in
                    return .success((userProfile.product))
                }.flatMapError { error in
                    return .failure(AppError.error(error.localizedDescription))
                })
            }
        }
    }
    
    private func generateRoomCode() -> Future<String, Error> {
        Future { promise in
            self.generateNewRoomCode { result in
                promise(result)
            }
        }
    }
    
    private func createRoom(_ room: Room) -> Future<Void, Error> {
        Future { promise in
            let group = DispatchGroup()

            group.enter()
            FirestoreRepository<Room>(collectionPath: "rooms").create(room) { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                group.leave()
            }
            
            group.enter()
            FirestoreRepository<Member>(collectionPath: "rooms/"+room.id+"/members").create(room.host) { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                group.leave()
            }
            
            group.notify(queue: .global()) {
                promise(.success(()))
            }
        }
    }
    
    private func generateNewRoomCode(completion: @escaping (Result<String, Error>) -> Void) {
        let newCode = self.generateRandomCode(length: 4)
        FirestoreRepository<Room>(collectionPath: "rooms").get(id: newCode) { result in
            switch result {
            case .failure(let error):
                if case .notFound = error {
                    print("\(newCode) does not exist. Using for new room")
                    completion(.success(newCode))
                } else {
                    completion(.failure(error))
                }
            case .success:
                print("Room\(newCode) already exists. Regenerating room code")
                self.generateNewRoomCode(completion: completion)
            }
        }
    }
    
    private func generateRandomCode(length: Int) -> String {
        let alphabeticRange = 65...90
        var code = ""
        while code.count < length {
            let unicodeScalar = Int.random(in: alphabeticRange)
            let letter = Character(UnicodeScalar(unicodeScalar)!)
            code = "\(code)\(letter)"
        }
        return code
    }
    
    private func findRoom(id: String) -> Future<Room, Error> {
        Future { promise in
            FirestoreRepository<Room>(collectionPath: "rooms").get(id: id) { result in
                switch result {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let room):
                    promise(.success(room))
                }
            }
        }
    }
    
    private func findExistingMember(id: String, in room: Room) -> Future<Member?, Error> {
        Future { promise in
            FirestoreRepository<Member>(collectionPath: "rooms/"+room.id+"/members").get(id: id) { result in
                switch result {
                case .failure(let error):
                    if case .notFound = error {
                        promise(.success(nil))
                    } else {
                        promise(.failure(error))
                    }
                case .success(let member):
                    promise(.success(member))
                }
            }
        }
    }
    
    private func addMember(member: Member, to room: Room) -> Future<Void, Error> {
        Future { promise in
            if room.memberCount >= 8 {
                promise(.failure(AppError.error("Room limit reached")))
                return
            }
            FirestoreRepository<Member>(collectionPath: "rooms/"+room.id+"/members").create(member) { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(()))
            }
        }
    }
    
    private func updateRoom(room: Room) -> Future<Void, Error> {
        Future { promise in
            FirestoreRepository<Room>(collectionPath: "rooms").update(room) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
}

extension HomeViewModel: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("sessionManager did initiate session in Home view")
        spotifyInitiateSessionSubject.send(session)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("sessionManager did fail with error in Home view")
        spotifyInitiateSessionSubject.send(completion: .failure(error))
    }
}

