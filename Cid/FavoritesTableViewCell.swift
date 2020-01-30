//
//  FavoritesTableViewCell.swift
//  Cid
//
//  Created by Mac CTIN  on 25/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {   //Se ligan las celdas de la TableView de Favorites con los UI
    @IBOutlet weak var AvatarFav: UIImageView!
    @IBOutlet weak var TitleFav: UILabel!
    @IBOutlet weak var AutorFav: UILabel!
    @IBOutlet weak var BasuraIconAvatar: UIImageView!
    @IBOutlet weak var TimeLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
