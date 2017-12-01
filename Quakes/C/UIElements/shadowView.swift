//
//  shadowView.swift
//  Quakes
//
//  Created by Thijs van der Heijden on 11/26/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import Foundation
import UIKit

final class shadowView: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.75
    }
    
}
