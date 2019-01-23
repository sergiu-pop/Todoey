//
//  Data.swift
//  Todoey
//
//  Created by Sergiu on 23/01/2019.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
