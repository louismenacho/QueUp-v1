//
//  RoomDetailsViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/19/21.
//

import UIKit

class RoomDetailsViewController: UIViewController {
    
    var vm: RoomDetailsViewModel!

    @IBOutlet weak var roomIDLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomIDLabel.text = vm.room.id
        tableView.dataSource = self
        tableView.delegate = self
        tableHeaderView.frame.size = CGSize(width: view.frame.width, height: view.frame.width/2)
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
}

extension RoomDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
}

extension RoomDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = vm.members[indexPath.row]
        presentAlert(title: member.displayName, style: .actionSheet, actionTitle: "Remove", actionStyle: .destructive) { [self] _ in
            vm.deleteMember(at: indexPath.row) { result in
                if case .failure(let error) = result {
                    print(error)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members \(vm.members.count)/8"
    }
}
