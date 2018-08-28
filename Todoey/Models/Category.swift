//
//  Category.swift
//  Todoey
//
//  Created by Mick Mossman on 28/8/18.
//  Copyright © 2018 Mick Mossman. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
