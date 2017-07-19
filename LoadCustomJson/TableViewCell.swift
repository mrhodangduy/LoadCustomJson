//
//  TableViewCell.swift
//  LoadCustomJson
//
//  Created by Paul on 7/19/17.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblid: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblphone: UILabel!
    @IBOutlet weak var lbljob: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
