//
//  CalibrationInfo+CoreDataProperties.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 3/31/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//
//

import Foundation
import CoreData


extension CalibrationInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalibrationInfo> {
        return NSFetchRequest<CalibrationInfo>(entityName: "CalibrationInfo")
    }

    @NSManaged public var dataAdded: NSDate?
    @NSManaged public var headSize: Double
    @NSManaged public var headSizeUnit: String?
    @NSManaged public var thickness: Double
    @NSManaged public var racquetString: RacquetString?

}
