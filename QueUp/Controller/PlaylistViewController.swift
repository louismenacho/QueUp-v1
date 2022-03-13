//
//  PlaylistViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/14/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var vm: PlaylistViewModel!
    var selectedPlaylistItem: PlaylistItem?
    var searchViewController: SearchViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSongsButton: UIButton!
    @IBOutlet weak var spotifyPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Songs Added"
        navigationItem.searchController = prepareSearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.dataSource = self
        tableView.delegate = self
        spotifyPlayButton.isHidden = true
        
        vm.roomChangeListener { [self] result in
            switch result {
            case .failure(let error):
                if case .notFound = error {
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    print(error)
                    presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
                }
            case .success(let room):
                print("room updated")
                searchViewController.vm.updateSpotifyToken(room.spotifyToken)
            }
        }
        
        vm.currentMemberChangeListener { [self] result in
            if case let .failure(error) = result {
                if case .notFound = error {
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    print(error)
                    presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
                }
            }
        }
        
        vm.playlistChangeListener { [self] result in
            switch result {
            case .failure(let error):
                print(error)
                presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
            case .success:
                DispatchQueue.main.async {
                    tableView.reloadData()
                    tableView.isScrollEnabled = !vm.playlist.isEmpty
                    addSongsButton.isHidden = !vm.playlist.isEmpty
                }
            }
        }
        
        if vm.isCurrentUserHost() {
            vm.getPlayerState { [self] result in
                switch result {
                case .failure(let error):
                    if case .badResponse(let code, let description, let json) = error {
                        print(code)
                        print(description)
                        print(json)
                    }
                case .success(let response):
                    if response.isPlaying == nil || response.isPlaying == false {
                        DispatchQueue.main.async {
                            spotifyPlayButton.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed || self.isMovingFromParent {
            vm.removeRoomChangeListener()
            vm.removeMemberChangeListener()
            vm.removePlaylistChangeListener()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomDetailsViewController" {
            let vc = segue.destination as! RoomDetailsViewController
            vc.vm = RoomDetailsViewModel(vm.room, vm.currentMember)
        }
        if segue.identifier == "SongDetailsViewController" {
            let vc = segue.destination as! SongDetailsViewController
            if let playlistItem =  selectedPlaylistItem {
                vc.song = playlistItem.song
                vc.isCurrentUserHost = vm.isCurrentUserHost()
            }
        }
    }
    
    @IBAction func addSongButtonPressed(_ sender: UIButton) {
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
//        UIApplication.shared.open(URL(string: "spotify://")!, options: [:], completionHandler: nil)
        vm.wakeAndPlay { result in
            if case .failure(let error) = result {
                print(error)
            }
            UIView.animate(withDuration: 0.3) {
                self.spotifyPlayButton.alpha = 0
            } completion: { _ in
                self.spotifyPlayButton.isHidden = true
                self.spotifyPlayButton.alpha = 1
            }
        }
    }
    
    private func prepareSearchController() -> UISearchController? {
        searchViewController = storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController
        searchViewController.vm = SearchViewModel(vm.room.spotifyToken)
        searchViewController.vm.isCurrentUserHost = vm.isCurrentUserHost()
        searchViewController.delegate = self
        
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchViewController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            let atrString = NSAttributedString(string: "Search songs, artists, albums",
                                               attributes: [.font : UIFont(name: "Avenir Next", size: 17) ?? .systemFont(ofSize: 17)])
            textfield.attributedPlaceholder = atrString
        }
        return searchController
    }
    
    @IBAction func sessionDetailsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "RoomDetailsViewController", sender: self)
    }
}

extension PlaylistViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell", for: indexPath) as? PlaylistTableViewCell else {
            return UITableViewCell()
        }
        cell.playlistItem = vm.playlist[indexPath.row]
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaylistItem = vm.playlist[indexPath.row]
        performSegue(withIdentifier: "SongDetailsViewController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

extension PlaylistViewController: SearchViewControllerDelegate {
    func searchViewController(_ searchViewController: SearchViewController, didAdd song: Song) {
        vm.addPlaylistItem(newSong: song) { [self] result in
            if case .failure(let error) = result {
                print(error)
                presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
            }
        }
    }
    
    func searchViewController(_ searchViewController: SearchViewController, renewSpotifyToken: Void) {
        vm.renewSpotifyToken { [self] result in
            if case .failure(let error) = result {
                print(error)
                presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
            } else {
                print("renewSpotifyToken completed")
            }
        }
    }
}
