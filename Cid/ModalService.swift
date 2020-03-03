//
//  ModalService.swift
//  Cid
//
//  Created by Ada Palazuelos on 3/3/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

class ModalService {
    
    func InstanceAlert() -> ModalViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewControllerModal = storyboard.instantiateViewController(withIdentifier: "ID_ModalWeb") as! ModalViewController
        
        return viewControllerModal
        
    }
}
