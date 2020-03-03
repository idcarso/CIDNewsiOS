//
//  ModalServices.swift
//  Cid
//
//  Created by Ada Palazuelos on 3/2/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

class ModalService {
    
    func InstanceAlert() -> ModalViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "IDModal") as! ModalViewController
        
        return modalViewController
    }
    
    
}
