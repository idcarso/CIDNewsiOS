//
//

let THERESOLD_MARGIN = (UIScreen.main.bounds.size.width/2) * 0.35//0.75(Ori2018),0.2(Feb2019)
let SCALE_STRENGTH : CGFloat = 4
let SCALE_RANGE : CGFloat = 0.90

import UIKit
import WebKit

protocol TinderCardDelegate: NSObjectProtocol {
    
    func cardGoesLeft(card: TinderCard)
    func cardGoesRight(card: TinderCard)
    func currentCardStatus(card: TinderCard, distance: CGFloat)
    func movingScrollBar(initialDistance: Float,currentDistance: Float)
    
    //func scrollviewScrolling(scroll: UIScrollView)
}
class TinderCard: UIView,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate {
    weak var delegate: TinderCardDelegate?
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    var attributedText = NSMutableAttributedString(string: "")
    var dataVal = NSMutableData()

    
    //Views
    var webViewCard = WKWebView()
    var progressViewCard = UIProgressView(progressViewStyle: .default)
    var backGroundImageView = UIImageView()
    var DegradadoImageView = UIImageView()
    var defaulCardImageView =  UIImageView()
    var scrollViewCard = UIScrollView()
    var customBar = UIView()
    var shareFabButton =  UIButton(type: .custom)
    var facebookFabButton =  UIButton(type: .custom)
    var whatsappFabButton =  UIButton(type: .custom)
    var labelTextAutor = UILabel()
    var labelText =  UILabel()
    
    //String
    var textUrl = ""
    
    
    //Float
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var xCoordLabel: CGFloat = 0.0
    var yCoordLabel: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    
    //Boolean
    var isLiked = false
    var isFabOpen = false
    var flagScroll = false
    var flagSwipe = false
    var flagMoving = false
    private var isInAnimation = false

    

    public init(frame: CGRect, value: Int, list: Array<Noticias>) {
        super.init(frame: frame)
        //self.scrollViewCard.delegate = self
        print("TinderCard --> init Setup")
        
        setupView(at: value,list: list)             //Inicia configuracion
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("TinderCard --> init Error")
        fatalError("init(coder:) has not been implemented")
    }
////////////////////////////////
    func setupView(at value:Int,list: Array<Noticias>) {  //Inicia configuracion con el arreglo de noticias (list)
        print("TinderCard --> setupView")


        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
       /* let customRect = CGRect.init(x: Int(screenWidth - screenWidth/12),y:Int(0),
                                     width: 100,
                                     height: 50)*/
        
        // y:Int(screenHeight/20),

        
        
        layer.cornerRadius = 20
        layer.borderWidth = 0.1
        let myColor = UIColor.darkGray
        layer.borderColor = myColor.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0.5, height: 0)
        layer.shadowColor = UIColor.white.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = false
        originalPoint = center

        print("TinderCard --> setupView --> addGestureRecognizer")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))  //Utilizado cuando es arrastrado el TinderCard
        self.addGestureRecognizer(panGestureRecognizer)
        //////////////
        // add the scroll view to self.view
        // constrain the scroll view to 8-pts on each side
       /* scrollViewCard.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
        scrollViewCard.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        scrollViewCard.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0).isActive = true
        scrollViewCard.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18.0).isActive = true
        */
       
        
        print("TinderCard --> setupView --> addGestureRecognizer")

        scrollViewCard = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollViewCard.contentSize = CGSize(width: screenWidth, height: screenHeight*3)
        scrollViewCard.isScrollEnabled = true
        scrollViewCard.backgroundColor = UIColor.white

        DegradadoImageView = UIImageView(frame: self.bounds)
        
        
        DegradadoImageView.image = UIImage.animatedImage(with: [#imageLiteral(resourceName: "Rect_Degradado")], duration: 1)  //Imagen para hacer el degradado
        DegradadoImageView.contentMode = .scaleToFill
        DegradadoImageView.clipsToBounds = true
        
        defaulCardImageView = UIImageView(frame: self.bounds)
        defaulCardImageView.image = UIImage.animatedImage(with: [#imageLiteral(resourceName: "tarjetaDefault")], duration: 1)  //Imagen para hacer el degradado
        defaulCardImageView.contentMode = .scaleToFill
        defaulCardImageView.clipsToBounds = true
        ////////////
        xCoordLabel = frame.size.width/20
        yCoordLabel = frame.size.height - frame.size.height/4
        labelText = UILabel(frame:CGRect(x: xCoordLabel/2, y: yCoordLabel , width: frame.size.width-xCoordLabel-65 , height: frame.size.height/8))  //configuracion del titulo de la noticia(label)
         labelTextAutor = UILabel(frame:CGRect(x: -xCoordLabel, y: yCoordLabel+frame.size.height/8,width: frame.size.width-xCoordLabel-65, height: frame.size.height/10 )) //configuracion del autor(label)
        print("TinderCard --> setupView --> add text in title")
        //DispatchQueue.main.asyncAfter(deadline: .now() ) { // Despues de hacer tap, va al menu Home
        self.attributedText = NSMutableAttributedString(string: list[value-1].title)
        self.labelText.attributedText = self.attributedText  //asigna el texto(titulo)
      //  }
        labelText.numberOfLines = 3
        labelText.textColor = .white
        labelText.textAlignment = .center
        labelText.font = UIFont.init(name: "Montserrat-Medium", size: 16)
        labelText.adjustsFontForContentSizeCategory = true
        ///////
        
      //  DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.5) {
            // Some background work here
            print("TinderCard --> setupView -->  autor")
            self.attributedText  = NSMutableAttributedString(string: "\(list[value-1].autor) ")  //asigna el texto(autor)
            self.labelTextAutor.attributedText = self.attributedText

       // }
        
        
      /*  DispatchQueue.asyncAfter(deadline: .now() ) { // Despues de hacer tap, va al menu Home
            self.attributedText  = NSMutableAttributedString(string: "\(list[value-1].autor) ")  //asigna el texto(autor)
            self.labelTextAutor.attributedText = self.attributedText
        }*/
        /*let customRect = CGRect.init(x: Int(110), y: 0, width: 10, height: 50)
        let customBar = UIView.init(frame:customRect)
        customBar.backgroundColor = UIColor.yellow*/
        
        labelTextAutor.numberOfLines = 1
        labelTextAutor.textColor = .white
        labelTextAutor.textAlignment = .right
        labelTextAutor.font = UIFont.init(name: "Montserrat-Medium", size: 16)
        
        backGroundImageView = UIImageView(frame:self.bounds)

        
        get_image(list[value-1].urlToImg, backGroundImageView)
        
        
        print("TinderCard --> setupView --> loadCardsIMAGE:",value-1)
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true;
        
        
        /////////////
    /*        self.addSubview(self.defaulCardImageView)
            self.addSubview(self.backGroundImageView)//añade primero la imagen obtenida de la urlToImage, despues el degradado, y al final los textos
            self.addSubview(self.DegradadoImageView)
            self.addSubview(self.labelText)
            self.addSubview(self.labelTextAutor)*/
        
        
        
      //  self.addSubview(self.shareFabButton)
       // self.addSubview(self.facebookFabButton)
        //self.addSubview(self.whatsappFabButton)
       // setupShareFabButton()
       // setupFacebookFabButton()
       // setupWhatsappFabButton()



            print("TinderCard --> setupView --> add Subviews TextAutor \n")
       
        var heightWebView = frame.size.height*4
        var initWeb = fabsf(0)
            
        var rectWeb = CGRect.init(x: CGFloat(initWeb), y: frame.size.height, width: frame.size.width, height: heightWebView)
        
        var rectProgress = CGRect.init(x: CGFloat(initWeb)
            ,y: frame.size.height
            ,width:frame.size.width
            ,height: frame.size.height/10)
        
        webViewCard =  WKWebView(frame: rectWeb)
        

        setupEstimatedProgressObserver()

        webViewCard.backgroundColor = UIColor.white
        webViewCard.navigationDelegate = self

        progressViewCard = UIProgressView(frame: rectProgress)
        progressViewCard.transform = progressViewCard.transform.scaledBy(x: 1, y: 3)

        
        progressViewCard.progressTintColor = UIColor.init(red: 51/255, green: 1, blue: 51/255, alpha: 1)
        progressViewCard.trackTintColor = UIColor.init(red: 90/255, green: 93/255, blue: 90/255, alpha: 1)
        progressViewCard.backgroundColor = UIColor.black
        //progressViewCard.setProgress(0.5, animated: true)
        scrollViewCard.showsVerticalScrollIndicator = true
        scrollViewCard.delegate = self
        textUrl = list[value-1].url
        
        //OS_dispatch_queue_main.main.asyncAfter(deadline: .now()+0.1) {
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                print("TinderCard  --> setupView --> DispatchQueue.main.asyncAfter -- scrollViewCard.addSubviews")
                self.scrollViewCard.addSubview(self.defaulCardImageView)
                self.scrollViewCard.addSubview(self.backGroundImageView)
                self.scrollViewCard.addSubview(self.DegradadoImageView)
                self.scrollViewCard.addSubview(self.labelText)
                self.scrollViewCard.addSubview(self.labelTextAutor)
                self.scrollViewCard.addSubview(self.webViewCard)
                self.scrollViewCard.addSubview(self.progressViewCard)
              
                self.addSubview(self.scrollViewCard)
            }
        }
    }
    
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webViewCard.observe(\.estimatedProgress, options: [.new]) { [weak self] webViewCard, _ in
            self?.progressViewCard.setProgress(Float(webViewCard.estimatedProgress), animated: true)
            
            
            if !((self?.progressViewCard.isHidden)!) && !self!.isInAnimation{
                if self?.progressViewCard.progress == 1.0 {
                    self?.isInAnimation = true
                    UIView.animate(withDuration: 1, animations: {
                        self?.progressViewCard.alpha = 0
                    },completion: {
                        (finished:Bool) in
                        self?.progressViewCard.isHidden = true
                        self?.progressViewCard.alpha = 1
                        self?.isInAnimation = false
                        
                        /*var heightWebView = webViewCard.content
                        var initWeb = fabsf(0)
                        
                        var rectWeb = CGRect.init(x: CGFloat(initWeb), y: frame.size.height, width: frame.size.width, height: heightWebView)
                        webViewCard.frame = Cframe*/
                    })
                }
            }
            //= Float(webView.estimatedProgress)
            
            
            print("TinderCard --> setupEstimatedProgressObserver --> webviewCard.progress:",webViewCard.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webViewCard.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webViewCard.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("TinderCard --> webView --> document.readyState --> Height:",height as! CGFloat)
                    
                    print("TinderCard --> webView --> document.readyState --> webViewCard.Height(Before):",self.webViewCard.frame.size.height)
                    print("TinderCard --> webView --> document.readyState --> scrollViewCard.Height(Before):",self.scrollViewCard.frame.size.height)
                    print("TinderCard --> webView --> document.readyState --> self.Height(Before):",self.frame.size.height)
                    
                    //webViewCard
                    var mFrameRect:CGRect = self.webViewCard.frame
                    mFrameRect.size.height = height as! CGFloat
                    self.webViewCard.frame = mFrameRect
                    
                    //ScrollViewCard
                    var mCGSizeFrame = self.scrollViewCard.contentSize
                    
                    self.scrollViewCard.contentSize = CGSize(width: mCGSizeFrame.width, height: height as! CGFloat)

                    
                    
                    //self
                    /*
                    mFrameRect = self.frame
                    mFrameRect.size.height += height as! CGFloat
                    self.frame = mFrameRect*/
                    
                    
                    /*self.scrollViewCard.layoutSubviews()
                    self.layoutIfNeeded()
                    
                    self.scrollViewCard.layoutIfNeeded()
                    //self.containerHeight.constant = height as! CGFloat
                     */
                    
                   
                   /*
                    self.webViewCard.setNeedsUpdateConstraints()
                    self.webViewCard.updateConstraintsIfNeeded()
                    self.webViewCard.setNeedsLayout()
                    self.webViewCard.layoutIfNeeded()
                    
                    
                    self.scrollViewCard.setNeedsUpdateConstraints()
                    self.scrollViewCard.updateConstraintsIfNeeded()
                    self.scrollViewCard.setNeedsLayout()
                    self.scrollViewCard.layoutIfNeeded()
                    
                    self.setNeedsUpdateConstraints()
                    self.updateConstraintsIfNeeded()
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
 
 */
                    /*
                   self.webViewCard.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    self.scrollViewCard.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    
                    self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    
                    
                    self.scrollViewCard.layoutSubviews()
                    self.layoutSubviews()
 */
                    
                    print("TinderCard --> webView --> document.readyState --> webViewCard.Height(After):",self.webViewCard.frame.size.height)
                    print("TinderCard --> webView --> document.readyState --> scrollViewCard.Height(After):",self.scrollViewCard.frame.size.height)
                    print("TinderCard --> webView --> document.readyState --> self.Height(After):",self.frame.size.height)
                    
                    
                })
            }
            
        })
    }
    
    
    
    func scrollViewDidScroll(_ scrollViewCard: UIScrollView) {
        print("scrolling now..")
        print("scroll position:",scrollViewCard.contentOffset.y)
        let screensize: CGRect = UIScreen.main.bounds
        let screenHeight = screensize.height
        let distanceCustomBar = scrollViewCard.contentSize.height -  screenHeight
        print("scroll distanceCustomBar:",distanceCustomBar)
        //El valor de contentOffset ponerselo al UISlider
        if textUrl != ""{
            print("Loading first time?")
            let url = URL(string: textUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            webViewCard.load(URLRequest(url: url!))  //Carga la url
            webViewCard.scrollView.isScrollEnabled = false
            textUrl = ""
        }else{
            print("Trying to load again?")
        }
        self.delegate?.movingScrollBar(initialDistance: Float(distanceCustomBar), currentDistance:Float(scrollViewCard.contentOffset.y))
    }
    
    
    
    
    ////////////////////////////////
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        
        switch gestureRecognizer.state {
        case .began:                         // Cuando empieza a realizar el Swipe
            originalPoint = self.center;
            print("TinderCard, beingDragged, originalPoint:",originalPoint)

            break;
        case .changed:                      //Cuando va realizando el Swipe
            
            print("TinderCard, beingDragged, xCenter:",xCenter)
            print("TinderCard, beingDragged, yCenter:",yCenter)
            if !flagMoving{
                if abs(xCenter) > abs(3*yCenter)  {
                    // flagScroll = false
                    flagSwipe = true
                    flagMoving = true
                }
                if abs(yCenter) > abs(3*xCenter){
                    //flagScroll = true
                    flagSwipe = false
                    flagMoving = true
                }
            }
           // if !(flagScroll&&flagSwipe){
            if (flagSwipe){

                let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
                let rotationAngel = .pi/8 * rotationStrength
                print("TinderCard, beingDragged, rotationAngel:",rotationAngel)
                let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
                center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
                print("TinderCard, beingDragged, center:",center)
                print("TinderCard, beingDragged, xCenter:",xCenter)
                print("TinderCard, beingDragged, yCenter:",yCenter)
                

                
                let transforms = CGAffineTransform(rotationAngle: rotationAngel)
                let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
                self.transform = scaleTransform
                updateOverlay(xCenter)
            }
            
            break;
        case .ended:
            //Cuando ya realizo el Swipe o Movimiento
            flagMoving = false
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:
            print("Cancelado")
            break;
        case .failed:break
        }
    }
    func updateOverlay(_ distance: CGFloat) {
        delegate?.currentCardStatus(card: self, distance: distance)
    }
////////////////////////////////
    func afterSwipeAction() {               //Se decide donde fue la accion, izquierda o derecha
        if xCenter > THERESOLD_MARGIN {
            rightAction()
        }
        else if xCenter < -THERESOLD_MARGIN {
            leftAction()
        }
        else {                                  //Hace un reset en la imagen
            
            print("TinderCard --> afterSwipeAction animate")
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                 self.delegate?.currentCardStatus(card: self, distance:0)
            })
        }
    }
////////////////////////////////
    func rightAction() {                            //Guarda la noticia, y remueve la vista del superview
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        print("TinderCard --> rightAction animate")

        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
        
        webViewCard.stopLoading()
        webViewCard.removeFromSuperview()
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT")
        //Guardar en la base de datos
    }
////////////////////////////////
    func leftAction() {
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        
        print("TinderCard --> leftAction animate")
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
        
        webViewCard.stopLoading()
        webViewCard.removeFromSuperview()
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT")
        //Eliminar
    }
    
    
    /*
////////////////////////////////
    func makeUndoAction() {                         //Realiza el accion Deshacer
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
        self.center = self.originalPoint
        self.transform = CGAffineTransform(rotationAngle: 0)
        })
        print("WATCHOUT UNDO ACTION")
    }
////////////////////////////////
    func rollBackCard(){
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()}
    }
//////////////////////////////////////////////
    func setupShareFabButton() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        shareFabButton.layer.cornerRadius = shareFabButton.layer.frame.size.width/2
        shareFabButton.clipsToBounds = true
        shareFabButton.setImage(UIImage(named: "sharemainfab"), for: .normal)
        shareFabButton.translatesAutoresizingMaskIntoConstraints = false
        shareFabButton.addTarget(self, action: #selector(animationFab), for: .touchUpInside)
        NSLayoutConstraint.activate([
            shareFabButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            shareFabButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -70),
            shareFabButton.widthAnchor.constraint(equalToConstant: 50),
            shareFabButton.heightAnchor.constraint(equalToConstant: 50)])
        shareFabButton.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shareFabButton.layer.shadowOffset = CGSize(width: 0, height:  6)
        shareFabButton.layer.shadowOpacity = 0.5
        shareFabButton.layer.shadowRadius = 5
        shareFabButton.layer.masksToBounds = false
        self.layoutIfNeeded()
    }
    //////////////////////////////////////////////
    func setupFacebookFabButton() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        facebookFabButton.layer.cornerRadius = facebookFabButton.layer.frame.size.width/2
        facebookFabButton.clipsToBounds = true
        facebookFabButton.setImage(UIImage(named: "ic_trash_pink"), for: .normal)
        facebookFabButton.translatesAutoresizingMaskIntoConstraints = false
        facebookFabButton.addTarget(self, action: #selector(facebookFabAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            facebookFabButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            facebookFabButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -120),
            facebookFabButton.widthAnchor.constraint(equalToConstant: 50),
            facebookFabButton.heightAnchor.constraint(equalToConstant: 50)])
        facebookFabButton.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        facebookFabButton.layer.shadowOffset = CGSize(width: 0, height:  6)
        facebookFabButton.layer.shadowOpacity = 0.5
        facebookFabButton.layer.shadowRadius = 5
        facebookFabButton.layer.masksToBounds = false
        facebookFabButton.isHidden = true
        self.layoutIfNeeded()
    }
    
        //////////////////////////////////////////////
    func setupWhatsappFabButton() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        whatsappFabButton.layer.cornerRadius = whatsappFabButton.layer.frame.size.width/2
        whatsappFabButton.clipsToBounds = true
        whatsappFabButton.setImage(UIImage(named: "ic_phoneandroid"), for: .normal)
        whatsappFabButton.translatesAutoresizingMaskIntoConstraints = false
        whatsappFabButton.addTarget(self, action: #selector(whatsappFabAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            whatsappFabButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            whatsappFabButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -170),
            whatsappFabButton.widthAnchor.constraint(equalToConstant: 50),
            whatsappFabButton.heightAnchor.constraint(equalToConstant: 50)])
        whatsappFabButton.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        whatsappFabButton.layer.shadowOffset = CGSize(width: 0, height:  6)
        whatsappFabButton.layer.shadowOpacity = 0.5
        whatsappFabButton.layer.shadowRadius = 5
        whatsappFabButton.layer.masksToBounds = false
        whatsappFabButton.isHidden = true
        self.layoutIfNeeded()
    }


    
////////////////////////////////
    @objc func animationFab(){
        if !isFabOpen{

            self.facebookFabButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.whatsappFabButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            facebookFabButton.isHidden = false
            whatsappFabButton.isHidden = false
            self.isFabOpen = true

            
            print("TinderCard --> animationFab --> animate isFabOpen?")
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.shareFabButton.transform = CGAffineTransform(rotationAngle: CGFloat(90))
                            self.facebookFabButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.whatsappFabButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }else{
            
            
            self.facebookFabButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.whatsappFabButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.isFabOpen = false
            
            print("TinderCard --> animationFab --> animate isFabOpen!")

            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.shareFabButton.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                            self.facebookFabButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                            self.whatsappFabButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            },completion: { (Bool) in
                self.facebookFabButton.isHidden = true
                self.whatsappFabButton.isHidden = true

            
            
            })
        }
    }
////////////////////////////////
    @objc func whatsappFabAction(){
        print("Whatsapp Action")
        let originalString = "https://www.google.com"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        if UIApplication.shared.canOpenURL(url! as URL)
        {
 
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
////////////////////////////////
    @objc func facebookFabAction(){
        print("Facebook Action")
    }*/
////////////////////////////////
    
    func get_image(_ url_str:String, _ imageView:UIImageView)       //Obtiene la imagen (UIImage) y si no hay, utiliza una por default
    {
        if url_str == "" {
            //Poner una imagen por default
            print("TinderCard --> get_image --> urlImage: Nil")
            imageView.image = #imageLiteral(resourceName: "tarjetaDefault")              //Imagen default
        }else{
            //print("Debug --> url:",url,"\nurlToImage:",urlToImage,"\ntitle:",title,"\nautor:",name)

            print("TinderCard --> get_image --> urlImage: ",url_str)

            let url:URL = URL(string: url_str) ?? URL.init(fileURLWithPath: "/CIDNewsiOS/Assets.xcassets/tarjetaDefault.imageset/tarjetaDefault.png")
            

            let session = URLSession.shared              //Usa URLSession para hacerlo en el background
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in if data != nil {
                    let image = UIImage(data: data!)
                    if(image != nil) {
                        
                        DispatchQueue.main.async(execute: {
                            imageView.image = image             //Asigna la imagen obtenida del data a nuestra imagen(imageView.image)
                            imageView.alpha = 1
                            print("TinderCard --> get_image --> ADD Image to Subviews ")
                            /*UIView.animate(withDuration: 0.1, animations: {
                                imageView.alpha = 1.0
                                print("\n\t\tSHOW YOURSELF\n")
                            })*/
                        })
                    }else{
                        print("TinderCard --> get_image --> URLSession --> Image == nil ")
                        //imageView.image = #imageLiteral(resourceName: "tarjetaDefault")              //Imagen default

                    }
                }
            })
            task.resume()
        }
    }
////////////////////////////////
}


