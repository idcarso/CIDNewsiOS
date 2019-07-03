//
//  ContainerController.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//


import UIKit


class ContainerController: UIViewController{
    
    //MARK: Properties
    
    var menuSlideController:MenuSlideController!
    var centerController: UIViewController!
    var isExpanded = false
    var homeController:Home!
    
    //MARK: Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHome()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    //MARK: Handlers
    
    func configurationHome(){
        homeController = storyboard!.instantiateViewController(withIdentifier: "HomeId") as? Home
        homeController.delegate = self
        
        
    
        self.view.addSubview(homeController.view)
        self.addChild(homeController)
        homeController.didMove(toParent: self)
        centerController = homeController

    }
    
    func configureMenuSlideController(){
        if menuSlideController == nil {
            // Add menu controller here
            menuSlideController = MenuSlideController()
            menuSlideController.delegate = self
            menuSlideController.view.frame = view.bounds
            self.view.insertSubview(menuSlideController.view, at: 0)
            addChild(menuSlideController)
            menuSlideController.didMove(toParent: self)
            print("ContainerController -- configureMenuSlideController")
            
            
            let swipeRightInMenuController = UISwipeGestureRecognizer(target: self, action: #selector(handleCloseMenu)) // Añade Gestures
            
            swipeRightInMenuController.direction = .right
            menuSlideController.view.addGestureRecognizer(swipeRightInMenuController)

        }
    }
    
    
    func animatePanel(shouldExpand: Bool,menuOption:MenuOption?){
        if shouldExpand {
            //showing Menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = -self.centerController.view.frame.width + 80
                
            }, completion: nil)
            
        }else{
            //hide Menu
        
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = 0
                
            }){ (_) in
                guard let menuOption = menuOption else{ return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption:MenuOption){
        var index:Int = 0
        switch menuOption {
        case .Health:
            print("ContainerController -- didSelectMenuOption: Health")
            index = 0
        case .Construction:
            print("ContainerController -- didSelectMenuOption: Construction")
            index = 1
        case .Retail:
            print("ContainerController -- didSelectMenuOption: Retail")
            index = 2
        case .Education:
            print("ContainerController -- didSelectMenuOption: Education")
            index = 3
        case .Entertainment:
            print("ContainerController -- didSelectMenuOption: Entertainment")
            index = 4
        case .Environment:
            print("ContainerController -- didSelectMenuOption: Environment")
            index = 5
        case .Finance:
            print("ContainerController -- didSelectMenuOption: Finance");
            index = 6
        case .Energy:
            print("ContainerController -- didSelectMenuOption: Energy")
            index = 7
        case .Telecom:
            print("ContainerController -- didSelectMenuOption: Telecom")
            index = 8
        }
        
        homeController.loadMenuSlideNews(index: index)
        menuSlideController.restoreDefaultTableView(index: index)
        
    }
    
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
           self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    @objc func handleCloseMenu() {
        print("ContainerController --  handleCloseMenu()")
        animatePanel(shouldExpand: false ,menuOption: nil)
        isExpanded = false
        
        homeController.viewTinderBackGround.isUserInteractionEnabled = true
        homeController.Shares[2].isUserInteractionEnabled = true
    }
    
}

extension ContainerController: HomeControllerDelegate{
    func setMenuSlideOption(optionIndex menuOption: Int) {
        print("ContainerController --  setMenuSlideOption()")

    }
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        print("ContainerController --  handleMenuToggle()")
        
        if !isExpanded{
            configureMenuSlideController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded,menuOption: menuOption)
        
    }
}
