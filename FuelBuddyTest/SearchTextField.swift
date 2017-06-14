//
//  SearchTextField.swift
//  FuelBuddyTest
//
//  Created by Sergey Sokhach on 19.04.17.
//  Copyright © 2017 FinApp. All rights reserved.
//

import UIKit

class SearchTextField: UITextField, UITextFieldDelegate {
    
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40);
    
    init(frame: CGRect, tintText: String, tintFont: UIFont, tintTextColor: UIColor) {
        super.init(frame:frame)
        self.frame = frame
        
        delegate = self
        backgroundColor = .white
        textColor = tintTextColor
        placeholder = tintText
        font = tintFont
        
        createBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func createBorder() {
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
