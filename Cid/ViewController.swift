//
//  ViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 10/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tapGesture1 = UITapGestureRecognizer()
    
    @IBOutlet weak var OKButton: UIButton!
    @IBAction func AcceptButton(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
        
        let VC5 = self.storyboard!.instantiateViewController(withIdentifier: "MainTabID") as! UITabBarController
        self.present(VC5, animated: false)
    
    }
    @IBOutlet weak var welcomeGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        welcomeGif.loadGif(name: "WelcomeOnce")
        OKButton.layer.cornerRadius = 8
        OKButton.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        OKButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        OKButton.layer.shadowRadius = 1.0
        OKButton.layer.shadowOpacity = 0.9
        OKButton.layer.masksToBounds = false
        OKButton.backgroundColor = UIColor.init(red: 111/255, green: 251/255, blue: 164/255, alpha: 1.0)
        OKButton.isHidden = false
        OKButton.alpha = 1
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.showMain))
        OKButton.addGestureRecognizer(tapGesture1)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.showMain))
        OKButton.addGestureRecognizer(tapGesture1)

        
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.showMain))
        OKButton.addGestureRecognizer(tapGesture1)
       

    }
    
    @objc func showMain (){
        let VC5 = self.storyboard!.instantiateViewController(withIdentifier: "MainTabID") as! UITabBarController
        self.present(VC5, animated: false)
    }

}

