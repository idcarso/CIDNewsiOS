//
//  FirstViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 06/12/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let VC4 = self.storyboard!.instantiateViewController(withIdentifier: "StartID") as! ViewController
            self.present(VC4, animated: false)
            //let widthHelpfull = viewTinderBackGround.frame.width
            //viewTinderBackGround.frame(forAlignmentRect: CGRect.init(x: 0, y: 0, width: widthHelpfull, height: view.frame.size.height));
        }
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
