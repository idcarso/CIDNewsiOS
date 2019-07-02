//
//  HomeProtocol.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//

import Foundation


protocol HomeControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
    func setMenuSlideOption(optionIndex menuOption:Int)
}
