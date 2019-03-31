//
//  RacquetString+CoreDataProperties.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 3/31/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//
//

import Foundation
import CoreData


extension RacquetString {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RacquetString> {
        return NSFetchRequest<RacquetString>(entityName: "RacquetString")
    }

    @NSManaged public var name: String?
    @NSManaged public var ro: Double
    @NSManaged public var calibrationInfo: CalibrationInfo?

}
