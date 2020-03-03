//
//  ModalViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 3/3/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    // MARK: - IBOUTLETS
    @IBOutlet weak var viewModal: UIView!
    
    // MARK: - LIFECYLCE VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - FUNCTIONS
    

}

// MARK: - EXTENSION - UIVIEW
extension UIView {
    
    func RoundTopLeftCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func RoundTopRightCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    func RoundBottomLeftCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func RoundBottomRightCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    func RoundTopCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func RoundBottomCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func RoundAllCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
