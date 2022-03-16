//
//  RoomDetailsViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/19/21.
//

import UIKit

class RoomDetailsViewController: UIViewController {
    
    var vm: RoomDetailsViewModel!

    @IBOutlet weak var leaveRoomButton: UIBarButtonItem!
    @IBOutlet weak var roomIDLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomIDLabel.text = vm.room.id
        tableView.dataSource = self
        tableView.delegate = self
        tableHeaderView.frame.size = CGSize(width: view.frame.width, height: view.frame.width/2)
        if !vm.currentMember.isHost {
            navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.membersChangeListener { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                print("members updated")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.removeMembersChangeListener()
    }
    
    @IBAction func leaveRoomButtonPressed(_ sender: UIBarButtonItem) {
        presentAlert(title: "Are you sure you want to close this room?", actions: [
            (title: "No", style: .cancel, nil),
            (title: "Yes", style: .destructive, { [self] _ in
                vm.deleteRoom { [self] result in
                    if case .failure(let error) = result {
                        print(error)
                        presentAlert(title: error.localizedDescription, actionTitle: "Dismiss")
                    }
                }
            })
        ])
    }
}

extension RoomDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return vm.members.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as? MemberTableViewCell else {
                return UITableViewCell()
            }
            cell.member = vm.members[indexPath.row]
            cell.isUserInteractionEnabled = vm.currentMember.isHost
            if vm.currentMember.isHost {
                cell.accessoryType = cell.member.isHost ? .none : .disclosureIndicator
                cell.isUserInteractionEnabled = !cell.member.isHost
            }
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "ClearQueueTableViewCell", for: indexPath)
        }
    }
}

extension RoomDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let member = vm.members[indexPath.row]
            presentAlert(title: member.displayName, style: .actionSheet, actionTitle: "Remove", actionStyle: .destructive) { [self] _ in
                vm.deleteMember(at: indexPath.row) { result in
                    if case .failure(let error) = result {
                        print(error)
                    }
                }
            }
        } else {
            performSegue(withIdentifier: "InstructionsViewController", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Members \(vm.members.count)/8"
        } else {
            return "Help"
        }
    }
}
