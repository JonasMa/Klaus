//
//  ConnectingDelegate.swift
//  Klaus
//
//  Created by Jonas Programmierer on 19.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation


protocol ConnectingDelegate {
    
    func didRetrievePlayerInfo(name: String)
    
    func didRetrievePlayerInfo(score: Int)
    
    func didRetrievePlayerInfo(items: Array<Item>)
}
