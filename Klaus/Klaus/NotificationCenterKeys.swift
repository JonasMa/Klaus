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
    static var updateEnemyItemsNotification = Notification.Name("updateEnemyItems")
    static var updatePlayerItemsNotification = Notification.Name("updatePlayerItems");
    static var updateEnemyLevelNotification = Notification.Name("updateEnemyLevel");
    static var showAlertNotification = Notification.Name("alert");
    static var updatePlayerLevelNotification = Notification.Name("updatePlayerLevel");
    static var highlightItemNotification = Notification.Name("highlightItem");
    static var setTutorialPageViewController = Notification.Name("changeTutorialPage");
    static var timerMaxDurationReached = Notification.Name("maxDurationReached");
    static var timerAfterOneSecond = Notification.Name("oneSecLater");
    static var startGame = Notification.Name("startAttackerGame");

}
