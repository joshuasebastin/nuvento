//
//  DevicesListTableViewCell.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit

class DevicesListTableViewCell: UITableViewCell {
    @IBOutlet weak var DeviceNameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
