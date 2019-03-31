//
//  RacquetString+ConvenienceCreation.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 3/30/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//

import Foundation
import CoreData

extension RacquetString {
    
    @discardableResult convenience init(context: NSManagedObjectContext, name: String, ro: Double) {
        self.init(context: context)
        self.name = name
        self.ro = ro
    }
    
}
