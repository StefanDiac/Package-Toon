//
//  ScoreSaver.swift
//  Package Toon
//
//  Created by Air_Book on 6/4/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit
import CoreData

//TO DO - Rewrite Requests to be more readable, less copy pastey

class ScoreSaver: SavesToCoreData, ReadsFromCoreData, DecideScoreAllocation {
    
    var scores: [Score]
    let context: NSManagedObjectContext
    static let SCORE_CORE_DATA_ENTITY_NAME = "ScoreEntity"
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        scores = [Score]()
    }
    
    internal func saveToCoreData(toAddScore: Score) {
        let entity = NSEntityDescription.entity(forEntityName: ScoreSaver.SCORE_CORE_DATA_ENTITY_NAME, in: context)

        let newScore = NSManagedObject(entity: entity!, insertInto: context)
        newScore.setValue(toAddScore.scorePosition, forKey: "position")
        newScore.setValue(toAddScore.scoreValue, forKey: "score")
        newScore.setValue(toAddScore.scoreGameMode.caseToString(), forKey: "gamemode")
        newScore.setValue(toAddScore.scoreDate, forKey: "obtainedOn")
        
        do {
            try context.save()
        } catch {
            print("Failed to save new score...")
        }
    }
    
    internal func readAllDataFromCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ScoreSaver.SCORE_CORE_DATA_ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for scoreData in result as! [NSManagedObject] {
                let gameMode = scoreData.value(forKey: "gamemode") as! String
                let obtainedOn = scoreData.value(forKey: "obtainedOn") as! Date
                let position = scoreData.value(forKey: "position") as! Int
                let score = scoreData.value(forKey: "score") as! Int
                
                scores.append(Score(scoreValue: score, scorePosition: position, scoreDate: obtainedOn, scoreGameMode: try ScoreGameMode.getCase(forString: gameMode)))
            }
        } catch {
            print("Could not fetch Local Scores !")
        }
    }

    internal func readScoresFromCoredata(forGamemode gamemode: ScoreGameMode) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ScoreSaver.SCORE_CORE_DATA_ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for scoreData in result as! [NSManagedObject] {
                if let entryGamemode = scoreData.value(forKey: "gamemode") as? String, entryGamemode == gamemode.caseToString() {
                    let obtainedOn = scoreData.value(forKey: "obtainedOn") as! Date
                    let position = scoreData.value(forKey: "position") as! Int
                    let score = scoreData.value(forKey: "score") as! Int
                    scores.append(Score(scoreValue: score, scorePosition: position, scoreDate: obtainedOn, scoreGameMode: try ScoreGameMode.getCase(forString: entryGamemode)))
                }
            }
        } catch {
            print("Could not access scores")
        }
    }
    
    func retriveScores() -> [Score] {
        if scores.count == 0 {
            readAllDataFromCoreData()
        }
        sortScores()
        return scores
    }
    
    func decideScoreAllocation(scoreToCheckForAdding: Score) -> Bool {
        readScoresFromCoredata(forGamemode: scoreToCheckForAdding.scoreGameMode)
        sortScores()
        if(addScoreToArray(scoreToCheck: scoreToCheckForAdding)) {
            increasePositionOfRecord(startingWith: scoreToCheckForAdding.scorePosition, forGamemode: scoreToCheckForAdding.scoreGameMode)
            saveToCoreData(toAddScore: scoreToCheckForAdding)
            if(scoreToCheckForAdding.scorePosition==1) {
                return true
            }
        }
        return false
    }
    
   private func sortScores() {
        if(scores.count >= 2) {
            scores.sort(by: {
                $0.scorePosition < $1.scorePosition
            })
        }
    }
    
    private func removeFromCoreData(at positionToRemove: Int, forGamemode gamemode: ScoreGameMode) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ScoreSaver.SCORE_CORE_DATA_ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for scoreData in result as! [NSManagedObject] {
                if let entryGamemode = scoreData.value(forKey: "gamemode") as? String, entryGamemode == gamemode.caseToString() {
                    let position = scoreData.value(forKey: "position") as! Int
                    
                    if position == positionToRemove {
                        context.delete(scoreData)
                    }
                }
            }
        } catch {
            print("Could not fetch Local Scores !")
        }
    }
    
    private func getPositionToAdd(forScore: Score) -> (Int,Bool) {
        var position = 11
        var couldAdd = false
        if scores.count == 0 {
            couldAdd = true
            position = 1
        } else {
            scores.forEach({
                if $0.scoreValue < forScore.scoreValue && couldAdd == false {
                    position = $0.scorePosition
                    couldAdd = true
                }
            })
            if couldAdd == false && scores.count<10 {
                couldAdd = true
                position = scores.count + 1
            }
        }
        return(position,couldAdd)
    }
    
    private func increasePositionOfRecord(startingWith: Int, forGamemode gamemode: ScoreGameMode) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ScoreSaver.SCORE_CORE_DATA_ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for scoreData in result as! [NSManagedObject] {
                if let entryGamemode = scoreData.value(forKey: "gamemode") as? String, entryGamemode == gamemode.caseToString() {
                    let position = scoreData.value(forKey: "position") as! Int
                    
                    if position >= startingWith {
                        scoreData.setValue(position+1, forKey: "position")
                    }
                }
            }
        } catch {
            print("Could not fetch Local Scores !")
        }
    }
    
   private func addScoreToArray(scoreToCheck: Score) -> Bool {
        let positionAndPosibility = getPositionToAdd(forScore: scoreToCheck)
        if(positionAndPosibility.1) {
            scoreToCheck.scorePosition = positionAndPosibility.0
            scores.forEach({
                if $0.scorePosition >= positionAndPosibility.0 {
                    $0.scorePosition = $0.scorePosition+1
                    if $0.scorePosition == 11 {
                        removeFromCoreData(at: $0.scorePosition - 1, forGamemode: scoreToCheck.scoreGameMode)
                        scores.remove(at: $0.scorePosition - 2)
                    }
                }
            })
            scores.insert(scoreToCheck, at: positionAndPosibility.0-1)
            return true
        } else {
            return false
        }
    }
}
