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
    
    var containerViewController:ContainerController?
    var homeViewController:HomeViewController?
    
    
    static let rectShape = CAShapeLayer()
    let indicatorHeight: CGFloat = 5
    var indicatorWidth: CGFloat!
    let indicatorBottomMargin: CGFloat = 2
    let indicatorLeftMargin: CGFloat = 15
    let indicatorRightMargin: CGFloat = 15

    let indicatorTopMargin: CGFloat = 3
    
    //VARIABLES ALEX
    static var seleccionNavigation:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "MainTabID"
        NavigationTabController.rectShape.fillColor = UIColor.white.cgColor
        indicatorWidth = view.bounds.maxX / 4 - indicatorLeftMargin - indicatorRightMargin // count of items
        
        //HACEMOS VISIBLE LA BARRA BLANCA DEL NAVIGATION CONTROLLER
        NavigationTabController.rectShape.isHidden = false
        
        self.view.layer.addSublayer(NavigationTabController.rectShape)
        self.delegate = self
        print("NavigationTabController --> self.view.frame.height:",self.view.frame.height)
        print("NavigationTabController --> self.tabBar.frame.height:",self.tabBar.frame.height)
        
        //QUITAMOS EL SOMBREADO DE LA SELECCION LIMPIANDO EL COLOR
        let numeroItems = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numeroItems, height: tabBar.frame.height)
        
        tabBar.selectionIndicatorImage = UIImage.ImagenSelectorTabBar(color: UIColor.clear, size: tabBarSize)
        
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func updateTabbarIndicatorBySelectedTabIndex(index: Int) -> Void {
        if index == 0 {
            
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterItemID: "Home iOS", AnalyticsParameterContentType: "Main Menu iOS"])
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
                                    y: view.bounds.maxY - self.tabBar.frame.height,
                                    width: indicatorWidth,height: indicatorHeight)
        
        let path = CGMutablePath.init()
        path.addRect(updatedBounds)
        NavigationTabController.rectShape.path = path
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("NAVIGATION TAB CONTROLLER -> TAP OPTION: \(tabBarController.selectedIndex)")
        
        updateTabbarIndicatorBySelectedTabIndex(index: tabBarController.selectedIndex)
        
        if tabBarController.selectedIndex == 0 && banderaAbout == true {
            // OBTIENE EL ARREGLO DE CONTROLADORES DEL TAB BAR
            let navigationController = self.viewControllers![0] as! UINavigationController
            // OBTIENE EL VIEW CONTROLLER INCRUSTADO EN EL NAVIGATION CONTROLLER
            let viewControllerContainer = navigationController.viewControllers[0] as! ContainerController
            // OBTIENE LA PRIMER VISTA HIJA DEL VIEW CONTROLLER
            let viewControllerHome = viewControllerContainer.children[0] as! HomeViewController
            // OBTIENE LA ULTIMA SUBVISTA DEL VIEW CONTROLLER
            let viewControllerAbout = viewControllerHome.view.subviews[viewControllerHome.view.subviews.count - 1]
            // ANIMACIÓN EN TRANSICIÓN PARA REMOVER DE LA SUPERVISTA
            UIView.transition(with: viewControllerHome.view.superview!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                // REMUEVE DE LA SUPERVISTA
                viewControllerAbout.removeFromSuperview()
                // CAMBIA EL ESTADO DE LA BANDERA
                banderaAbout = false
            }, completion: nil)
        } else if tabBarController.selectedIndex == 0 && isWebViewShowing == true {
            // OBTIENE EL ARREGLO DE CONTROLADORES DEL TAB BAR
            let navigationController = self.viewControllers![0] as! UINavigationController
            // OBTIENE EL VIEW CONTROLLER INCRUSTADO EN EL NAVIGATION CONTROLLER
            let viewControllerContainer = navigationController.viewControllers[0] as! ContainerController
            // OBTIENE LA PRIMER VISTA HIJA DEL VIEW CONTROLLER
            let viewControllerHome = viewControllerContainer.children[0] as! HomeViewController
            // OBTIENE LA ULTIMA SUBVISTA DEL VIEW CONTROLLER
            let viewControllerWebView = viewControllerHome.view.subviews[viewControllerHome.view.subviews.count - 1]
            // ANIMACIÓN EN TRANSICIÓN PARA REMOVER DE LA SUPERVISTA
            UIView.transition(with: viewControllerHome.view.superview!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                // REMUEVE DE LA SUPERVISTA
                viewControllerWebView.removeFromSuperview()
                // CAMBIA EL ESTADO DE LA BANDERA
                isWebViewShowing = false
            }, completion: nil)
        } else if tabBarController.selectedIndex == 1 && isWebViewShowing == true {
            // OBTIENE EL ARREGLO DE CONTROLADORES DEL TAB BAR
            let navigationController = self.viewControllers![1] as! UINavigationController
            // OBTIENE EL VIEW CONTROLLER INCRUSTADO EN EL NAVIGATION CONTROLLER
            let viewControllerFavorites = navigationController.viewControllers[0] as! FavoritesViewController
            // OBTIENE LA ULTIMA SUBVISTA HIJA DEL VIEW CONTROLLER
            let viewControllerWebView = viewControllerFavorites.view.subviews[viewControllerFavorites.view.subviews.count - 1]
            // REMUEVE DE LA SUPERVISTA
            viewControllerWebView.removeFromSuperview()
            // CAMBIA EL ESTADO DE LA BANDERA
            isWebViewShowing = false
        }
        
        if tabBarController.selectedIndex >= 1 && isPresenting == true {
            //ESCONDE BARRA DE SCROLL PARA EL TAB BAR
            NavigationTabController.rectShape.isHidden = false
            
            //CUANDO ABRE EL MENU SLIDE, CAMBIAMOS EL COLOR DEL ITEM DEL TAB BAR
            tabBarController.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
            
            isPresenting = false
        }
        
    }
}


//  MARK:- UIViewControllerRestoration
extension NavigationTabController: UIViewControllerRestoration{
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        
        if let storyboard = coder.decodeObject(forKey: UIApplication.stateRestorationViewControllerStoryboardKey) as? UIStoryboard {
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "MainTabID") as? NavigationTabController{
                return vc;
            }
            
        }
        
        return nil;
    }
    
}

extension UIImage {
    
    class func ImagenSelectorTabBar (color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
