//
//  NewWebViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 2/4/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit
import WebKit

class NewWebViewController: UIViewController {
    
    // MARK: - VARIABLES
    var isMenuShowing:Bool = false // TRUE = MENÚ MOSTRANDOSE | FALSE = MENÚ OCULTO
    var urlNew:String?
    var estimatedProgressObserver:NSKeyValueObservation?
    
    // MARK: - VIEW
    var buttonInvisible = UIButton()
    var webView:WKWebView!
    
    // MARK: - CONSTRAINTS
    @IBOutlet weak var constraintTopViewContenedorMenu: NSLayoutConstraint!
    @IBOutlet weak var constraintTopProgressViewCarga: NSLayoutConstraint!
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var progressViewCarga: UIProgressView!
    @IBOutlet weak var viewContenedorMenu: UIView!
    @IBOutlet weak var viewToast: UIView!
    
    // MARK: - LIFECYCLE VIEW CONTROLLER
    override func viewWillAppear(_ animated: Bool) {
        // CONFIGURACIONES DEL WEB VIEW
        SetupWebView()
        SetupProgressBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // CONFIGURACIONES DE LA VISTA
        SetupStatusBar()
        SetupNavigationBar()
        SetupViewContenedorMenu()
        SetupToast()
        
        
        // AÑADE EL EVENTO AL BOTÓN INVISIBLE
        buttonInvisible.addTarget(self, action: #selector(self.ButtonListenerDismissMenu(sender:)), for: .touchUpInside)
    }
    
    // MARK: - IB ACTIONS
    @IBAction func ButtonListenerRefresh(_ sender: UIButton) {
        // RECARGAR LA PÁGINA Y LA COLOCA EN LA POSICIÓN DONDE SE QUEDO ANTES DEL RERESH
        webView.reload()
        // RECARGA LA PÁGINA DESDE CERO
        //LoadNew(url: urlNew!)
        // OCULTA LA VISTA CONTENEDOR DEL MENU, QUITA EL BOTON INVISIBLE DE LA SUPERVISTA Y CAMBIA EL ESTADO DE LA BANDERA DEL MENU
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }, completion: nil)
        isMenuShowing = false
    }
    
    @IBAction func ButtonListenerShare(_ sender: UIButton) {
        // OCULTA EL CONTENEDOR DEL MENÚ, REMUEVE EL BOTÓN INVISIBLE DE LA SUPERVISTA Y AL TERMINAR, INICIA EL PROCESO DE SHARE
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: [.transitionCrossDissolve], animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }) {finish in
            // CAMBIA EL ESTADO DE LA BANDERA
            self.isMenuShowing = false
            // CONTENIDO QUE SE VA A COMPARTIR (SOLO CADENA EN ESTE CASO)
            let shareContent = "Hey look! The news I want to share with you ---> \(self.urlNew!)"
            // ACTIVITY CONTROLLER PARA SHARE, MUESTRA EL ESTADO DEL PROCESO
            let activityController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (nil, complete, _, error) in
                if complete == true {
                    print("Completado")
                } else {
                    print("Cancelado")
                }
            }
            // PRESENTA LA VENTANA DE SHARE (MISMO SISTEMA OPERATIVO)
            self.present(activityController, animated: true) {
                print("Presentado")
            }
        }
    }
    
    @IBAction func ButtonListenerCopyClipboard(_ sender: UIButton) {
        // COPIA EN EL CLIPBOARD DEL DISPOSITIVO LA URL DE LA PÁGINA DE LA NOTICIA
        UIPasteboard.general.string = urlNew!
        // OCULTA EL CONTENEDOR DEL MENÚ, REMUEVE EL BOTÓN INVISIBLE DE LA SUPERVISTA Y AL TERMINAR INICIA EL PROCESO DEL TOAST
        UIView.transition(with: viewContenedorMenu.self.superview!, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.viewContenedorMenu.isHidden = true
            self.buttonInvisible.removeFromSuperview()
        }){ finish in
            // CAMBIA EL ESTADO DE LA BANDERA
            self.isMenuShowing = false
            // MUESTRA EL TOAST
            UIView.transition(with: self.viewToast.self.superview!, duration: 0.15, options: .transitionCrossDissolve, animations: {
                self.viewToast.isHidden = false
                self.view.bringSubviewToFront(self.viewToast)
            })
            // LO MANTIENE VISIBLE CON UNA TAREA ASINCRONA
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                // OCULTA EL TOAST
                UIView.transition(with: self.viewToast.superview!, duration: 0.15, options: .transitionCrossDissolve, animations: {
                    self.viewToast.isHidden = true
                }, completion: nil)
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    // FUNCIÓN QUE CARGA LA NOTICIA EN EL WEB VIEW
    func LoadNew (url:String) -> Void {
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
    // FUNCION QUE DEVUELVE EL VALOR AL PROGRESS VIEW PARA MOSTRAR LA CARGA DE LA PÁGINA
    func SetupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressViewCarga.progress = Float(webView.estimatedProgress)
        }
    }
    
    // MARK: - FUNCTIONS (SETUP)
    
    // CONFIGURA EL NAVIGATION BAR EN EL VIEW CONTROLLER
    func SetupNavigationBar () {
        // CONFIGURACIÓN DEL NAVIGATION BAR
        var statusBarHeight:CGFloat = 0
        statusBarHeight = UIApplication.shared.statusBarFrame.height
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
            print("Entro en el else status bar")
            let statusBar = UIApplication.shared.value(forKey: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "view_aboutus")
        }
    }
    
    //CONFIGURA EL CONTENEDOR DEL MENU
    func SetupViewContenedorMenu () {
        constraintTopViewContenedorMenu.constant = constraintTopViewContenedorMenu.constant - 2
    }
    
    // CONFIGURA EL WEB VIEW EN EL VIEW CONTROLLER
    func SetupWebView () {
        // MEDIDAS DEL STATUS BAR
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let webViewY = statusBarHeight + 44
        
        // MEDIDAS DEL TAB BAR
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else { return }
        let webViewHeight = self.view.frame.height - (tabBarHeight + webViewY)
        
        // CONFIGURACION WEB VIEW
        let webViewPreferences = WKPreferences()
        webViewPreferences.javaScriptEnabled = true
        webViewPreferences.javaScriptCanOpenWindowsAutomatically = true
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences = webViewPreferences
        
        // MEDIDAS WEB VIEW
        webView = WKWebView(frame: CGRect(x: 0, y: webViewY, width: self.view.frame.width, height: webViewHeight + 1), configuration: webViewConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //DELEGAMOS LA CLASE WEB VIEW
        webView.navigationDelegate = self
        
        // AGREGAR EL WEB VIEW A LA SUPERVISTA
        view.addSubview(webView)
        
        // CARGA LA NOTICIA
        LoadNew(url: self.urlNew!)
        SetupEstimatedProgressObserver()
    }
    
    // CONFIGURA EL TOAST EN EL VIEW CONTROLLER
    func SetupToast () {
        // ESTILO DEL TOAST (VIEW CON LABEL)
        viewToast.isHidden = true
        viewToast.layer.cornerRadius = viewToast.bounds.height / 4
        viewToast.layer.shadowOpacity = 0.5
        viewToast.layer.shadowRadius = 1
    }
    
    // CONFIGURA EL PROGRESS VIEW EN EL VIEW CONTROLLER
    func SetupProgressBar () {
        progressViewCarga.isHidden = true
        let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        constraintTopProgressViewCarga.constant = statusBarHeight + 44
        self.view.bringSubviewToFront(progressViewCarga)
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

// MARK: - DELEGATE WEB VIEW
extension NewWebViewController:WKNavigationDelegate {
    
    // MARK: - FUNCTIONS (DELEGATE WEB VIEW)
    
    // FUNCION QUE NOTIFICA CUANDO INICIA LA NAVEGACIÓN
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if progressViewCarga.isHidden == true {
            progressViewCarga.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.progressViewCarga.alpha = 1.0
        })
    }
    
    // FUNCION QUE NOTIFICA CUANDO LA NAVEGACIÓN TERMINA
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.progressViewCarga.alpha = 0.0
        }, completion: { isFinished in
            self.progressViewCarga.isHidden = isFinished
        })
    }
    
}
