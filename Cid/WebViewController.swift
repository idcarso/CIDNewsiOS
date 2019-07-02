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


class WebViewController: UIViewController,WKNavigationDelegate{
    
    var text1=""  //Es reemplazado el valor de text1, por la url que se mostrara
    

    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var isInAnimation = false
    
    override func viewDidLoad() {   //Este webview es utilizado por lmageTapped(Home) y ViewTableController
        var image = UIImage()
        image = (UIImage.init(named: "logocidweb")?.withRenderingMode(.alwaysOriginal))!
        let  imageAspect = (image.size.width)/(image.size.height)
        image.accessibilityFrame = CGRect(x: 100 - 15, y: 60/3, width: 60*imageAspect/2, height: 60/2)
        let cidNewsIcon = UIImageView(image: image)
        self.navigationItem.titleView = cidNewsIcon
        
        
        

        
        let backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        
        print(text1)
       // let url = URL(string: text1)
        let url = URL(string: text1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        setupEstimatedProgressObserver()
        //webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url!))  //Carga la url
        //webView.delegate = self
        //webView.load(URLRequest(url: url!))  //Carga la url
        print("WebViewController --> viewDidLoad --> progressView.setProgress")
        //progressView.setProgress(1.0, animated: true)
       // progressView.topAnchor.constraint(equalTo: webView.topAnchor, constant: 30)
        
        
        
        
        progressView.alpha = 1
        progressView.isHidden = false

        progressView.setProgress(0.1, animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)

        progressView.layoutIfNeeded()
            
        
        super.viewDidLoad()

        //progressView.setNeedsLayout()
        //Checar con el webview si existe un percent request y eso añadirlo como un #action a progressView.setProgress
    }

    @objc func returnHome (){
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }

    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            
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
            
            
            print("WebViewController --> setupEstimatedProgressObserver --> webview.progress:",webView.estimatedProgress)
        }
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
