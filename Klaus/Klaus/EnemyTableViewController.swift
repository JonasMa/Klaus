//
//  EnemyTableViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EnemyCell";

class EnemyTableViewController: UITableViewController {
    
    var enemiesList = Array<EnemyProfile>();
    
    
    override func loadView() {
        self.tableView = EnemyTableView(frame: UIScreen.main.bounds);
        
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updateEnemyListNotification, object: nil, queue: nil, using: updateList);
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Style.bg;
        self.tableView.register(EnemyTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.refreshControl = UIRefreshControl();
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)

        self.view.addSubview(refreshControl!);
        self.view.sendSubview(toBack: refreshControl!);

    }
    
    func handleRefresh() {
        BluetoothController.sharedInstance.refreshEnemyList()
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.enemiesList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EnemyTableViewCell;
        let profile = self.enemiesList[indexPath.row];
        cell.textLabel!.text = profile.name;
        cell.detailTextLabel?.text = String(profile.score);
        cell.setAvatar(avatar: profile.profileAvatar);
        cell.setColor(color: profile.profileColor);
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileViewController = EnemyProfileViewController();
        profileViewController.profile = self.enemiesList[indexPath.row];
        BluetoothController.sharedInstance.connectToPlayer(playerUuid: profileViewController.profile.uuid)
        self.navigationController?.pushViewController(profileViewController, animated: true);
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.1
    }
    
    func updateList(notification: Notification){
        enemiesList = Array(notification.userInfo!.values) as! Array<EnemyProfile>;
        print("Enemy List Updated!");
        self.tableView.reloadData();
        
    }

}
