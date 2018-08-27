//
//  ScoreSaverProtocols.swift
//  Package Toon
//
//  Created by Air_Book on 6/4/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import CoreData

protocol SavesToCoreData {
    func saveToCoreData(toAddScore: Score)
}

protocol ReadsFromCoreData {
    func readAllDataFromCoreData()
}

protocol DecideScoreAllocation {
    func decideScoreAllocation(scoreToCheckForAdding: Score) -> Bool
}
