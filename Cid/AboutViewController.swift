//
//  AboutViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 10/21/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//

import UIKit

/****ATRIBUTOS GLOBALES******/
var banderaAbout:Bool!

class AboutViewController: UIViewController {
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var ConstraintTopLabelWhat: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTopViewAzul: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHeightImageView: NSLayoutConstraint!
    @IBOutlet weak var ConstraintWidthImageView: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTopButton: NSLayoutConstraint!
    @IBOutlet weak var ConstraintLeadingButton: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTopLabelCID: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTopLabelDescripcion: NSLayoutConstraint!
    
    
    // MARK: - LIFECYCLE VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        //ACTIVAMOS LA BANDERA DE ACTIVO DEL VIEW CONTROLLER
        banderaAbout = true
        AjustesViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //ESCONDE BARRA DE SCROLL PARA EL TAB BAR
        NavigationTabController.rectShape.isHidden = false
        
        //CUANDO ABRE EL MENU SLIDE, CAMBIAMOS EL COLOR DEL ITEM DEL TAB BAR
        self.tabBarController!.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        banderaAbout = false
        
    }
    
    // MARK: - IB ACTIONS
    @IBAction func ListenerButtonRegresar(_ sender: UIButton) {
        
        //MOSTRAMOS EL SCROLL DEL TAB BAR CONTROLLER
        NavigationTabController.rectShape.isHidden = false
        
        //CAMBIAMOS DE COLOR DEL ITEM SELECCIONADO DEL TAB BAR CONTROLLER
        tabBarController!.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
        
        //EL EFECTO SE HACE SOBRE LA SUPER VISTA YA QUE ESTA CLASE ACTUA COMO HIJO.
        UIView.transition(with: self.view.superview!, duration: 0.7, options: [.transitionCrossDissolve], animations: {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            banderaAbout = false
        }, completion: nil)
    }
    
    // MARK: - FUNCTIONS
    //FUNCION PARA SABER EL TAMAÑO DE LA PANTALLA DEL IPHONE
    func AjustesViews () {
        if UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //IPHONE SE
                ConstraintTopLabelWhat.constant = 50
                ConstraintTopButton.constant = 24
                ConstraintLeadingButton.constant = 16
                ConstraintHeightImageView.constant = 100
                ConstraintWidthImageView.constant = 200
                ConstraintTopViewAzul.constant = 310
                ConstraintTopLabelCID.constant = 30
                ConstraintTopLabelDescripcion.constant = 20
            case 1334:
                //IPHONE 6S, 7, 8
                break
            case 2208:
                //IPHONE 6S PLUS, 7 PLUS, 8 PLUS
                break
            case 2436:
                //IPHONE X, XS
                break
            case 1792:
                //IPHONE XR
                break
            case 2688:
                //IPHONE XS MAX
                break
            default:
                print("No se pudo detectar la pantalla")
            }
        }
    }
    
}
