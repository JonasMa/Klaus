//
//  NotificationCenterKeys.swift
//  Klaus
//
//  Created by Alex Knittel on 18.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

struct NotificationCenterKeys{
    
    static var updatePlayerScoreNotification = Notification.Name("updateScore");
    static var updateEnemyListNotification = Notification.Name("updateEnemies");
    static var presentTutorialNotification = Notification.Name("presentTutorial");
    static var startGameFromEnemyTrigger = Notification.Name("startEnemyGame");
    static var updateEnemyItemsNotification = Notification.Name("updateEnemyItems");
    static var updateEnemyScoreNotification = Notification.Name("updateEnemyScore");
}
