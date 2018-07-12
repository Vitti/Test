//
//  User+CoreDataProperties.swift
//  Test
//
//  Created by v.sova on 12.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var userName: String?

}
