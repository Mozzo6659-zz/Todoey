//
//  Item.swift
//  Todoey
//
//  Created by Mick Mossman on 26/8/18.
//  Copyright © 2018 Mick Mossman. All rights reserved.
//

import Foundation
class Item: Codable {
    var title = ""
    var done = false
    
    init(thetitle : String) {
        title = thetitle
        done = false
    }
}
