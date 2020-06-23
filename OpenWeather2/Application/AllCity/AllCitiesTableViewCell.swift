//
//  AllCitiesTableViewCell.swift
//  OpenWeather2
//
//  Created by Hoang Trong Kien on 6/18/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class AllCitiesTableViewCell: UITableViewCell {
  
  // MARK: - Outlet
  @IBOutlet weak var city: UILabel!
  @IBOutlet weak var country: UILabel!
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var temperature: UILabel!
  @IBOutlet weak var humidity: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
