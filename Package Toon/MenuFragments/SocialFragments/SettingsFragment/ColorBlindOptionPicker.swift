//
//  ColorBlindOptionPicker.swift
//  Package Toon
//
//  Created by Air_Book on 7/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit

class ColorBlindOptionPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    let pickerOptions = [ColorBlindOption.noColorBlind.caseAsString(), ColorBlindOption.protan.caseAsString(), ColorBlindOption.deutan.caseAsString(), ColorBlindOption.tritan.caseAsString()]
    let fragmentReference: SettingsFragment
    
    init(frame: CGRect, fragmentToDisplayOn fragment: SettingsFragment) {
        self.fragmentReference = fragment
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.text = pickerOptions[row]
        label.textColor = UIColor.white
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fragmentReference.gameOptions.saveNewColorBlindOption(newOption: ColorBlindOption.stringToCase(forCase: pickerOptions[row]))
    }
    
    func getRowForComponent(option: ColorBlindOption) -> Int{
        switch option {
        case .noColorBlind:
            return 0
        case .protan:
            return 1
        case .deutan:
            return 2
        case .tritan:
            return 3
        }
    }
}
