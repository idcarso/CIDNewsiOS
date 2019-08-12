//
//  FirstTabController.swift
//  Cid
//
//  Created by Mac CTIN  on 05/12/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit
import FirebaseAnalytics
class NavigationTabController: UITabBarController,UITabBarControllerDelegate{

    let rectShape = CAShapeLayer()
    let indicatorHeight: CGFloat = 5
    var indicatorWidth: CGFloat!
    let indicatorBottomMargin: CGFloat = 2
    let indicatorLeftMargin: CGFloat = 15
    let indicatorRightMargin: CGFloat = 15

    let indicatorTopMargin: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = "MainTabID"
        
        
        // setup tabbar indicator
        rectShape.fillColor = UIColor.white.cgColor
        //rectShape.fillColor = UIColor.init(named: "MenuMainBottomIndicator")?.cgColor
        indicatorWidth = view.bounds.maxX / 4 - indicatorLeftMargin - indicatorRightMargin // count of items
        self.view.layer.addSublayer(rectShape)
        self.delegate = self
    
        
        print("NavigationTabController --> self.view.frame.height:",self.view.frame.height)
        //self.tabBarController!.view.layer.addSublayer(rectShape)
        //self.tabBarController?.delegate = self
        print("NavigationTabController --> self.tabBar.frame.height:",self.tabBar.frame.height)
        
        //updateTabbarIndicatorBySelectedTabIndex(index: 0)
        // Do any additional setup after loading the view.
    }
  
    //////////////////////////
    //MARK:
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTabbarIndicatorBySelectedTabIndex(index: Int) -> Void
    {
        
        if index == 0 {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "Home iOS",
                AnalyticsParameterContentType: "Main Menu iOS"
                ])
        }
        if index == 1 {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "Favorites iOS",
                AnalyticsParameterContentType: "Main Menu iOS"
                ])
        }
        
        if index == 2 {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "Recover iOS",
                AnalyticsParameterContentType: "Main Menu iOS"
                ])
        }
        if index == 3 {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "Settings iOS",
                AnalyticsParameterContentType: "Main Menu iOS"
                ])
        }
        
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
        print("NavigationTabController --> tabBarController.index:",tabBarController.selectedIndex)
        updateTabbarIndicatorBySelectedTabIndex(index: tabBarController.selectedIndex)

    }
}


//  MARK:- UIViewControllerRestoration
extension NavigationTabController: UIViewControllerRestoration{
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        if let storyboard = coder.decodeObject(forKey: UIApplication.stateRestorationViewControllerStoryboardKey) as? UIStoryboard{
            if let vc = storyboard.instantiateViewController(withIdentifier: "MainTabID") as? NavigationTabController{
                return vc;
            }
        }
        return nil;
    }
    
}
