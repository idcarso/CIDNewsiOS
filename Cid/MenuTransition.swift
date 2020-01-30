//
//  MenuTransition.swift
//  Cid
//
//  Created by Ada Palazuelos on 1/13/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import Foundation
import UIKit

/*---------- GLOBAL VARIABLES ----------*/
var isPresenting = false

class MenuTransition:NSObject, UIViewControllerAnimatedTransitioning {
    
    /*---------- VIEWS ----------*/
    let viewDegreaded = UIView()
    let buttonInvisible = UIButton()
    
    /*---------- FUNCTIONS ----------*/
    func SizeTabBar () -> CGFloat {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewControllerNavigationTab = storyboard.instantiateViewController(withIdentifier: "MainTabID") as? NavigationTabController,
            let navigationController = viewControllerNavigationTab.viewControllers?[0] as? UINavigationController,
            let viewControllerContainer = navigationController.viewControllers[0] as? ContainerController else {return 0}
        guard let heightTabBar = viewControllerContainer.tabBarController?.tabBar.frame.height else {return 0}
        return heightTabBar
    }
    
    /*---------- OVERRIDES ----------*/
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let containerView = transitionContext.containerView
        let widthFinal = toViewController.view.bounds.width * (0.8)
        let heightFinal = toViewController.view.bounds.height - SizeTabBar()
        
        let transform = {
            self.buttonInvisible.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: -widthFinal, y: 0)
        }
        
        let identity = {
            self.buttonInvisible.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        
        if isPresenting == true {
            buttonInvisible.backgroundColor = .black
            buttonInvisible.alpha = 0.0
            containerView.addSubview(buttonInvisible)
            buttonInvisible.frame = containerView.bounds
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: toViewController.view.bounds.width, y: 0, width: widthFinal, height: heightFinal)
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            if isPresenting == true {
                transform()
            } else {
                identity()
            }
        }) {(_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    
    
}
