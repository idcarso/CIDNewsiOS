//
//  NewWebViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 2/4/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

class NewWebViewController: UIViewController {
    
    // MARK: - VARIABLES
    var isMenuShowing:Bool = false // TRUE = MENÚ MOSTRANDOSE | FALSE = MENÚ OCULTO
    
    // MARK: - VIEW
    var buttonInvisible = UIButton()
    
    // MARK: - CONSTRAINTS
    @IBOutlet weak var constraintTopViewContenedorMenu: NSLayoutConstraint!
    
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var progressViewCarga: UIProgressView!
    @IBOutlet weak var viewContenedorMenu: UIView!
    @IBOutlet weak var viewToast: UIView!
    
    // MARK: - LIFECYCLE VIEW CONTROLLER
    override func viewWillAppear(_ animated: Bool) {
        
        // OCULTA VISTAS CUANDO INICIA EL VIEW CONTROLLER
        progressViewCarga.isHidden = true
        viewContenedorMenu.isHidden = true
        viewToast.isHidden = true
        
        // PONE LA BANDERA EN FALSE DE QUE NO SE MUESTRA EL MENU
        isMenuShowing = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CONFIGURACIONES DE LA VISTA
        SetupStatusBar()
        SetupNavigationBar()
        
        // AÑADE EL EVENTO AL BOTÓN INVISIBLE
        buttonInvisible.addTarget(self, action: #selector(self.ButtonListenerDismissMenu(sender:)), for: .touchUpInside)
    }
    
    // MARK: - IB ACTIONS
    @IBAction func ButtonListenerRefresh(_ sender: UIButton) {
        // OCULTA LA VISTA CONTENEDOR DEL MENU, QUITA EL BOTON INVISIBLE DE LA SUPERVISTA Y CAMBIA EL ESTADO DE LA BANDERA DEL MENU
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }, completion: nil)
        isMenuShowing = false
    }
    
    @IBAction func ButtonListenerShare(_ sender: UIButton) {
        // OCULTA LA VISTA CONTENEDOR DEL MENU, QUITA EL BOTON INVISIBLE DE LA SUPERVISTA Y CAMBIA EL ESTADO DE LA BANDERA DEL MENU
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }, completion: nil)
        isMenuShowing = false
    }
    
    @IBAction func ButtonListenerCopyClipboard(_ sender: UIButton) {
        // OCULTA LA VISTA CONTENEDOR DEL MENU, QUITA EL BOTON INVISIBLE DE LA SUPERVISTA Y CAMBIA EL ESTADO DE LA BANDERA DEL MENU
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }, completion: nil)
        isMenuShowing = false
    }
    
    
    // MARK: - FUNCTIONS
    
    // CONFIGURA EL NAVIGATION BAR EN EL VIEW CONTROLLER
    func SetupNavigationBar () {
        // CONFIGURACIÓN DEL NAVIGATION BAR
        var statusBarHeight:CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("Status bar height: \(statusBarHeight)")
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: 44))
        navBar.isTranslucent = false
        navBar.barTintColor = UIColor(named: "view_aboutus")
        navBar.backgroundColor = .white
        navBar.delegate = self as? UINavigationBarDelegate
        
        self.view.addSubview(navBar)
        
        // CONFIGURACIÓN DE LA IMÁGEN PARA EL NAVIGATION BAR
        let image = UIImage(named: "logocidweb")
        let imageView = UIImageView(image: image)
        let imageWidth = navBar.frame.size.width - 10
        let imageHeight = navBar.frame.size.height - 10
        let imageX = imageWidth / 2 - (image?.size.width)! / 2
        let imageY = imageHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        imageView.contentMode = .scaleAspectFit
        
        // CONFIGURACIÓN DE LOS BOTONES PARA EL NAVIGATION BAR
        let navItem = UINavigationItem()
        navItem.titleView = imageView
        navItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.ReturnPreviousView))
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_vertical"), style: .plain, target: self, action: #selector(self.ShowMenu))
        navBar.items = [navItem]
        
    }
    
    // CONFIGURA EL FONDO DEL STATUS BAR
    func SetupStatusBar () {
        if #available(iOS 13.0, *) {
            // MEDIDA DEL STATUS BAR EN LA PANTALLA
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            // VISTA DEL MISMO COLOR QUE LA NAVIGATION BAR
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(named: "view_aboutus")
            view.addSubview(statusbarView)
          
            // CONSTRAINTS MANUALES PARA LA VISTA
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            // OBTENER LA STATUS BAR Y CAMBIAR SU FONDO
            let statusBar = UIApplication.shared.value(forKey: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "view_aboutus")
        }
    }
    
    // CONFIGURA LA ALTURA DEL VIEW CONTENEDOR MENU
    func SetupViewContenedorMenu () {
        let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        constraintTopViewContenedorMenu.constant = statusBarHeight + 42
    }
    
    // MARK: - FUNCTIONS OBJ C
    
    // REGRESA A LA VISTA ANTERIOR
    @objc func ReturnPreviousView () {
        // REMUEVE EL VIEW CONTROLLER DE LA SUPERVISTA CON ANIMACIÓN
        UIView.transition(with: self.view.superview!, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }, completion: nil)
    }
    
    // MUESTRA EL MENÚ
    @objc func ShowMenu () {
        // SI EL MENU ESTA OCULTO, LO MUESTRA, SI NO, LO OCULTA
        if isMenuShowing == false {
            UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
                self.viewContenedorMenu.isHidden = false
                self.SetupViewContenedorMenu()
                // CONFIGURA LAS MEDIDAS DEL BOTÓN INVISIBLE A LAS MEDIDAS DE LA VISTA DISPONIBLE
                self.buttonInvisible.frame = self.view.bounds
                self.view.addSubview(self.buttonInvisible)
                // TRAE AL FRENTE EL CONTENEDOR DEL MENÚ EN JERARQUÍA DE VISTAS
                self.view.bringSubviewToFront(self.viewContenedorMenu)
            }, completion: nil)
            // CAMBIA EL ESTADO DE LA BANDERA
            isMenuShowing = true
        } else {
            UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
                self.viewContenedorMenu.isHidden = true
                // REMUEVE EL BOTÓN INVISIBLE DE LA SUPERVISTA
                self.buttonInvisible.removeFromSuperview()
            }, completion: nil)
            // CAMBIA EL ESTADO DE LA BANDERA
            isMenuShowing = false
        }
    }
    
    // OCULTA EL MENÚ
    @objc func ButtonListenerDismissMenu (sender: UIButton!) {
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            // OCULTA EL CONTENEDOR DEL MENÚ
            self.viewContenedorMenu.isHidden = true
        }) {finish in
            // AL TERMINAR LA ANIMACIÓN, CAMBIA EL ESTADO DE LA BANDERA Y REMUEVE EL BOTÓN INVISIBLE DE LA SUPERVISTA
            self.isMenuShowing = false
            self.buttonInvisible.removeFromSuperview()
        }
    }
    
}
