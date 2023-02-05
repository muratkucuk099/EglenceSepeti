//
//  TableViewCell.swift
//  EglenceSepeti
//
//  Created by Mac on 9.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func initialSetup() {
        
        let myImage = postImageView.layer
        let myColor : UIColor = UIColor(red: 255/255, green: 115/255, blue: 165/255, alpha: 1)
        
        myImage.cornerRadius = 20
        myImage.borderWidth = 2.0
        myImage.borderColor = myColor.cgColor
        myImage.masksToBounds = true
    }
    
    

}
