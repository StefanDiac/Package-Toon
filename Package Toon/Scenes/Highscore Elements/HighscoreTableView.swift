//
//  HighscoreTableView.swift
//  Package Toon
//
//  Created by Air_Book on 7/3/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit

class HighscoreTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var localScores = [Score]()
    var currentScoreType: ScoreGameMode
    var isLocal: Bool {
        didSet {
            if isLocal == false {
                self.downloadOnlineScores()
            }
        }
    }
    var onlineScores = [[String]]()
    var isDownloading = false
    
    override init(frame: CGRect, style: UITableViewStyle) {
        let scoreSaver = ScoreSaver()
        localScores = scoreSaver.retriveScores()
        currentScoreType = .disco
        isLocal = true
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor(red: 0.101, green: 0.192, blue: 0.216, alpha: 1)
        self.transform = CGAffineTransform(rotationAngle: 0.08)
        self.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLocal {
            return countFilteredLocalScores()
        } else {
            if isDownloading {
                return 1
            } else {
                return onlineScores[0].count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = retriveScore(forPosition: indexPath.row)
        cell.textLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 12)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 0.101, green: 0.192, blue: 0.216, alpha: 1)
        return cell
    }
    
    func countFilteredLocalScores() -> Int{
        var counter = 0
        localScores.forEach({
            if $0.scoreGameMode == currentScoreType {
                counter = counter + 1
            }
        })
        return counter
    }
    
    func retriveScore(forPosition position: Int) -> String {
        if isLocal {
            return retriveLocalScore(forPosition: position  + 1)
        } else {
            if isDownloading {
                return "Downloading Scores..."
            } else {
                return retriveOnlineScore(forPosition: position, gameMode: currentScoreType)
            }
        }
    }
    
    func retriveLocalScore(forPosition position: Int) -> String {
        var scoreAsString: String = ""
        localScores.forEach({
            if $0.scoreGameMode == currentScoreType && $0.scorePosition == position {
                scoreAsString = $0.scoreToDisplayString()
            }
        })
        return scoreAsString
    }
    
    func retriveOnlineScore(forPosition position: Int, gameMode: ScoreGameMode) -> String {
        switch gameMode {
        case .disco:
            return onlineScores[0][position]
        case .rush:
            return onlineScores[1][position]
        case .fiveRush:
            return onlineScores[2][position]
        }
    }
    
    func downloadOnlineScores() {
        if onlineScores.count == 0 {
            if !isDownloading {
                isDownloading = true
                FirebaseDAO.retriveOnlineScores { (scores) in
                    if let scoresDictionaryArray = scores {
                        self.isDownloading = false
                        self.onlineScores = self.formatOnlineScores(scoresDictionaries: scoresDictionaryArray)
                        if self.isLocal == false {
                            self.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func formatOnlineScores(scoresDictionaries: [(NSDictionary, String)]) -> [[String]]{
        var discoScores = [(Int, String)]()
        var rushScores = [(Int, String)]()
        var fiveRushScores = [(Int, String)]()
        scoresDictionaries.forEach({
            let discoScore = $0.0[GAME_IDENTIFIERS_STRING_LITERALS[0]] as! Int
            let rushScore = $0.0[GAME_IDENTIFIERS_STRING_LITERALS[1]] as! Int
            let fiveRushScore = $0.0[GAME_IDENTIFIERS_STRING_LITERALS[2]] as! Int
            
            discoScores.append((discoScore, $0.1))
            rushScores.append((rushScore, $0.1))
            fiveRushScores.append((fiveRushScore, $0.1))
        })

        var scoresStringsFormatted = [[String]]()
        scoresStringsFormatted.append(prepareScoreArrayForDisplay(scoreArray: discoScores))
        scoresStringsFormatted.append(prepareScoreArrayForDisplay(scoreArray: rushScores))
        scoresStringsFormatted.append(prepareScoreArrayForDisplay(scoreArray: fiveRushScores))
        return scoresStringsFormatted
    }
    
    func prepareScoreArrayForDisplay(scoreArray: [(Int, String)]) -> [String] {
        var scoreCopy = scoreArray
        scoreCopy.sort(by: {
            $0.0 > $1.0
        })
        
        var scoresAsStrings = [String]()
        for i in 0..<scoreCopy.count {
            scoresAsStrings.append("\(i+1). \(scoreCopy[i].0) by \(scoreCopy[i].1)")
        }
        return scoresAsStrings
    }
}
