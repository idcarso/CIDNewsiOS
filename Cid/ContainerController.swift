//
//  ContainerController.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//


import UIKit
import FirebaseAnalytics

class ContainerController: UIViewController{
    
    // MARK: - VARIABLES
    var centerController: UIViewController!
    var homeController:HomeViewController!
    
    // MARK: - LIFECYCLE VIEWCONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = "ContainerId"
        configurationHome()
    }
    
    // MARK: - FUNCTIONS
    func configurationHome(){
        homeController = storyboard!.instantiateViewController(withIdentifier: "HomeId") as? HomeViewController
        self.view.backgroundColor = UIColor.init(named: "MenuSlide")
        self.view.addSubview(homeController.view)
        self.addChild(homeController)
        homeController.didMove(toParent: self)
        centerController = homeController
    }
    
}
