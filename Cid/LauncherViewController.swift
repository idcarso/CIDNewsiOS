//
//  FirstViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 06/12/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit

class LauncherViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let launchedBefore1 = UserDefaults.standard.bool(forKey: "launchedBefore1")  // Primer lanzamiento de la Aplicacion
        
        if launchedBefore1  {
            
            print("Not first launch.")
            let VC5 = self.storyboard!.instantiateViewController(withIdentifier: "MainTabID") as! UITabBarController
            self.present(VC5, animated: false)
            
        } else {
            
            print("First launch.")
            UserDefaults.standard.set(true, forKey: "launchedBefore1")
            let VC4 = self.storyboard!.instantiateViewController(withIdentifier: "StartID") as! TutorialViewController
            self.present(VC4, animated: false)
            
        }

    }

}
