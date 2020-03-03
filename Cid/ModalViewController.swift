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
    @IBOutlet weak var viewTitleModal: UIView!
    @IBOutlet weak var buttonCancelModal: UIButton!
    @IBOutlet weak var buttonAcceptModal: UIButton!
    @IBOutlet weak var switchModal: UISwitch!
    
    // MARK: - CLOSURES
    var tapAcceptModal:((Bool) -> Void)?
    
    // MARK: - LIFECYLCE VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupViews()
    }
    
    // MARK: - FUNCTIONS
    func SetupViews() {
        // MODAL
        viewModal.RoundAllCorner(radius: 17)
        
        // TITLE MODAL
        viewTitleModal.RoundTopCorner(radius: 15)
        
        // CANCEL
        buttonCancelModal.layer.cornerRadius = 8
        buttonCancelModal.layer.borderColor = UIColor(named: "TitleModal")?.cgColor
        buttonCancelModal.layer.borderWidth = 2
        
        //ACCEPT
        buttonAcceptModal.layer.cornerRadius = 8
    }
    
    // MARK: - IBACTIONS
    @IBAction func ListenerButtonInvisible(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ListenerButtonCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ListenerButtonAccept(_ sender: UIButton) {
        let isDontShow = switchModal.isOn
        self.tapAcceptModal!(isDontShow)
        dismiss(animated: true, completion: nil)
    }
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
