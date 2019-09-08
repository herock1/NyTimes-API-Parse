//
//  SearchData+CoreDataProperties.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 20/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchData> {
        return NSFetchRequest<SearchData>(entityName: "SearchData")
    }

    @NSManaged public var searchtext: String?
    @NSManaged public var time: String?

}
