//
//  FirstTabController.swift
//  Cid
//
//  Created by Mac CTIN  on 05/12/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit

class FirstTabController: UITabBarController,UITabBarControllerDelegate{

    let rectShape = CAShapeLayer()
    let indicatorHeight: CGFloat = 5
    var indicatorWidth: CGFloat!
    let indicatorBottomMargin: CGFloat = 2
    let indicatorLeftMargin: CGFloat = 15
    let indicatorRightMargin: CGFloat = 15

    let indicatorTopMargin: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // setup tabbar indicator
        rectShape.fillColor = UIColor.white.cgColor
        //rectShape.fillColor = UIColor.init(named: "MenuMainBottomIndicator")?.cgColor
        indicatorWidth = view.bounds.maxX / 4 - indicatorLeftMargin - indicatorRightMargin // count of items
        self.view.layer.addSublayer(rectShape)
        self.delegate = self
    
        
        print("FirstTabController --> self.view.frame.height:",self.view.frame.height)
        //self.tabBarController!.view.layer.addSublayer(rectShape)
        //self.tabBarController?.delegate = self
        print("FirstTabController --> self.tabBar.frame.height:",self.tabBar.frame.height)
        
        //updateTabbarIndicatorBySelectedTabIndex(index: 0)
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTabbarIndicatorBySelectedTabIndex(index: Int) -> Void
    {
        let updatedBounds = CGRect( x: CGFloat(index) * (indicatorWidth + indicatorLeftMargin + indicatorRightMargin ) + indicatorLeftMargin,
                                    //y: view.bounds.maxY - indicatorHeight,
            
                                    y: view.bounds.maxY - self.tabBar.frame.height,
                                    width: indicatorWidth,
                                    height: indicatorHeight)
        
        let path = CGMutablePath.init()
        path.addRect(updatedBounds)
        rectShape.path = path
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("FirstTabController --> tabBarController.index:",tabBarController.selectedIndex)
        updateTabbarIndicatorBySelectedTabIndex(index: tabBarController.selectedIndex)

    }
}
