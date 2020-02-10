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
}

class TinderCard: UIView,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate {
    
    // MARK: - VARIABLES
    weak var delegate: TinderCardDelegate?
    private var estimatedProgressObserver: NSKeyValueObservation?
    var attributedText = NSMutableAttributedString(string: "")
    var dataVal = NSMutableData()
    // STRING
    var textUrl = ""
    // FLOAT
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var xCoordLabel: CGFloat = 0.0
    var yCoordLabel: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    // BOOLEAN
    var isLiked = false
    var isFabOpen = false
    var flagScroll = false
    var flagSwipe = false
    var flagMoving = false
    private var isInAnimation = false

    // MARK: - VIEWS
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
    
    // MARK: - CONSTRUCTORS
    public init(frame: CGRect, value: Int, list: Array<Noticias>) {
        super.init(frame: frame)
        print("TinderCard --> init Setup")
        /**
         CONFIGURACIÓN DE LAS VISTAS
         */
        setupView(at: value,list: list)
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("TinderCard --> init Error")
        fatalError("init(coder:) has not been implemented")
    }
    
////////////////////////////////
    // MARK: - FUNCTIONS
    func setupView(at value:Int,list: Array<Noticias>) {  //Inicia configuracion con el arreglo de noticias (list)
        print("TinderCard --> setupView")


        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
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
        
        print("TinderCard --> setupView --> addGestureRecognizer")

        scrollViewCard = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollViewCard.contentSize = CGSize(width: screenWidth, height: screenHeight*3)
        scrollViewCard.isScrollEnabled = true
        scrollViewCard.backgroundColor = UIColor.white
        //scrollViewCard scroll desahabilitado, no muestra los botones de compartir
        scrollViewCard.isScrollEnabled = false

        DegradadoImageView = UIImageView(frame: self.bounds)
        
        DegradadoImageView.image = UIImage.animatedImage(with: [#imageLiteral(resourceName: "Rect_Degradado")], duration: 1)  //Imagen para hacer el degradado
        DegradadoImageView.contentMode = .scaleToFill
        DegradadoImageView.clipsToBounds = true
        
        defaulCardImageView = UIImageView(frame: self.bounds)
        defaulCardImageView.image = UIImage.animatedImage(with: [#imageLiteral(resourceName: "tarjetaDefault")], duration: 1)  //Imagen para hacer el degradado
        defaulCardImageView.contentMode = .scaleToFill
        defaulCardImageView.clipsToBounds = true

        xCoordLabel = frame.size.width/20
        yCoordLabel = frame.size.height - frame.size.height/4
        labelText = UILabel(frame:CGRect(x: xCoordLabel/2, y: yCoordLabel , width: frame.size.width-xCoordLabel-65 , height: frame.size.height/8))  //configuracion del titulo de la noticia(label)
         labelTextAutor = UILabel(frame:CGRect(x: -xCoordLabel, y: yCoordLabel+frame.size.height/8,width: frame.size.width-xCoordLabel-65, height: frame.size.height/10 )) //configuracion del autor(label)
        print("TinderCard --> setupView --> add text in title")
        
        self.attributedText = NSMutableAttributedString(string: list[value-1].title)
        self.labelText.attributedText = self.attributedText  //asigna el texto(titulo)

        labelText.numberOfLines = 3
        labelText.textColor = .white
        labelText.textAlignment = .center
        labelText.font = UIFont.init(name: "Montserrat-Medium", size: 16)
        labelText.adjustsFontForContentSizeCategory = true
        
        print("TinderCard --> setupView -->  autor")
        self.attributedText  = NSMutableAttributedString(string: "\(list[value-1].autor) ")  //asigna el texto(autor)
        self.labelTextAutor.attributedText = self.attributedText
        
        labelTextAutor.numberOfLines = 1
        labelTextAutor.textColor = .white
        labelTextAutor.textAlignment = .right
        labelTextAutor.font = UIFont.init(name: "Montserrat-Medium", size: 16)
        
        backGroundImageView = UIImageView(frame:self.bounds)

        get_image(list[value-1].urlToImg, backGroundImageView)
        
        print("TinderCard --> setupView --> loadCardsIMAGE:",value-1)
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true;

        print("TinderCard --> setupView --> add Subviews TextAutor \n")
       
        let heightWebView = frame.size.height*4
        let initWeb = fabsf(0)
            
        let rectWeb = CGRect.init(x: CGFloat(initWeb), y: frame.size.height, width: frame.size.width, height: heightWebView)
        
        let rectProgress = CGRect.init(x: CGFloat(initWeb)
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
        scrollViewCard.showsVerticalScrollIndicator = true
        scrollViewCard.delegate = self
        textUrl = list[value-1].url
        
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
                    })
                }
            }
            
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
                    let mCGSizeFrame = self.scrollViewCard.contentSize
                    
                    self.scrollViewCard.contentSize = CGSize(width: mCGSizeFrame.width, height: height as! CGFloat)
                    
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
    
    // MARK: - GESTURE SWIPE PARA LA TARJETA EN HOME
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
            
            //flagSwipe para poder hacer swipe o scroll
            flagSwipe = true
           // if !(flagScroll&&flagSwipe){
            if (flagSwipe){

                let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
                let rotationAngel = .pi/8 * rotationStrength
                print("TinderCard, beingDragged, rotationAngel:",rotationAngel)
                let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
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
    
    func get_image(_ url_str:String, _ imageView:UIImageView) {   //Obtiene la imagen (UIImage) y si no hay, utiliza una por default
        if url_str == "" {
            //Poner una imagen por default
            print("TinderCard --> get_image --> urlImage: Nil")
            imageView.image = #imageLiteral(resourceName: "tarjetaDefault")              //Imagen default
        } else {
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
                        })
                    }else{
                        print("TinderCard --> get_image --> URLSession --> Image == nil ")
                    }
                }
            })
            task.resume()
        }
    }

}
