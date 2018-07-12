//
//  Photo+CoreDataProperties.swift
//  Test
//
//  Created by v.sova on 12.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var height: Int32
    @NSManaged public var id: String?
    @NSManaged public var likedByUser: Bool
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Double
    @NSManaged public var urlFull: String?
    @NSManaged public var urlSmall: String?
    @NSManaged public var width: Int32
    @NSManaged public var userName: String?

}
