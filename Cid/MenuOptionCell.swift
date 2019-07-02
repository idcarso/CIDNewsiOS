//
//  MenuOptionCell.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    
    let iconImgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let descriptionMenu:UILabel = {
        let txt = UILabel()
        txt.textColor = .white
        txt.adjustsFontSizeToFitWidth = true
        txt.text = "This is a sample text"
        return txt
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.init(named: "MenuSlide")
        selectionStyle = .none
        addSubview(iconImgView)

        
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImgView.leftAnchor.constraint(equalTo: leftAnchor,constant: 80 + 30).isActive = true
        iconImgView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImgView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(descriptionMenu)
        
        descriptionMenu.translatesAutoresizingMaskIntoConstraints = false
        descriptionMenu.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionMenu.leftAnchor.constraint(equalTo: iconImgView.rightAnchor,constant: 15).isActive = true
      

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
