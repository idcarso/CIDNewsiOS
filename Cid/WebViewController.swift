//
//  WebViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 18/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import Foundation
import UIKit
import WebKit


class WebViewController: UIViewController,WKNavigationDelegate,UIScrollViewDelegate{
    
    var text1=""  //Es reemplazado el valor de text1, por la url que se mostrara
    @IBOutlet weak var webView: UIView!
    
    @IBOutlet var menuOptions: [UIButton]!
    
    @IBOutlet weak var bottomConstraintMenu: NSLayoutConstraint!
    @IBOutlet var WebNewsView: UIView!
    @IBOutlet weak var insideWebView: UIView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func actionRefresh(_ sender: Any) {
        if mWebView.isLoading {
            mWebView.stopLoading()
        }
        mWebView.reloadFromOrigin()
        progressView.alpha = 1
        progressView.isHidden = false

        
        if !insideWebView.isHidden {
            RecursiveButtonHide()
        }
    }
    
    @IBAction func actionShare(_ sender: Any) {
        
        let activityController  = UIActivityViewController(activityItems:[text1],applicationActivities:nil)
        activityController.completionWithItemsHandler = { (nil,completed,_,_error) in if(completed){
            print("shareFab Completed!")
        }else{
            print("shareFab Canceled")
            }
        }
        present(activityController,animated:true){
            print("shareFab Presented")
        }
        if !insideWebView.isHidden {
            RecursiveButtonHide()
        }
        
    }
    @IBAction func actionCopyLink(_ sender: Any) {
        UIPasteboard.general.string = text1
        if !insideWebView.isHidden {
            RecursiveButtonHide()
        }
    }
    
    
    
    var mWebView = WKWebView()
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var isInAnimation = false
    private var progressWebViewScroll = 0
    private var showStatusBar = true
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    override var prefersStatusBarHidden: Bool{
        return !showStatusBar
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor =  UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        
    }
    
 
    override func viewDidLoad() {   //Este webview es utilizado por lmageTapped(Home) y FavoritesVTController
        super.viewDidLoad()
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        
        var image = UIImage()
        image = (UIImage.init(named: "logocidweb")?.withRenderingMode(.alwaysOriginal))!
        let  imageAspect = (image.size.width)/(image.size.height)
        image.accessibilityFrame = CGRect(x: 100 - 15, y: 60/3, width: 60*imageAspect/2, height: 60/2)
        let cidNewsIcon = UIImageView(image: image)
        self.navigationItem.titleView = cidNewsIcon
        
        insideWebView.isHidden = true
        self.bottomConstraintMenu.constant =  self.view.frame.size.height
        
        // RIGHT BAR BUTTON ITEM (NAVIGATION ITEM)
        let filterButton = UIButton()
        //set image for button
        filterButton.setImage(UIImage(named: "ic_menu_ver"), for: UIControl.State.normal)
        filterButton.addTarget(self, action: #selector(self.showMenuOptional), for: .touchUpInside)
        //set frame
        filterButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 15)
        filterButton.contentMode = .scaleAspectFit
        let barButton = UIBarButtonItem(customView: filterButton)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        //let rightItem = UIBarButtonItem(image: UIImage(named: "ic_menu_vertical"), style: .plain,target: self,action:  #selector(self.showMenuOptional))
       // self.navigationItem.rightBarButtonItem = rightItem

        

        // LEFT BAR BUTTON ITEM (NAVIGATION ITEM)
        let backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        
        print(text1)
       // let url = URL(string: text1)
        let url = URL(string: text1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        
        
        //webView.uiDelegate = self
        
        let configuration = WKWebViewConfiguration()
        //configuration.allowsInlineMediaPlayback = false
        configuration.mediaTypesRequiringUserActionForPlayback = .video
        
        mWebView =  WKWebView(frame: self.view.frame, configuration: configuration)
        mWebView.navigationDelegate = self
        self.mWebView.scrollView.delegate = self

        self.webView.addSubview(mWebView)
        mWebView.load(URLRequest(url: url!))  //Carga la url
        //webView.delegate = self
        //webView.load(URLRequest(url: url!))  //Carga la url
        print("WebViewController --> viewDidLoad --> progressView.setProgress")
        //progressView.setProgress(1.0, animated: true)
       // progressView.topAnchor.constraint(equalTo: webView.topAnchor, constant: 30)
        
        
        setupEstimatedProgressObserver()

        
        progressView.alpha = 1
        progressView.isHidden = false

        progressView.setProgress(0.1, animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)

        progressView.layoutIfNeeded()

        //progressView.setNeedsLayout()
        //Checar con el webview si existe un percent request y eso añadirlo como un #action a progressView.setProgress
    }

    
    
   

    
    @objc func returnHome (){
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func showMenuOptional(){
        print("showMenuOptional -->  Tapped")
        //WebNewsView.bringSubviewToFront(insideWebView)
        
        if insideWebView.isHidden{   //Show MenuFilter
            RecursiveButtonShow()
            
        }else{                          //Hide MenuFilter
            RecursiveButtonHide()
        }

        
       
    }
    
    
    ///////////////////////////////////////////////                     MENU
    func RecursiveButtonHide(){
        UIView.animate(withDuration: 0.2, animations: {
            self.insideWebView.backgroundColor = UIColor.clear
            self.bottomConstraintMenu.constant =  self.view.frame.size.height
            self.view.layoutIfNeeded()
        }, completion:{(finished:Bool) in
            self.view.layoutIfNeeded()
            self.insideWebView.isHidden=true
        })
    }
    
    ///////////////////////////////////////////////
    func RecursiveButtonShow(){
        
        UIView.animate(withDuration: 0.17, animations: {
            self.insideWebView.isHidden=false
            self.insideWebView.backgroundColor = UIColor.init(red: 0, green: 55/255, blue: 111/255, alpha: 1)
            self.bottomConstraintMenu.constant =  self.view.frame.size.height*(2/3)
            self.view.layoutIfNeeded()
            
        }, completion:{(finished:Bool) in
            self.insideWebView.isHidden=false
            self.view.layoutIfNeeded()
        })
        
        
        
        UIView.animate(withDuration: 0.1, animations: {
            self.menuOptions[0].isHidden = false
        })
        UIView.animate(withDuration: 0.133, animations: {
            self.menuOptions[1].isHidden = false
        })
        UIView.animate(withDuration: 0.166, animations: {
            self.menuOptions[2].isHidden = false
        })
    }

    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = mWebView.observe(\.estimatedProgress, options: [.new]) { [weak self] mWebView, _ in
            self?.progressView.setProgress(Float(mWebView.estimatedProgress), animated: true)
            
            if !((self?.progressView.isHidden)!) && !self!.isInAnimation{
                if self?.progressView.progress == 1.0 {
                    self?.isInAnimation = true
                    UIView.animate(withDuration: 1, animations: {
                        self?.progressView.alpha = 0
                    },completion: {
                        (finished:Bool) in
                        self?.progressView.isHidden = true
                        self?.progressView.alpha = 1
                        self?.isInAnimation = false
                    })
                }
            }
                //= Float(webView.estimatedProgress)
            print("WebViewController --> setupEstimatedProgressObserver --> mWebview.progress:",mWebView.estimatedProgress)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("WebViewController --> scrolling now..")
        print("WebViewController --> y:",scrollView.contentOffset.y)

        if mWebView != nil {
            if mWebView.estimatedProgress > 0.5 {
                
                if Int(scrollView.contentOffset.y) > 0 {
                    if progressWebViewScroll == 0 {
                        progressWebViewScroll = Int(scrollView.contentOffset.y)
                    }else{
                        if progressWebViewScroll - Int(scrollView.contentOffset.y) > 4 { //Muestra Barra
                            if navigationController != nil{
                                if navigationController!.isNavigationBarHidden {
                                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                                    showStatusBar = true
                                    animateStatusBar()
                                }
                            }
                        }
                        
                        if progressWebViewScroll - Int(scrollView.contentOffset.y) < -4 {
                         //Hide NavigationController
                            if navigationController != nil {
                                if !navigationController!.isNavigationBarHidden {
                                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                                    showStatusBar = false
                                    animateStatusBar()
                                    if !insideWebView.isHidden {
                                        RecursiveButtonHide()
                                    }
                                }
                            }
                        }
                        progressWebViewScroll = Int(scrollView.contentOffset.y)
                    }
                }
            }
        }
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: {(finished:Bool) in
            
            if !self.showStatusBar && self.mWebView.estimatedProgress != 1{
                self.progressView.isHidden = true
            }
            
            if self.showStatusBar &&  self.mWebView.estimatedProgress != 1{
                self.progressView.isHidden = false
            }
        })
    }
    
   
    /*
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("WebViewController --> webViewDidStartLoad -->")
        self.progressView.setProgress(0.1, animated: false)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("WebViewController --> webViewDidFinishLoad -->")

        self.progressView.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("WebViewController --> didFailLoadWithError -->")

        self.progressView.setProgress(1.0, animated: true)
    }*/
}

/*
 backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
 self.navigationItem.leftBarButtonItem = backItem
 
 */
