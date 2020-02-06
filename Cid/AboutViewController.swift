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
    override func viewWillAppear(_ animated: Bool) {
        // REALIZA LOS AJUSTES DE LA VISTA
        AjustesViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CAMBIA EL ESTADO DE LA BANDERA
        banderaAbout = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // MUESTRA LA BARRA DE SCROLL EN EL TAB BAR
        NavigationTabController.rectShape.isHidden = false
        
        // CAMBIA DE COLOR EL ICONO EN EL TAB BAR (HOME)
        self.tabBarController!.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
        
        // REMUEVE LA VISTA DE LA SUPERVISTA
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        // CAMBIA EL ESTADO DE LA BANDERA
        banderaAbout = false
        
    }
    
    // MARK: - IB ACTIONS
    @IBAction func ListenerButtonRegresar(_ sender: UIButton) {
        //  MUESTRA EL SCROLL DEL TAB BAR
        NavigationTabController.rectShape.isHidden = false
        
        // CAMBIA EL COLOR DEL ICONO EN EL TAB BAR (HOME)
        tabBarController!.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
        
        // *EL EFECTO SE HACE SOBRE LA SUPERVISTA YA QUE ESTA CLASE ACTUA COMO HIJO.
        UIView.transition(with: self.view.superview!, duration: 0.7, options: [.transitionCrossDissolve], animations: {
            // REMUEVE LA VISTA DE LA SUPERVISTA
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            // CAMBIA EL ESTADO DE LA BANDERA
            banderaAbout = false
        }, completion: nil)
    }
    
    // MARK: - FUNCTIONS
    
    // FUNCIÓN QUE AJUSTA LOS CONSTRAINTS DE LA VISTA PARA DISPOSITIVOS PEQUEÑOS
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
