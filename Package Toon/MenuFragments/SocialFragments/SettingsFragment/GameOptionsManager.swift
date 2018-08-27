//
//  GameOptionsManager.swift
//  Package Toon
//
//  Created by Air_Book on 7/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class GameOptionsManager {
    var colorBlindOption: ColorBlindOption!
    var greenZoneOption: Bool!
    var rushZoneOption: Bool!
    
    func retriveAllOptions() {
        _ = retriveColorBlindOption()
        greenZoneOption = retriveGreenZoneOption()
        rushZoneOption = retriveRushZoneOption()
    }
    
    func retriveColorBlindOption() -> ColorBlindOption {
        let defaults = UserDefaults.standard
        if let colorBlindOption = defaults.string(forKey: "colorBlind") {
            self.colorBlindOption = ColorBlindOption.stringToCase(forCase: colorBlindOption)
        } else {
            colorBlindOption = .noColorBlind
            defaults.set(colorBlindOption.caseAsString(), forKey: "colorBlind")
        }
        return colorBlindOption
    }
    
    func saveNewColorBlindOption(newOption: ColorBlindOption) {
        colorBlindOption = newOption
        let defaults = UserDefaults.standard
        defaults.set(newOption.caseAsString(), forKey: "colorBlind")
    }
    
    func retriveGreenZoneOption() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "green")
    }
    
    func setGreenZoneParticles(isActive: Bool) {
        UserDefaults.standard.set(isActive, forKey: "green")
    }
    
    func retriveRushZoneOption() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "rushZone")
    }
    
    func setRushZoneParticles(isActive: Bool) {
        UserDefaults.standard.set(isActive, forKey: "rushZone")
    }
}
