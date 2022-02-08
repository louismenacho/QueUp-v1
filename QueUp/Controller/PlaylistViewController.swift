//
//  PlaylistViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/14/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var vm: PlaylistViewModel!
    var searchViewController: SearchViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSongsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Room Playlist"
        navigationItem.searchController = prepareSearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.dataSource = self
        tableView.delegate = self
        playButton.isHidden = !vm.isCurrentUserHost()
        
        vm.roomChangeListener { [self] result in
            switch result {
            case .failure(let error):
                print(error)
                presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomDetailsViewController" {
            let vc = segue.destination as! RoomDetailsViewController
            vc.vm = RoomDetailsViewModel(vm.room, vm.currentMember)
        }
    }
    
    @IBAction func addSongButtonPressed(_ sender: UIButton) {
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        vm.wakeAndPlay { [self] result in
            if case .failure(let error) = result {
                print(error)
                presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
            }
        }
    }
    
    private func prepareSearchController() -> UISearchController? {
        searchViewController = storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController
        searchViewController.vm = SearchViewModel(vm.room.spotifyToken)
        searchViewController.delegate = self
        
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = searchViewController
        searchController.searchBar.placeholder = "Search songs, artists, albums"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        searchController.delegate = self
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
