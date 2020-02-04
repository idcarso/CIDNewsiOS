//
//  NewWebViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 2/4/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

class NewWebViewController: UIViewController {
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var progressViewCarga: UIProgressView!
    @IBOutlet weak var viewContenedorMenu: UIView!
    @IBOutlet weak var viewToast: UIView!
    
    // MARK: - LIFECYCLE VIEW CONTROLLER
    override func viewDidAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        progressViewCarga.isHidden = true
        viewContenedorMenu.isHidden = true
        viewToast.isHidden = true
        
        SetupStatusBar()
        SetupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - FUNCTIONS
    func SetupNavigationBar () {
        var statusBarHeight:CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("Status bar height: \(statusBarHeight)")
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: 44))
        navBar.isTranslucent = false
        navBar.barTintColor = UIColor(named: "view_aboutus")
        navBar.backgroundColor = .white
        navBar.delegate = self as? UINavigationBarDelegate
        
        self.view.addSubview(navBar)
        
        let image = UIImage(named: "logocidweb")
        let imageView = UIImageView(image: image)
        let imageWidth = navBar.frame.size.width - 10
        let imageHeight = navBar.frame.size.height - 10
        let imageX = imageWidth / 2 - (image?.size.width)! / 2
        let imageY = imageHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        imageView.contentMode = .scaleAspectFit
        
        
        let navItem = UINavigationItem()
        navItem.titleView = imageView
        navItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: nil)
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_vertical"), style: .plain, target: self, action: nil)
        navBar.items = [navItem]
        
        
    }
    
    func SetupStatusBar () {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(named: "view_aboutus")
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKey: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "view_aboutus")
        }
    }
    
}
