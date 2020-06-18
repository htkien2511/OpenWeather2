//
//  UIViewExtension.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/18/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

extension UIView {
  func corner(radius: CGFloat = 2.0) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = false
  }
  
  func shadow(color: CGColor = UIColor.black.cgColor, opacity: Float = 0.5, radius: CGFloat = 5.0) {
    self.layer.shadowOpacity = opacity
    self.layer.shadowColor = color
    self.layer.shadowRadius = radius
    self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
  }
  
  func border(width: CGFloat = 0.5) {
    self.layer.borderWidth = width
  }
}
