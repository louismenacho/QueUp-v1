//
//  PlaylistViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/25/21.
//

import Foundation
import FirebaseAuth

class PlaylistViewModel: NSObject {
    
    var room: Room
    var roomRepository: FirestoreRepository<Room>
    
    var currentMember: Member
    var memberRepository: FirestoreRepository<Member>
    
    var playlist: [PlaylistItem]
    var playlistRepository: FirestoreRepository<PlaylistItem>
    
    var spotifySessionManager: SPTSessionManager?
    private var spotifyRenewSessionCompletion: ((Result<Void, Error>) -> Void)?

    var spotifyConfig: SPTConfiguration?
    var spotifyScope: SPTScope = [
        .appRemoteControl,
        .userReadCurrentlyPlaying,
        .userReadRecentlyPlayed,
        .userReadPlaybackState,
        .userModifyPlaybackState,
        .userReadPrivate
    ]
    
    init(_ currentMember: Member,_ room: Room, _ spotifySessionManager: SPTSessionManager?) {
        self.room = room
        self.roomRepository = FirestoreRepository<Room>(collectionPath: "rooms")
        
        self.currentMember = currentMember
        self.memberRepository = FirestoreRepository<Member>(collectionPath: "rooms/"+room.id+"/members")
        
        self.playlist = [PlaylistItem]()
        self.playlistRepository = FirestoreRepository<PlaylistItem>(collectionPath: "rooms/"+room.id+"/playlist")
        
        self.spotifySessionManager = spotifySessionManager
        super.init()
        self.spotifySessionManager?.delegate = self
    }
    
    func roomChangeListener(completion: @escaping (Result<Room, RepositoryError>) -> Void) {
        roomRepository.addListener(id: room.id) { result in
            completion( result.flatMap { room in
                self.room = room
                return .success(room)
            })
        }
    }
    
    func removeRoomChangeListener() {
        roomRepository.removeListener()
    }
    
    func updateRoom(completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        roomRepository.update(room) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func currentMemberChangeListener(completion: @escaping (Result<Member, RepositoryError>) -> Void) {
        memberRepository.addListener(id: currentMember.id) { result in
            completion( result.flatMap { room in
                return .success(room)
            })
        }
    }
    
    func removeMemberChangeListener() {
        memberRepository.removeListener()
    }
    
    func playlistChangeListener(completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        let query = playlistRepository.collectionReference.order(by: "dateAdded")
        playlistRepository.addListener(query) { result in
            completion( result.flatMap { songs in
                self.playlist = songs
                return .success(())
            })
        }
    }
    
    func removePlaylistChangeListener() {
        playlistRepository.removeListener()
    }
    
    func addPlaylistItem(newSong: Song, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        let newPlaylistItem = PlaylistItem(song: newSong, addedBy: currentMember)
        playlistRepository.create(newPlaylistItem) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func wakeAndPlay(completion: @escaping (Result<Void, Error>) -> Void) {
        spotifyConfig?.playURI = ""
        spotifySessionManager?.initiateSession(with: spotifyScope, options: .clientOnly)
        spotifyRenewSessionCompletion = { result in
            completion(result)
        }
    }
    
    func renewSpotifyToken(completion: @escaping (Result<Void, Error>) -> Void) {
        spotifySessionManager?.renewSession()
        spotifyRenewSessionCompletion = { result in
            completion(result)
        }
    }
    
    func isCurrentUserHost() -> Bool {
        return currentMember.id == room.host.id
    }
}

extension PlaylistViewModel: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("sessionManager did initiate session")
        room.spotifyToken = session.accessToken
        room.spotifyTokenExpirationDate = session.expirationDate
        updateRoom { result in
            switch result {
            case .failure(let error):
                self.spotifyRenewSessionCompletion?(.failure(error))
            case .success:
                self.spotifyRenewSessionCompletion?(.success(()))
            }
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("sessionManager did renew session")
        room.spotifyToken = session.accessToken
        updateRoom { result in
            switch result {
            case .failure(let error):
                self.spotifyRenewSessionCompletion?(.failure(error))
            case .success:
                self.spotifyRenewSessionCompletion?(.success(()))
            }
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("sessionManager did fail with error")
        self.spotifyRenewSessionCompletion?(.failure(error))
    }
}
