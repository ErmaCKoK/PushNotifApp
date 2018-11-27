//
//  BorderButton.swift
//  Push Notif App
//
//  Created by Andrii Kurshyn on 11/26/18.
//  Copyright © 2018 Andrii Kurshyn. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }

}
