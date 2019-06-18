//
//  ViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 10/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//
let  MAX_BUFFER_SIZE = 2;
let  SEPERATOR_DISTANCE = 0;
let  TOPYAXIS = 75;

import UIKit
import Foundation
import CoreData
import Social
import FBSDKShareKit


class Home: UIViewController {
    @IBOutlet weak var shareMainButton: UIButton!
    @IBOutlet weak var WeakSignalShow: UIView!
    @IBOutlet weak var TrashLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var TrashIcon: UIImageView!
    @IBOutlet weak var FavoriteIcon: UIImageView!
    @IBOutlet weak var CidNewsMenuVoid: UIView!
    @IBOutlet weak var voidII: UIView!
    @IBOutlet weak var voidI: UIView!
    @IBOutlet weak var HealthMenu: UIView!
    @IBOutlet weak var ConstructionMenu: UIView!
    @IBOutlet weak var RetailMenu: UIView!
    @IBOutlet weak var EducationMenu: UIView!
    @IBOutlet weak var EntertainmentMenu: UIView!
    @IBOutlet weak var EnvironmentMenu: UIView!
    @IBOutlet weak var FinanceMenu: UIView!
    @IBOutlet weak var EnergyMenu: UIView!
    @IBOutlet weak var TelecomMenu: UIView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var BarBottom: UIView!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var LabelSnackbar: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var myStackHome: UIStackView!
    @IBOutlet weak var customScrollBar: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var topIndicator: NSLayoutConstraint!
    @IBOutlet var Shares: [UIButton]!
    

    var helpfullLabel = ""
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayBDHome:[PreferenciaData] = []
    var currentIndex = 0
    ///
    //Array int
    
    var arrayStateRequest = 0
    var sizePreference = 0
    
    //

    var currentLoadedCardsArray = [TinderCard]()
    var currentLoadedCardsArrayEspecial = [[TinderCard]]()
    var allCardsArray = [TinderCard]()
    var shareFabButton = UIButton()
    var valueArray = [Int]()//
    var valueArrayEspecial = [[Int]]()//
    var listNews = [Noticias]() //alternatively (does the same): var array = Array<Country>()
    var listNewsEspecial = [[Noticias]]()
    var shareFabInAnimation = false
    var menuShowing = false
    var shareFabShow = false
    var showFabInScrolling = true

    var newsrefresh = 0
    var realSizeArrayNews = 0
    var countingHelper = 0
    var sizeArrayListNews = 0
    var currentIndexHelper = 0
    
    
    var selectMenu:String = " "     // El contenido de SelectMenu será reemplazado por la URL de las API`s de donde se obtiene las noticias
    
    var arrayMoreNewsAPIMenuSlide:[String] = Array(repeating: "", count: 9)
    var arrayDefaultNewsAPIMenuSlide:[String] = Array(repeating: "", count: 9)
    var arrayMoreNewsAPITypeSettings:[String] = Array(repeating: "", count: 9)
    var arrayDefaultNewsAPISettings:[String] = Array(repeating: "", count: 9)
    
    
    
    
    //BOOLEANS
    
    var ViewIsInAnimation = false
    var scrollBarIsHidding = false
    //API KEYS:
    // 99237f17c0b540fdac4d8367e206f5b2
    // 83bff4ded3954c35862369983b88c41b
    // b23937d4bc7a475299e110d007318d28
    // a4d2bb68bcae4cb9beb49105c53020f2
    // 177c6f87857545c18844e9e4b886dd69
    // 009aac2e199d434ebae570555e96f198
    // 23c8740aadb64619a124f1506393fb98
    // 8de9910a613a49289729a8725a0b9fcb
    // 4d3e24219543475eb1cdab5b79d29efd


    let urlBase:String = "https://newsapi.org/v2/everything?";
    
    let urlTypeSettings :[String] = [
    "q=health+technology","q=retail+technology","q=construction+technology",
    "q=entertainment+technology","q=environment+technology","q=education+technology",
    "q=energy+power+technology","q=economy+technology","q=telecom+technology"]
    
    
    let urlTypeMenuSlide :[String] = [
    "q=health+technology","q=construction+technology","q=retail+technology",
    "q=education+technology","q=entertainment+technology","q=environment+technology",
    "q=economy+technology","q=energy+power+technology","q=telecom+technology"]
    
    let urlSortBy:String = "&sortBy=popular"
    
    let urlAPIKey :[String] = [
    "&apiKey=99237f17c0b540fdac4d8367e206f5b2",
    "&apiKey=83bff4ded3954c35862369983b88c41b",
    "&apiKey=b23937d4bc7a475299e110d007318d28",
    "&apiKey=a4d2bb68bcae4cb9beb49105c53020f2",
    "&apiKey=177c6f87857545c18844e9e4b886dd69",
    "&apiKey=009aac2e199d434ebae570555e96f198",
    "&apiKey=23c8740aadb64619a124f1506393fb98",
    "&apiKey=8de9910a613a49289729a8725a0b9fcb",
    "&apiKey=4d3e24219543475eb1cdab5b79d29efd"]
    
    let urlLanguage:String = "&language=en"

    var urlDate:String = "&from="

    //
    var defaultMenu:String = "https://newsapi.org/v2/everything?q=health+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b"
    var kindOfNews: String = ""

    let typeOfNewsMenuSlide:[String] = ["health","construction","retail","education","entertainment","environment","finance","energy","telecom"]
    let typeOfNews:[String] = ["health","retail","construction","entertainment","environment","education","energy","finance","telecom"]

    //////////////////////////
    //MARK:
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //////////////////////////
    //MARK:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //////////////////////////
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")  // Primer lanzamiento de la Aplicacion
        if launchedBefore  {
            print("Home --> viewDidLoad() --> Not first launch.")
        } else {
            print("Home --> viewDidLoad() --> First launch.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            inicioDB() //Pone en TRUE todas las preferencias de Settings
        }
        
        self.fetchData()  // Peticion para el CoreData a la entidad  PreferenciasData (Tiene la configuracion para saber que noticias cargar)
        setupStart()
        setupUI()
        setupMenuSlide()  // Menu Slide para iniciar el Gesture Tap
        setupTinderAndFabShare()

        
        if Reachability.isConnectedToNetwork(){  // Prueba de conexion a Internet
            WeakSignalShow.isHidden = true
            print("Home --> viewDidLoad --> Internet Connection Available!")
            generalRequestApi()  //Empieza a pedir y a mostrar las noticias en la siguiente funcion
            
        }else{
            print("Home --> viewDidLoad -->Internet Connection not Available!")
            WeakSignalShow.isHidden = false

        }
        
        print("Home --> viewDidLoad --> Start")
        print("Home --> viewDidLoad --> Preferencia Health :",arrayBDHome[0].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Retail :",arrayBDHome[1].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Construction :",arrayBDHome[2].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Entertainment :",arrayBDHome[3].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Environment :",arrayBDHome[4].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Education :",arrayBDHome[5].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Energy :",arrayBDHome[6].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia finance :",arrayBDHome[7].arrayPreferencias)
        print("Home --> viewDidLoad --> Preferencia Telecom :",arrayBDHome[8].arrayPreferencias)
        print("Home --> viewDidLoad --> Finish \n\n")
        }

    
    //////////////////////////
    //MARK:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)  // Esconde el NavigationBar
        if Reachability.isConnectedToNetwork(){
            print("Home --> viewWillAppear --> Internet Connection Available!")
            WeakSignalShow.isHidden = true

            self.fetchData()  // Peticion para el CoreData a la entidad  PreferenciasData (Tiene la configuracion para saber que noticias cargar)
            if helpfullLabel != "" {    // HelpfullLabel es utilizado para saber, si el usuario hizo un cambio en Settings, si selecciono diferentes preferencias o no
                print("Home --> viewWillAppear --> Actualizar News")
                currentLoadedCardsArray.removeAll()   //Remueve todas las Noticias y Arreglos cargados
                listNews.removeAll()
                valueArray.removeAll()
                allCardsArray.removeAll()
                currentIndex = 0
                currentIndexHelper = 0

                for subUIView in self.viewTinderBackGround.subviews as [UIView] {   //Remueve todas subvistas
                    if (subUIView.tag != 1011){
                        subUIView.removeFromSuperview()
                    }
                }
                generalRequestApi()  // Vuelve a cargar las noticias, con las nuevas preferencias
                helpfullLabel = ""
            }
        }else{
            print("Home --> viewWillAppear --> Internet Connection not Available!")
            WeakSignalShow.isHidden = false
        }
        TrashIcon.alpha = 0
        FavoriteIcon.alpha = 0
    }
    //////////////////////////
    //MARK:
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)  //Cuando se da Tap a una noticia, muestra el NavigationBar para poder regresar
    }

    //////////////////////////
    //MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //////////////////////////
    //MARK:
    func inicioDB(){    // Pone en TRUE todas las preferencias, en caso de que sea la primera vez que entra, es el default
        var m = 0
        while m <= 8 {
            let theConfig = NSEntityDescription.insertNewObject(forEntityName: "PreferenciaData", into: context)
            theConfig.setValue(true,forKey: "arrayPreferencias") 
            m += 1
        }
        do{
            try context.save()
        }catch{
            print(error)
            
        }
    }

    //////////////////////////
    //MARK:
    func generalRequestApi() {
        print("Home --> generalRequestApi")
          for i in 0...8 {
            print("Home --> generalRequestApi --> ARRAY BD HOME: ",self.arrayBDHome[i].arrayPreferencias," i:",i)  //BD Preferencias: TRUE o FALSE
            print("Home --> generalRequestApi --> type of news :",typeOfNewsMenuSlide[i])
            
            if self.arrayBDHome[i].arrayPreferencias {          //Apartir de las preferencias si es TRUE agregara la noticia, *falta optimizarlo*z
                sizePreference += 1
                addFirstNewsDefault(option: i,type:  typeOfNews[i])
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {}
            }
            
            if i == 8 {  //Se utiliza para saber, si ya finalizo de cargar los valores de las API`s y así empezar a cargar las vistas de las cartas.
                print("Home --> generalRequestApi --> i == 8")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { // Despues de hacer tap, va al menu Home
                    print("Home --> generalRequestApi -->  loadCardValues()")
                    self.loadCardValues()
                   }
            }
        }
        print("Home --> generalRequestApi --> ApiManager End")
    }
    
    //////////////////////////
    //MARK:
    func specificRequestMenuSlide(optionSelected:Int) {
        print("Home --> specificRequestMenuSlide --> optionSelected:",optionSelected)
        print("Home --> specificRequestMenuSlide --> type of news (MenuSelected):",typeOfNewsMenuSlide[optionSelected-1])
        
            addFirstNewsDefault(option: optionSelected-1,type:  typeOfNews[optionSelected-1])
        
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Despues de hacer tap, va al menu Home
                    print("Home --> specificRequestMenuSlide --> self.loadCardValues()")
                    self.loadCardValues()
                    self.sizeArrayListNews = self.listNews.count
                }
        
        print("Home --> specificRequestMenuSlide --> finish")
    }
    
    
    
    func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
   
    
    
    //////////////////////////
    //MARK:
    func getDataFrom(urlString: String, completion: @escaping (_ data: NSData)-> ()) {   //Se utiliza para obtener las imagenes para de las noticias
            if let url = URL(string: urlString) {
                let session = URLSession.shared  //Indica que sea un Session para no tenerlo en el hilo principal
                let task = session.dataTask(with: url) { (data, response, error) in  //Hace la peticion y espera a el resultado
                print("Home --> getDataFrom --> Before calling completion")
                if let data = data {
                    completion(data as NSData)
                } else {
                    print(error?.localizedDescription)
                }
            }
            task.resume() //Indica que realice la peticion
            } else {
                print("Home --> getDataFrom --> URL is invalid") }
    }
    //////////////////////////
    //MARK:
    func loadCardValuesInBackGround(){
        if valueArray.count > 0 {
            print("Home --> loadCardValuesInBackGround --> Start loadCardValues, valueArray.count:",valueArray.count)
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            for (i,value) in valueArray.enumerated() {
                print("Home --> loadCardValuesInBackGround --> Create Tinder Card --> i:",i,"  value:",value)
                if i >= capCount {
                    print("Home --> loadCardValuesInBackGround --> i > capCount --> add new Card")
                    let newCard = createTinderCardInBackground(at: i,value: value)
                    allCardsArray.append(newCard)
                }
            }
            
            UI(){
                self.viewTinderBackGround.reloadInputViews()

            }
        }
    }

    //////////////////////////
    //MARK:
    func loadCardValues() { //Carga los valores de las cartas
        self.sizeArrayListNews = self.listNews.count
        print("Home --> loadCardValues --> size.ArrayListNews:",self.sizeArrayListNews)

        if valueArray.count > 0 {
            print("Home --> loadCardValues --> Start loadCardValues, valueArray.count:",valueArray.count)
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            // for (i,value) in valueArray.enumerated() {
            for (i,value) in valueArray.enumerated() {
                print("Home --> loadCardValues --> Create Tinder Card --> i:",i,"  value:",value)
                if i < capCount {
                    print("Home --> loadCardValues --> i > capCount --> add new Card")
                    let newCard = createTinderCard(at: i,value: value)
                    allCardsArray.append(newCard)
                    currentLoadedCardsArray.append(newCard)
                    
                    
                    /*
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) { // Despues de hacer tap, va al menu Home
                        print("Home --> loadCardValues --> viewTinderBackground.insertSubviews[",i,"]")
                        self.viewTinderBackGround.insertSubview(self.currentLoadedCardsArray[i], at: 0)
                        //self.shareFabButton.addTarget(self, action: #selector(self.ButtonClick(_:)), for: UIControlEvents.touchUpInside)
                        /**
                         self.animationShowFabShare()**/
                    }
                    */
                    self.viewTinderBackGround.insertSubview(self.currentLoadedCardsArray[i], at: 0)
                    //viewTinderBackGround.addSubview(currentLoadedCardsArray[i])

                }else{
                    
                    /*
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
                        let newCard = self.createTinderCardInBackground(at: i,value: value)
                        self.allCardsArray.append(newCard)
                        if(value == self.listNews.count){
                            print("Home --> loadCardValues --> DispatchQueue.global.background --> viewTinderBackGround.reloadInputViews()")
                            self.viewTinderBackGround.reloadInputViews()
                        }
                     }
 
 */

                    /*

                    // DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
                    // Some background work here
                    print("Home --> loadCardValues -->  DispatchQueue.global qos.background")
                    let newCard = self.createTinderCard(at: i,value: value)
                    self.allCardsArray.append(newCard)
                    // }
                    */
                }
                // DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { // Despues de hacer tap, va al menu Home
                //  UIView.animate(withDuration: 0.5, animations: {
                // self.customScrollBar.alpha = 0
                // })
                //}
            }
            
            
            
            print("Home --> loadCardValues --> viewTinderBackGround.reloadInput")
            viewTinderBackGround.reloadInputViews()
            viewTinderBackGround.updateConstraintsIfNeeded()
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > capCount - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) { // Despues de hacer tap, va al menu Home
                        print("\n\nHome --> loadCardValues --> DispatchQueue.main --> Insert Sub Views \n\n")
                        self.viewTinderBackGround.insertSubview(self.currentLoadedCardsArray[i], at: i)
                        //self.customScrollBar.alpha=1
                    }
                }else {
                    
                }
            }
            
           
        }
        
        //print("Home --> loadCardValues --> loadCardValuesInBackGround")
        //loadCardValuesInBackGround()
        
        
        //BG() {
            print("Home --> loadCardValues --> BG --> loadCardValuesInBackGround")
            self.loadCardValuesInBackGround()
            // everything in here will execute in the background
        //}
        

        
        print("Home --> loadCardValues --> animateCardAfterSwiping")
        animateCardAfterSwiping()
        // perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Home.imageTapped))
        self.viewTinderBackGround.addGestureRecognizer(tapGesture)
        print("Home --> loadCardValues --> finish")
       
    }
    //////////////////////////
    //MARK:
    func animateCardAfterSwiping() {   //Animacion a todas las cartas cargadas
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
    }
    //////////////////////////
    //MARK:
    @objc func imageTapped(){             //Muestra la noticia en un WebView
        print("Home --> imageTapped")
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "WelcomeID") as! WebViewController   //Genera el WebView
        self.navigationController!.pushViewController(VC1, animated: true)    //Redirecciona al Webview
        print("Home --> imageTapped --> CurrentIndexHelper: ",currentIndexHelper)
        if currentIndexHelper - listNews.count > -1{
            print("ImageTap 1")
            VC1.text1 = listNews[0].url
        }else{
            print("ImageTap 2")
            VC1.text1 = listNews[currentIndexHelper].url  //Obtiene la url que se usara para ver la noticia
        }

        ///// newsrefresh es una opcion para poder volver a ver las noticias, una vez que el usuario haya visto todas las noticias.
    }
    
    
    
    
    //////////////////////////
    //MARK:
    func createTinderCardInBackground(at index: Int , value :Int) -> TinderCard {   //Crea la Carta apartir de los arreglos, listNews y TinderCard
        print("\nHome --> createTinderCardInBackGround --> viewTinderBackGround.height:",self.viewTinderBackGround.frame.height)
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height ) ,value : value, list: listNews)
        print("Home --> createTinderCard: before delegate Card ")
        card.delegate = self
        print("Home --> createTinderCard: return Card ")
        return card
    }
    
    
    //////////////////////////
    //MARK:
    func createTinderCard(at index: Int , value :Int) -> TinderCard {   //Crea la Carta apartir de los arreglos, listNews y TinderCard
        print("\n\n\nHome --> createTinderCard: ",self.viewTinderBackGround.frame.height)
        self.viewTinderBackGround.updateConstraints()
        self.viewTinderBackGround.updateFocusIfNeeded()
        self.viewTinderBackGround.updateConstraints()
        self.viewTinderBackGround.layoutIfNeeded()
        self.viewTinderBackGround.frame.size.height = self.viewTinderBackGround.frame.size.height
        print("Home --> createTinderCard: ",self.viewTinderBackGround.frame.height)
        
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height ) ,value : value, list: listNews)
        print("Home --> createTinderCard: before delegate Card ")

        card.delegate = self
        print("Home --> createTinderCard: return Card ")
        return card
    }
    //////////////////////////
    //MARK:
    func removeObjectAndAddNewValues() {  //Remueve la carta y añade nuevas cartas, utilizado despues de un swipe(izquierda o derecha)
       /* UIView.animate(withDuration: 0.2) {  //  Aparecer el Snackbar(barra negra) rapido o lento donde esta el boton Undo
            self.buttonUndo.alpha = 1
            self.BarBottom.alpha = 1
        }*/
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1  //Contador de arreglo de cartas
       // Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)  //Aparece el boton Undo
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count { // Lleva la apariencia de las cantidades de cartas
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]   //Obtiene la carta siguiente a mostrar
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE) // Separa las cartas, la primera de la segunda carta
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2]) // Muestra las cartas
        }else{
            if currentIndex == allCardsArray.count{
            print("Home --> removeObjectAndAddNewValues --> Reload Cards NOW!")
            loadCardValues()  //Carga las noticias de nuevo
            countingHelper = countingHelper + 1  //Ayuda a notificar que se acabaron las cartas
            }
        }
        print("Home --> removeObjectAndAddNewValues --> CurrentIndex:",currentIndex)
        print("Home --> removeObjectAndAddNewValues --> allCardArray.count:",allCardsArray.count) //Ayuda a saber la cantidad de Cartas, util para saber cuando se han acabo y tiene que hacer reload
        animateCardAfterSwiping()

    }
    /*
    //////////////////////////
    //MARK:
    @IBAction func undoBotonAction(_ sender: Any) {   //Regresa la carta que se ha hecho Swipe
        currentIndex =  currentIndex - 1
        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
            let lastCard = currentLoadedCardsArray.last
            lastCard?.rollBackCard()
            currentLoadedCardsArray.removeLast()
        }
        let undoCard = allCardsArray[currentIndex]
        undoCard.layer.removeAllAnimations()
        viewTinderBackGround.addSubview(undoCard)
        undoCard.makeUndoAction()
        currentLoadedCardsArray.insert(undoCard, at: 0)
        animateCardAfterSwiping()
        UIView.animate(withDuration: 0.1) {
            self.buttonUndo.alpha = 0
            self.BarBottom.alpha = 0
        }
    }
 */
    
    /*
    //////////////////////////
    //MARK:
    @objc func enableUndoButton(timer: Timer){
        let cardIntex = timer.userInfo as! Int
        if (currentIndex == cardIntex) {
            UIView.animate(withDuration: 0.2) {    ///tiempo de duracion del boton Undo
                self.buttonUndo.alpha = 0//1.0
                self.BarBottom.alpha = 0
            }
        }
    }
 */
    
    
    
    //////////////////////////
    //MARK:
    func countingForUrl(){
        
        if countingHelper == 0{
            currentIndexHelper = currentIndex
        }else{
            
            if (currentIndex - countingHelper*(sizeArrayListNews)) + 1 > 1 {
                print("Home --> countingForUrl --> MARK 1 ?")
                currentIndexHelper = currentIndex - countingHelper*(sizeArrayListNews)
            }else{
                print("MARK 2 current index:",currentIndex," RESTA: - ",(countingHelper-1)*(sizeArrayListNews))
                currentIndexHelper = currentIndex - (countingHelper-1)*(sizeArrayListNews)
                print("Home --> countingForUrl --> MARK 2 ?")
            }
        }
    }
    
    
    /******************************************************* SETUP **************************************************************/
    
    //////////////////////////
    //MARK:
    func setupStart(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        for i in 0..<9{
            arrayDefaultNewsAPISettings[i] = urlBase + urlTypeSettings[i] + urlSortBy + urlAPIKey[i]+urlLanguage+urlDate+result
            // arrayMoreNewsAPITypeSettings[i] = arrayDefaultNewsAPISettings[i]
            
            arrayDefaultNewsAPIMenuSlide[i] = urlBase + urlTypeMenuSlide[i] + urlSortBy + urlAPIKey[i]+urlLanguage+urlDate+result
            // arrayMoreNewsAPIMenuSlide[i] = arrayDefaultNewsAPIMenuSlide[i]
            print("Home --> arrayDefaultNewsAPISettings[",i,"] = ",arrayDefaultNewsAPISettings[i])
        }
    
        print("Home --> setupStart () Finish")
    }
    
    
    
    //////////////////////////
    //MARK:
    func setupUI(){
        
        Shares.forEach{(button) in
            button.isHidden = true
            button.layer.cornerRadius = button.frame.height / 2
        }
        
        TrashIcon.alpha = 0
        FavoriteIcon.alpha = 0  //Son los iconos que aparecen cuando realiza uno Swipe
        buttonUndo.alpha = 0
        BarBottom.alpha = 0// Barra negra donde esta ubicado el boton Undo, cuando ha realizado un Swipe
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        
        self.RestartBackgroundMenu()  // Configura los colores del Menu Slide
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Home.respondRight)) // Añade Gestures
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(Home.respondLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)  //Añade los Gestures para hacer Swipe a la Izquierda y Derecha
        
        
        //indicatorBar.backgroundColor = UIColor.red
        indicatorBar.layer.cornerRadius = indicatorBar.frame.size.width / 2;
        customScrollBar.tag = 1011
        customScrollBar.layer.cornerRadius = customScrollBar.frame.size.width / 2;
        customScrollBar.alpha=0
        
        

        topIndicator.isActive = true
        
        print("Home --> SetupUI --> customScrollBar Height:",customScrollBar.frame.size.height)
        //indicatorBar.frame.offsetBy( dx: 0, dy: customScrollBar. ); // offset by an amount
        leadingConstraint.constant =  view.frame.size.width  //Este Constrait esta ligado al View del Menu Slide, para que pueda aparecer y desaparecer, inicialmente el constraint tiene el valor del ancho del dispositivo.
        
        view.layoutIfNeeded()

        
    }
    
    
    
    //////////////////////////
    //MARK:
    func setupTinderAndFabShare() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        viewTinderBackGround.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        viewTinderBackGround.layer.shadowOffset = CGSize(width: 0, height:  4)
        viewTinderBackGround.layer.shadowOpacity = 0.3
        viewTinderBackGround.layer.shadowRadius = 3
        viewTinderBackGround.layer.masksToBounds = false
        
        shareMainButton.layer.cornerRadius = shareFabButton.layer.frame.size.width/2
        shareMainButton.clipsToBounds = true
        //shareMainButton.backgroundColor = UIColor.darkGray
        shareMainButton.setImage(UIImage(named: "ic_share_main"), for: .normal)
        // shareFabButton.translatesAutoresizingMaskIntoConstraints = false
        shareMainButton.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shareMainButton.layer.shadowOffset = CGSize(width: 0, height:  3)
        shareMainButton.layer.shadowOpacity = 0.3
        shareMainButton.layer.shadowRadius = 3
        shareMainButton.layer.masksToBounds = false
        shareMainButton.isHidden = true
        
    }
    
    
    
    
    //////////////////////////
    //MARK:
    func setupMenuSlide(){    //Añade el gesturerecognizer a cada view del MenuSlide para hacer tap
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedHealth))
        self.HealthMenu.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedConstruction))
        self.ConstructionMenu.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedRetail))
        self.RetailMenu.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedEducation))
        self.EducationMenu.addGestureRecognizer(tapGesture3)
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedEntertainment))
        self.EntertainmentMenu.addGestureRecognizer(tapGesture4)
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedEnvironment))
        self.EnvironmentMenu.addGestureRecognizer(tapGesture5)
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedFinance))
        self.FinanceMenu.addGestureRecognizer(tapGesture6)
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedEnergy))
        self.EnergyMenu.addGestureRecognizer(tapGesture7)
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(Home.MenuTappedTelecom))
        self.TelecomMenu.addGestureRecognizer(tapGesture8)
    }

    
    
    /****************************************************** COREDATA ************************************************************/

    //////////////////////////
    //MARK:
    func  fetchData()  {     //Conexion con el CoreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            arrayBDHome = try context.fetch(PreferenciaData.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    
    
    //////////////////////////
    //MARK:
    func saveNews() {                   // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
        print("Home --> saveNews")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"NoticiaData")
        request.returnsObjectsAsFaults = false
        print("Home --> saveNews --> sizeArrayListNews: ",sizeArrayListNews)
        do {
            
            var Bandera=false    //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
            let results = try context.fetch(request)
            if (results.count > 0){
                print("Home --> saveNews --> currentIndexHelper:",currentIndexHelper)
                print("Home --> saveNews --> currentIndex: ",currentIndex)
                
                
                
                
                for result in results as! [NSManagedObject]{
                    let prueba = result.value(forKey:"url") as? String //prueba tiene los valores (string) de url
                    let urlprueba = listNews[currentIndexHelper-1].url  //es la noticia que queremos guardar
                    let isEqual = (prueba == urlprueba)   // Si listNews(i).url es igual a noticia que queremos guardar, ya existe esa noticia
                    if isEqual {
                        print ("Home --> saveNews --> Noticia Repetida")
                        print("Home --> saveNews --> for --> currentIndexHelper: ",currentIndexHelper)
                        //  print("listNews(autor): ",listNews[currentIndexHelper-1].autor) //0 --> 19
                        Bandera=true
                    }
                }
                if !Bandera {  //Si no existe, guarda la noticia
                    guardar()
                    //     print(listNews[currentIndexHelper-1].cat)
                    print("Home --> saveNews --> currentIndex: ", currentIndexHelper)
                }
                
            }else{//Guarda si no hay ninguna noticia
                guardar()
                //   print(listNews[currentIndex-1].cat)
            }
            do{
                try context.save()
                
            }catch{
                print(error)
            }
        }catch  {
        }
    }

    //////////////////////////
    //MARK:
    func guardar(){   //Guarda la informacion de las listNews (Info de las API's) en el CoreData
        let theNews = NSEntityDescription.insertNewObject(forEntityName: "NoticiaData", into: context)
        
        print("Home --> Guardar --> currentIndex -1 : ",currentIndex-1)
        theNews.setValue(listNews[currentIndexHelper-1].title,forKey: "titulo")                                   //"titulo" es el atributo de la entidad NoticiaData
        theNews.setValue(listNews[currentIndexHelper-1].urlToImg,forKey: "urlToImg")
        theNews.setValue(listNews[currentIndexHelper-1].url,forKey: "url")
        theNews.setValue(listNews[currentIndexHelper-1].autor,forKey: "autor")
        theNews.setValue(listNews[currentIndexHelper-1].cat,forKey: "categoria")
        
        var auxImage = UIImage()
        if (listNews[currentIndexHelper-1].urlToImg == "")  ||  (allCardsArray[currentIndexHelper-1].backGroundImageView.image == nil){
            auxImage = #imageLiteral(resourceName: "ic_cidnewsiOS")                              //Asigna una imagen por default
        }else{
            auxImage = allCardsArray[currentIndexHelper-1].backGroundImageView.image!
        }
        
        let auxiliarimg = auxImage.pngData () as NSData?
        theNews.setValue(auxiliarimg,forKey: "imageNews")
        
        
    }
    
    
    /****************************************************** REQUEST *************************************************************/

    
    
    
    //////////////////////////
    //MARK:
    func addFirstNewsDefault(option:Int,type:String) {
        print("Home --> addFirstNewsDefault -->Start")
        print("Home --> addFirstNewsDefault --> index:",index)
        defaultMenu = arrayDefaultNewsAPISettings[option]

            getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                        if json["status"] as? String == "ok" {
                            let articles = json["articles"] as! NSArray
                            print("Home --> addFirstNewsDefault --> for Start")
                            for (index,element) in articles.enumerated(){
                                var art = element as! [String:Any]
                                
                                let title =  art["title"]  as? String
                                var img = art["urlToImage"] as AnyObject
                                var urlToImage =  ""

                                if img is NSNull{
                                    urlToImage = "Nil"
                                }else{
                                    urlToImage = art["urlToImage"] as? String ?? "Nil"
                                }
                                
                                let url = art["url"] as! String
                                var src = art["source"] as! [String:Any]
                                let name = src["name"] as? String
                                self.listNews.append(Noticias(title: title ?? "Untitled",autor: name ?? "Unknown",urlToImg: urlToImage ,url: url ,cate: type))
                                print(self.listNews.count,":",name ?? "Unknown Name")
                                self.valueArray.append(self.listNews.count)
                            }
                            
                            print("Home --> addFirstNewsDefault --> index:[",self.index,"]: lisNews.count:",self.listNews.count)
                            /*
                             DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.5) {
                             // Some background work here
                             print("Home --> generalRequestApi -->  DispatchQueue.main self.loadCardValues()")
                             self.loadCardValues()
                             self.sizeArrayListNews = self.listNews.count
                             
                             
                             DispatchQueue.main.async {
                             // It's time to update the UI
                             print("UI updated on main queue")
                             }
                             }
                             */
                            
                        }else{
                            print(json["status"] as? String ?? "testy") //Imprime en consola el "status" del servicio -> error
                        }
                    }
                }
            }
        
        print("Home --> addFirstNewsDefault --> finish")
    }

    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    //////////////////////////
    //MARK:
    func addMoreNews(option:Int,type:String) {
        print("Home --> addMoreNews --> Start")
        for index in 0...1{
            print("Home --> addMoreNews --> index:",index)
            if index == 1{
                defaultMenu = arrayDefaultNewsAPIMenuSlide[option]
            }else{
                defaultMenu =  arrayMoreNewsAPIMenuSlide[option]
            }
            getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data as Data) as! [String:Any]{
                        let articles = json["articles"] as! NSArray
                        print("Man for Start")
                        for (index,element) in articles.enumerated(){
                            var art = element as! [String:Any]
                            let title = art["title"] as! String
                            var urlToImage = art["urlToImage"] as? String
                            if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                                urlToImage = ""                                 //Indica que se pondra una imagen por default
                            }
                            let url = art["url"] as! String
                            var src = art["source"] as! [String:Any]
                            let name = src["name"] as! String
                            self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage!,url: url,cate: type))
                            print(self.listNews.count,":",name)
                            self.valueArray.append(self.listNews.count)
                        }
                        print("Home --> addMoreNews --> index[",index,"]: lisNews.count:",self.listNews.count)
                    }
                }
                
            }
        }
        print("Home --> addMoreNews --> finish")
    }
    
    
    //////////////////////////
    //MARK:
    func apiManagerMoreNews(opcion:Int) {  //Esta funcion es igual a apiManagerBlackJack, pero solo se ocupa cuando se selecciona un Tipo de Noticia del MenuSlide.
        print("Home --> apiManagerMoreNews --> start")
        for index in 0...1{
            print("Home --> apiManagerMoreNews --> index:",index)
            if index == 1{
                defaultMenu = arrayDefaultNewsAPIMenuSlide[opcion-1]
            }else{
                defaultMenu =  arrayMoreNewsAPIMenuSlide[opcion-1]
            }
            getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                        
                        if json["status"] as? String == "ok" {
                            let articles = json["articles"] as! NSArray
                            print("Response for Start")
                            for (index,element) in articles.enumerated(){
                                var art = element as! [String:Any]
                                let title = art["title"] as! String
                                var urlToImage = art["urlToImage"] as? String
                                if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                                    urlToImage = ""                                 //Indica que se pondra una imagen por default
                                }
                                let url = art["url"] as! String
                                var src = art["source"] as! [String:Any]
                                let name = src["name"] as! String
                                self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage ?? "Nil",url: url,cate: self.kindOfNews))
                                print("Home --> apiManagerMoreNews --> news type is:",self.kindOfNews)
                                print(self.listNews.count,":",name)
                                self.valueArray.append(self.listNews.count)
                                
                                
                            }
                            print("Response End")
                            
                            print("Home --> apiManagerMoreNews --> index[",index,"]: lisNews.count:",self.listNews.count)
                        }else{
                            print(json["status"] as? String ?? "testy")
                        }
                    }
                }
                // DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
                //}
                if index == 1{
                    self.loadCardValues()
                    self.sizeArrayListNews = self.listNews.count
                }
            }
        }
        print("Home --> apiManagerMoreNews --> finish")
    }
    
    
    
    
    
    /******************************************************* MENU ***************************************************************/

    
    //////////////////////////
    //MARK:
    @IBAction func MenuHome(_ sender: Any) {  //Esta funcion se utiliza para hacer aparecer el MenuSlide, a través del Constrait del MenuSlide desde el boton (Menu 3 puntos)
        print("Home --> MenuHome!")
        menuShowing = true
        if menuShowing {
        leadingConstraint.constant =  20  //Se define que tendra este Constrait (Se modificara "= 20" por  un valor de "frame.size.width/30"  p.ej)
            myStackHome.isHidden = false
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    //////////////////////////
    //MARK:
    @objc func MenuTappedHealth(){
        print("Menu Tapped Health")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[0]
        kindOfNews="health"
        MenuTappedBorrarData(opcion: 1)
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedConstruction(){
        print("Menu Tapped Construction")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[1]
        MenuTappedBorrarData(opcion: 2)
        kindOfNews="construction"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedRetail(){
        print("Menu Tapped Retail")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[2]
        MenuTappedBorrarData(opcion: 3)
        kindOfNews="retail"
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedEducation(){
        print("Menu Tapped Education")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[3]
        MenuTappedBorrarData(opcion: 4)
        kindOfNews="education"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedEntertainment(){
        print("Menu Tapped Entertainment")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[4]
        MenuTappedBorrarData(opcion: 5)
        kindOfNews="entertainment"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedEnvironment(){
        print("Menu Tapped Environment")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[5]
        MenuTappedBorrarData(opcion: 6)
        kindOfNews="environment"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedFinance(){
        print("Menu Tapped Finance")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[6]
        MenuTappedBorrarData(opcion: 7)
        kindOfNews="finance"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedEnergy(){
        print("Menu Tapped Energy")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[7]
        MenuTappedBorrarData(opcion: 8)
        kindOfNews="energy"
        
        /////
    }
    //////////////////////////
    //MARK:
    @objc func MenuTappedTelecom(){
        print("Menu Tapped Telecom")
        /////       Menu selected
        selectMenu = arrayDefaultNewsAPIMenuSlide[8]
        MenuTappedBorrarData(opcion: 9)
        kindOfNews="telecom"
        
        /////
    }
    
    
    
    //////////////////////////
    //MARK:
    func MenuTappedBorrarData(opcion:Int){   //Utilizado para borrar la informacion,vistas de las cartas y cargar los nuevos valores del menuSlide
        defaultMenu = selectMenu
        
        currentLoadedCardsArray.removeAll()   //Remueve todas las Noticias y Arreglos cargados
        listNews.removeAll()
        valueArray.removeAll()
        allCardsArray.removeAll()
        currentIndex = 0
        currentIndexHelper = 0
        
        for subUIView in self.viewTinderBackGround.subviews as [UIView] {   //Remueve todas subvistas
            if (subUIView.tag != 1011){
                subUIView.removeFromSuperview()
            }
        }
        
        ///////*****((
        //apiManagerBlackJack1()  // Vuelve a cargar las noticias, con las nuevas preferencias
        //        helpfullLabel = ""
        
        ////////////
        
        
        //apiManager(opcion: opcion)
        //apiManagerMoreNews(opcion:opcion)
        specificRequestMenuSlide(optionSelected: opcion)
        self.shareMainButton.isHidden = true
        
        switch opcion {
        case 1:
            self.HealthMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 2:
            self.ConstructionMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 3:
            self.RetailMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 4:
            self.EducationMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 5:
            self.EntertainmentMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 6:
            self.EnvironmentMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 7:
            self.FinanceMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 8:
            self.EnergyMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        case 9:
            self.TelecomMenu.backgroundColor = UIColor.init(red: 41/255, green: 185/255, blue: 232/255, alpha: 1)
            break
        default:
            print("No case founded in dismissMenuToRight")
        }
        dismissMenuToRight()
    }
    
    
    /******************************************************* ALERTS ************************************************************/

    
    //////////////////////////
    //MARK:
    func showAlertShare(service:String){
            let alert = UIAlertController(title: "Ops!", message: "You are not connected  \(service)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }

   
    //////////////////////////
    //MARK:
    func RestartBackgroundMenu(){    //Restaura los colores del MenuSlide, despues de haber seleccionado uno.
        self.CidNewsMenuVoid.backgroundColor = UIColor.init(red: 21/255, green: 150/255, blue: 193/255, alpha: 1)
        self.voidII.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.voidI.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.HealthMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.ConstructionMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.RetailMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.EducationMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.EntertainmentMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.EnvironmentMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.FinanceMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.EnergyMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor
        self.TelecomMenu.backgroundColor = self.CidNewsMenuVoid.backgroundColor

    }
    
    
    /************************************************** EVENTS GESTURES *************************************************************/

   

    //////////////////////////
    //MARK:
    @objc func respondRight(gesture: UIGestureRecognizer){  //Haciendo swipe a la derecha fuera del TinderCard
        print(" RIGHT SWIPE! ")
        dismissMenuToRight()
    }
    
    
    //////////////////////////
    //MARK:
    @objc func respondLeft(gesture: UIGestureRecognizer){    //
        print(" RIGHT LEFT! ")
        self.leadingConstraint.constant =  20
        myStackHome.isHidden = false
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
    }
    

    
    /************************************************** EVENTS CLICKS *************************************************************/

    
    
    //////////////////////////
    //MARK:
    @IBAction func ShareFBPressed(_ sender: UIButton) {
        print("Home --> ShareFBPressed --> Main Facebook Pressed")
        
        var urlTxt  = ""//URL.init(string: "")
        if currentIndexHelper - listNews.count > -1{
            print("Home --> ShareFBPressed --> ImageTap 1")
            //urlTxt = URL.init(string: listNews[0].url)
            urlTxt = listNews[0].url
        }else{
            print("Home --> ShareFBPressed --> ImageTap 2")
            //urlTxt = URL.init(string: listNews[currentIndexHelper].url)
            urlTxt = listNews[currentIndexHelper].url
        }
        
        print("Home --> ShareFBPressed --> urlTxt:"+urlTxt)
        
        var content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = URL.init(string: urlTxt)
        var dialog =  FBSDKShareDialog.init()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = FBSDKShareDialogMode.shareSheet
    
        if dialog.canShow{
            dialog.show()
        }
        else{
            showAlertShare(service: "Facebook")
        }
    }
    //////////////////////////
    //MARK: GENERAL INTENT
    @IBAction func shareFabPressed(_ sender: Any) {
        print("Home --> shareFabPressed")
        var mString = ""
        if currentIndexHelper - listNews.count > -1{
            mString = listNews[0].url
            print("--> Url:",mString)
        }else{
            mString = listNews[currentIndexHelper].url  //Obtiene la url que se usara para ver la noticia
            print("--> Url:",mString)
        }
        let activityController  = UIActivityViewController(activityItems:[mString],applicationActivities:nil)
        activityController.completionWithItemsHandler = { (nil,completed,_,_error) in if(completed){
                print("shareFab Completed!")
            }else{
                print("shareFab Canceled")
            }
        }
        present(activityController,animated:true){
            print("shareFab Presented")
        }
    }
    
    //////////////////////////
    //MARK:
    @IBAction func ShareTWPressed(_ sender: UIButton) {
        print("Home --> ShareTWPressed --> Main Twitter Pressed")
        
        var urlTxt = ""
        if currentIndexHelper - listNews.count > -1{
            print("Home --> ShareTWPressed --> ImageTap 1")
            urlTxt = listNews[0].url
        }else{
            print("Home --> ShareTWPressed --> ImageTap 2")
            urlTxt = listNews[currentIndexHelper].url
        }
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("Cidnews")
            vc.add(URL(string: urlTxt))
            present(vc, animated: true)
        }else{
            showAlertShare(service: "Twitter")
        }
        
    }
    //////////////////////////
    //MARK:
    @IBAction func ShareWAPressed(_ sender: UIButton) {
        print("Home --> ShareWAPressed --> Main Whatsapp Pressed")
        var msg = ""
        if currentIndexHelper - listNews.count > -1{
            print("Home --> ShareWAPressed --> ImageTap 1")
            msg = listNews[0].url
        }else{
            print("ImageTap 2")
            msg = listNews[currentIndexHelper].url
        }
        let urlWhats = "whatsapp://send?text=\(msg)"
        var url  = NSURL(string:urlWhats)
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url as! URL, options: [:]) { (success) in
                if success {
                    print("Home --> ShareWAPressed --> WhatsApp accessed successfully")
                } else {
                    self.showAlertShare(service: "Whatsapp")
                }
            }
        }
    }
  

    
    
    
    /************************************************** ANIMATIONS ****************************************************************/
 
    //////////////////////////
    //MARK:
    func animationDismissFavTrash(viewIcon:String,icon:UIImageView){
        //Icon.contentScaleFactor
        var direction = 0
        if viewIcon == "Fav" {
            direction = Int(view.frame.size.width)
        }else{
            direction = 0
        }
        
        print("Home --> animationDismissFavTrash --> icon.frame.origin",icon.frame.origin)
        UIView.animate(withDuration: 0.3
            ,animations: {
            icon.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                icon.frame.origin.x = CGFloat(direction)
            }
            
            ,completion: { (finished: Bool) in
                icon.alpha = 0
        })
        
    }
    
    //////////////////////////
    //MARK:
    func animationShowItem(item: UIButton){
        if(item.isHidden){
            print("Home --> animationShowItem --> Start")
            item.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            item.isHidden = false
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            item.transform = CGAffineTransform(scaleX: 1, y: 1)}
                            ,completion: { (finished: Bool) in })
            }
            print("Home --> animationShowItem --> Finish")
    }
    
    
    //////////////////////////
    //MARK:
    func animationHideItem(item: UIButton){
        if(!item.isHidden){
            print("Home --> animationHideItem --> Start")
            item.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.2,
                           animations: {
                            item.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)}
                ,completion: { (finished: Bool) in item.isHidden = true})
            
        }
        print("Home --> animationHideItem --> Finish")
    }
    
    
    
    //////////////////////////
    //MARK:
    func animationRotateFab(){
        //let btt = sender as! UIButton
        print("Home --> animationRotateMainFab")
        //DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // Despues de hacer tap, va al menu Home
        
        print("Home --> animationRotateMainFab --> Animation rotation is GOING")
        let imageRotation = 90
        UIView.animate(withDuration: 1.0, delay: 0,
                       options: [.autoreverse, .allowUserInteraction],
                       animations:{
                        self.shareMainButton.transform = CGAffineTransform(rotationAngle: CGFloat(imageRotation))
        }, completion: { (t) -> Void in
            self.shareMainButton.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.shareFabInAnimation = false
            
        })
        //}
    }
    
    //////////////////////////
    //MARK:
    func dismissMenuToRight(){       // Funcion para hacer dismiss al MenuSlide
        print("DISMISS!")
        self.leadingConstraint.constant =  view.frame.size.width
        UIView.animate(withDuration: 0.6, delay: 0.0,  animations: {
            self.view.layoutIfNeeded()
        }, completion: {(finished:Bool) in
            self.myStackHome.isHidden = true
            self.RestartBackgroundMenu()
            
            
        })
    }

}
//////////////////////////////////
extension Home: TinderCardDelegate{
  /*  func scrollviewScrolling(scroll: UIScrollView) {
        //
    }*/
    func movingScrollBar(initialDistance: Float,currentDistance: Float){
        let percentScrolling = (currentDistance/initialDistance)*100   //100%e
        let newPosition = (Float(customScrollBar.frame.size.height - indicatorBar.frame.size.height)/100)*percentScrolling
        print("Home --> TinderCardDelegate --> movingScrollBar --> initialDistance(All distance Bar):",initialDistance)
        print("Home --> TinderCardDelegate --> movingScrollBar --> currentDistance:",currentDistance)
        print("Home --> TinderCardDelegate --> movingScrollBar --> Porcentaje: ",percentScrolling)
        print("Home --> TinderCardDelegate --> movingScrollBar --> newPosition:",newPosition)
        print("Home --> TinderCardDelegate --> movingScrollBar --> topIndicator Max:",customScrollBar.frame.size.height - indicatorBar.frame.size.height)
        if (newPosition > -4 && newPosition < (Float(customScrollBar.frame.size.height - indicatorBar.frame.size.height) + 4)){
        topIndicator.constant = CGFloat(newPosition)
        }
        
        
        self.customScrollBar.alpha = 1.0
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.scrollBarIsHidding = false
        })
        

        if !scrollBarIsHidding {
         //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Despues de hacer tap, va al menu Home
            scrollBarIsHidding = true
            UIView.animate(withDuration: 0.5, animations: {
                self.customScrollBar.alpha = 0
            },completion: {(finished: Bool) in
                self.scrollBarIsHidding = false
            })
         //}
        }
        
        if percentScrolling < 5 {
            if(!Shares[0].isHidden && !showFabInScrolling){
                Shares.forEach{(button) in
                    animationHideItem(item: button)
                }
            }
            
            if (shareMainButton.isHidden){
                showFabInScrolling = true
                ViewIsInAnimation = false
                animationShowItem(item: shareMainButton)
            }
        }else{
            if !shareMainButton.isHidden && showFabInScrolling && !ViewIsInAnimation {
                showFabInScrolling = false
                ViewIsInAnimation = true
                animationHideItem(item: shareMainButton)
            }
            if(Shares[0].isHidden){
                Shares.forEach{(button) in
                    animationShowItem(item: button)
                }
            }
        }
    }
    
    func cardGoesLeft(card: TinderCard) {    //Accion llamada cuando la carta va hacia la izquierda
        LabelSnackbar.text = "Deleted"
        // var statement: OpaquePointer?
        resetSetupAnimation()
        animationDismissFavTrash(viewIcon: "Trash",icon:TrashIcon)
        animationShowItem(item: shareMainButton)
        Shares.forEach{(button) in
            animationHideItem(item: button)
        }
    }
    func cardGoesRight(card: TinderCard) {   //Accion llamada cuando la carta va hacia la derecha
        LabelSnackbar.text = "Saved"
        saveNews()
        resetSetupAnimation()
        animationDismissFavTrash(viewIcon: "Fav",icon:FavoriteIcon)
        animationShowItem(item: shareMainButton)
        Shares.forEach{(button) in
            animationHideItem(item: button)
        }
    }
    
    func resetSetupAnimation(){ //Se utiliza para dejar los valores iniciales por default de las animaciones e iconos Fav y Trash
        removeObjectAndAddNewValues()
        countingForUrl()
        topIndicator.constant = CGFloat(0)
        //Animacion de FAB
        showFabInScrolling = true
        ViewIsInAnimation = false
    }
    
    func currentCardStatus(card: TinderCard, distance: CGFloat) {   //Se utiliza para saber la posicion de la carta y para animar los views(Iconos Favorito y Basura)
        customScrollBar.alpha = 0
        if distance < 0 {

            
            self.TrashIcon.frame.origin.x = -distance*0.25
            var dist: Float = Float(distance)
            self.TrashIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.0*dist)/(100-dist))), y: CGFloat(fabsf((2.0*dist)/(100-dist)))); //Se muestra Icono Basura
            TrashIcon.alpha = min(abs(distance) / 200, 1)
            
            FavoriteIcon.alpha = 0
          
        
        }
        
        if distance > 0 {

            self.FavoriteIcon.frame.origin.x = view.frame.size.width - FavoriteIcon.frame.size.width - distance*0.25
            var dist: Float = Float(distance)
            self.FavoriteIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.2*dist)/(100+dist))), y: CGFloat(fabsf((2.2*dist)/(100+dist)))); //Se muestra Icono Favorito
            FavoriteIcon.alpha = min(abs(distance) / 200, 1)
            
            
            TrashIcon.alpha = 0
           

        }
        
        if distance == 0 {
            TrashIcon.alpha = 0
            FavoriteIcon.alpha = 0
            ViewIsInAnimation = false
            print("distance == 0")
            if (shareMainButton.isHidden && showFabInScrolling){
                animationShowItem(item: shareMainButton)
            }
        }
        
        if distance != 0{
            print("Home --> currentCardStatus --> distance != 0"
                ,"\n --> !shareMainButton.isHidden:",!shareMainButton.isHidden
                ,"\n --> showFabInScrolling:",showFabInScrolling
                ,"\n --> !ViewIsInAnimation:",!ViewIsInAnimation)
            
            if !shareMainButton.isHidden && showFabInScrolling && !ViewIsInAnimation {
               ViewIsInAnimation = true
               animationHideItem(item: shareMainButton)
            }
        }
    }
}





extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
//////////////////////////////////
//////////////////////////
/*   func apiManager(opcion:Int) {  //Esta funcion es igual a apiManagerBlackJack, pero solo se ocupa cuando se selecciona un Tipo de Noticia del MenuSlide.
 print("api Manager Start")
 /*       for index in 0...1{
 print("APIMANAGER:",index)
 if index == 1{
 defaultMenu =  addMoreNews(option: opcion)
 }*/
 getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
 do {
 if let json = try? JSONSerialization.jsonObject(with: data as Data) as! [String:Any]{
 let articles = json["articles"] as! NSArray
 print("Man for Start")
 for (index,element) in articles.enumerated(){
 var art = element as! [String:Any]
 let title = art["title"] as! String
 var urlToImage = art["urlToImage"] as? String
 if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
 urlToImage = ""                                 //Indica que se pondra una imagen por default
 }
 let url = art["url"] as! String
 var src = art["source"] as! [String:Any]
 let name = src["name"] as! String
 self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage!,url: url,cate: self.kindOfNews))
 print(" HEY THERE NEWSTYPE IS :",self.kindOfNews)
 print(self.listNews.count,":",name)
 self.valueArray.append(self.listNews.count)
 }
 }
 }
 self.loadCardValues()
 self.sizeArrayListNews = self.listNews.count
 }
 print("api Manager End")
 }*/

/*
//////////////////////////
func apiManagerBlackJack() {
    
    print("apiManager BLACK JACK  START")
    for i in 0...8 {
        getDataFrom(urlString: arrayDefaultNewsAPISettings[i]) { (data) in  // Obtiene la informacion de urlNews(i) donde es el string de cada una de las API's
            do {
                print("ApiManager Start")
                var NewsType = ""
                switch(i){  //Se utiliza para seleccionar el tipo de noticia que es (health,retail..) y guardarla despues en el Coredata, tal vez seria mejor un arreglo de String
                case 0:
                    NewsType = "health"
                    break
                case 1:
                    NewsType = "retail"
                    break
                case 2:
                    NewsType = "construction"
                    break
                case 3:
                    NewsType = "entertainment"
                    break
                case 4:
                    NewsType = "environment"
                    break
                case 5:
                    NewsType = "education"
                    break
                case 6:
                    NewsType = "energy"
                    break
                case 7:
                    NewsType = "finance"
                    break
                case 8:
                    NewsType = "telecom"
                    break
                default:
                    break
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data as Data) as! [String:Any]{       //Obtiene la informacion en diccionarios apartir del "data"
                    let articlesNews = json["articles"] as! NSArray         //"articles" son los articulos que ofrecen las API`s y articlesNews es el arreglo de noticias
                    print("Man for Start")
                    for (index,element) in articlesNews.enumerated(){       //Entra al arreglo de las noticias
                        var art = element as! [String:Any]                  //art es el articulo dentro del arreglo de noticias (element)
                        let title = art["title"] as! String                 //asigna el titulo del articulo a una variable (string)
                        var urlToImage = art["urlToImage"] as? String       //asigna la url donde se obtendra la imagen (string)
                        if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                            urlToImage = ""                                 //Indica que se pondra una imagen por default
                        }
                        let url = art["url"] as! String                     //asigna url de la noticia
                        var src = art["source"] as! [String:Any]            //asigna la fuente
                        let name = src["name"] as! String                   //asigna el autor
                        print(self.listNews.count,":",name)                 //Prueba de la lista
                        
                        if self.arrayBDHome[i].arrayPreferencias {          //Apartir de las preferencias si es TRUE agregara la noticia, *falta optimizarlo*
                            self.listNews.append(Noticias(title: title,autor: name,urlToImg: (urlToImage)!,url: url,cate: NewsType)) //Agrega las noticias a listNews
                            self.valueArray.append(self.listNews.count)         //valueArray es un arreglo auxiliar
                        }
                        print("ARRAY BD HOME: ",self.arrayBDHome[i].arrayPreferencias," i:",i)  //Prueba de la BD de preferencias(Si health es TRUE o FALSE, p.ej.)
                    }
                    print(" THE REAL ARRAY NEWSType is:",NewsType)
                    print(" VALUE ARRAY :",self.valueArray.count)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
                        print("Construction off")
                    }
                    
                }
            }
            if i == 8{  //Se utiliza para saber, si ya finalizo de cargar los valores de las API`s y así empezar a cargar las vistas de las cartas.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
                    print("Construction off")
                }
                self.loadCardValues()
                self.sizeArrayListNews = self.listNews.count
            }
        }
    }
    print("ApiManager End")
}


//////////////////////////
 /* ////////////////////  Correcto(Eduardo/15/Nov)
 func imageTapped(){             //Muestra la noticia en un WebView
 print("Imaged Tapped")
 let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "WelcomeID") as! WebViewController   //Genera el WebView
 self.navigationController!.pushViewController(VC1, animated: true)    //Redirecciona al Webview
 print(currentIndex)
 if newsrefresh == 0 {
 VC1.text1 = listNews[currentIndex].url  //Obtiene la url que se usara para ver la noticia
 }else{
 if currentIndex*(newsrefresh) - listNews.count*newsrefresh < 0{
 VC1.text1 = listNews[listNews.count-1].url
 }else{
 VC1.text1 = listNews[currentIndex*(newsrefresh) - listNews.count*newsrefresh].url
 }
 }
 print(listNews.count)
 
 ///// newsrefresh es una opcion para poder volver a ver las noticias, una vez que el usuario haya visto todas las noticias.
 }
 ////////////////////  */

 
 /*    /////////////////////////////////
 func saveNews() {                   // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
 
 var currentIndexHelper = 0
 if countingHelper == 0{
 currentIndexHelper = currentIndex
 }else{
 
 if (currentIndex - countingHelper*(sizeArrayListNews)) > 1{
 print("MARK 1")
 currentIndexHelper = currentIndex - countingHelper*(sizeArrayListNews)
 }
 }
 print(" S A V E")
 let request = NSFetchRequest<NSFetchRequestResult>(entityName:"NoticiaData")
 request.returnsObjectsAsFaults = false
 print("sizeArrayListNews: ",sizeArrayListNews)
 do {
 
 var Bandera=false    //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
 let results = try context.fetch(request)
 if (results.count > 0){
 for result in results as! [NSManagedObject]{
 let prueba = result.value(forKey:"url") as? String //prueba tiene los valores (string) de url
 print("CurrentIndexHelper :",currentIndexHelper)
 print("CurrentIndex: ",currentIndex)
 let urlprueba = listNews[currentIndexHelper-1+countingHelper].url  //es la noticia que queremos guardar
 let isEqual = (prueba == urlprueba)   // Si listNews(i).url es igual a noticia que queremos guardar, ya existe esa noticia
 if isEqual {
 print ("Noticia Repetida")
 print("CurrentIndexHelper: ",currentIndexHelper)
 //  print("listNews(autor): ",listNews[currentIndexHelper-1].autor) //0 --> 19
 Bandera=true
 }
 }
 if !Bandera {  //Si no existe, guarda la noticia
 guardar()
 //     print(listNews[currentIndexHelper-1].cat)
 print("CurrentIndex: ",
 currentIndexHelper)
 }
 
 }else{//Guarda si no hay ninguna noticia
 guardar()
 //   print(listNews[currentIndex-1].cat)
 
 }
 do{
 try context.save()
 
 }catch{
 print(error)
 }
 }catch  {
 
 }
 
 }
 */
 
 
 let customRect = CGRect.init(x: Int(screenWidth - screenWidth/12), y: 0, width: 100, height: 50)


*/

/*
 var arrayMoreNewsAPIMenuSlide:[String] = ["https://newsapi.org/v2/top-headlines?q=health&apiKey=83bff4ded3954c35862369983b88c41b",   //HEALTH API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=construction&apiKey=83bff4ded3954c35862369983b88c41b",                              //CONSTRUCTION API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=retail&apiKey=83bff4ded3954c35862369983b88c41b",                                    //RETAIL API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=education&apiKey=83bff4ded3954c35862369983b88c41b",                                 //EDUCATION API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=entertainment&apiKey=83bff4ded3954c35862369983b88c41b",                             //ENTERTAINMENT API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=environment&apiKey=83bff4ded3954c35862369983b88c41b",                               //ENVIRONMENT API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=economy&apiKey=83bff4ded3954c35862369983b88c41b",                                   //ECONOMY API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=energy&apiKey=83bff4ded3954c35862369983b88c41b",                                    //ENERGY API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=telecom&apiKey=83bff4ded3954c35862369983b88c41b"]                                   //TELECOM API TOP-HEADLINE
 
 
 
 var arrayDefaultNewsAPIMenuSlide:[String] = ["https://newsapi.org/v2/everything?q=health+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",    //HEALTH API   //Arreglo que regresa el tipo de API a requerir
 "https://newsapi.org/v2/everything?q=construction+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                       //CONSTRUCTION API
 "https://newsapi.org/v2/everything?q=retail+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                             //RETAIL API
 "https://newsapi.org/v2/everything?q=education+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                          //EDUCATION API
 "https://newsapi.org/v2/everything?q=entertainment+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                      //ENTERTAINMENT API
 "https://newsapi.org/v2/everything?q=environment+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                        //ENVIRONMENT API
 "https://newsapi.org/v2/everything?q=technology+economy&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b",                                            //ECONOMYENERGY API
 "https://newsapi.org/v2/everything?q=energy+power+technology&sortBy=popularity&language=en&apiKey=83bff4ded3954c35862369983b88c41b",                           //ENERGY API
 "https://newsapi.org/v2/everything?q=communications+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b"]                                     //TELECOM API
 let arrayMoreNewsAPITypeSettings:[String] = ["https://newsapi.org/v2/top-headlines?q=health&apiKey=83bff4ded3954c35862369983b88c41b",   //HEALTH API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=retail&apiKey=83bff4ded3954c35862369983b88c41b",                                    //RETAIL API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=construction&apiKey=83bff4ded3954c35862369983b88c41b",                              //CONSTRUCTION API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=entertainment&apiKey=83bff4ded3954c35862369983b88c41b",                             //ENTERTAINMENT API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=environment&apiKey=83bff4ded3954c35862369983b88c41b",                               //ENVIRONMENT API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=education&apiKey=83bff4ded3954c35862369983b88c41b",                                 //EDUCATION API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=energy&apiKey=83bff4ded3954c35862369983b88c41b",                                    //ENERGY API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=economy&apiKey=83bff4ded3954c35862369983b88c41b",                                   //ECONOMY API TOP-HEADLINE
 "https://newsapi.org/v2/top-headlines?q=telecom&apiKey=83bff4ded3954c35862369983b88c41b"]                                   //TELECOM API TOP-HEADLINE
 var arrayDefaultNewsAPISettings:[String] = ["https://newsapi.org/v2/everything?q=health+technology&apiKey=83bff4ded3954c35862369983b88c41b",    //HEALTH API
 "https://newsapi.org/v2/everything?q=retail+technology&apiKey=83bff4ded3954c35862369983b88c41b",                                             //RETAIL API
 "https://newsapi.org/v2/everything?q=construction+technology&apiKey=99237f17c0b540fdac4d8367e206f5b2",                                       //CONSTRUCTION API
 "https://newsapi.org/v2/everything?q=entertainment+technology&apiKey=83bff4ded3954c35862369983b88c41b",                                     //ENTERTAINMENT API
 "https://newsapi.org/v2/everything?q=environment+technology&apiKey=83bff4ded3954c35862369983b88c41b",                                       //ENVIRONMENT API
 "https://newsapi.org/v2/everything?q=education+technology&apiKey=83bff4ded3954c35862369983b88c41b",                                          //EDUCATION API
 "https://newsapi.org/v2/everything?q=energy+power+technology&language=en&apiKey=83bff4ded3954c35862369983b88c41b",                          //ENERGY API
 "https://newsapi.org/v2/everything?q=technology+economy&apiKey=83bff4ded3954c35862369983b88c41b",                                           //ECONOMY API
 "https://newsapi.org/v2/everything?q=communications+technology&apiKey=83bff4ded3954c35862369983b88c41b"]                                    //TELECOM API
 
 */

/****************************************************** REQUEST *************************************************************/

/*


//////////////////////////
//MARK:
func addFirstNewsDefault(option:Int,type:String) {
    print("Home --> addFirstNewsDefault -->Start")
    for index in 0...1{
        print("Home --> addFirstNewsDefault --> index:",index)
        if index == 1{
            defaultMenu = arrayDefaultNewsAPISettings[option]
        }else{
            defaultMenu =  arrayMoreNewsAPITypeSettings[option]
        }
        getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
            do {
                if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                    if json["status"] as? String == "ok" {
                        let articles = json["articles"] as! NSArray
                        print("Home --> addFirstNewsDefault --> for Start")
                        for (index,element) in articles.enumerated(){
                            var art = element as! [String:Any]
                            let title = art["title"] as! String
                            var urlToImage = art["urlToImage"] as? String
                            if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                                //urlToImage = "Es un nil"
                                //Indica que se pondra una imagen por default
                            }
                            let url = art["url"] as! String
                            var src = art["source"] as! [String:Any]
                            let name = src["name"] as? String
                            self.listNews.append(Noticias(title: title,autor: name ?? "Unknown",urlToImg: urlToImage ?? "Nil",url: url,cate: type))
                            print(self.listNews.count,":",name ?? "Unknown Name")
                            self.valueArray.append(self.listNews.count)
                        }
                        if (self.arrayStateRequest == 0){
                            print("Home --> addFirstNewsDefault --> Inicio de peticion de carta")
                        }
                        self.arrayStateRequest += 1
                        if(self.arrayStateRequest == self.sizePreference){
                            print("Home --> addFirstNewsDefault --> arrayStateRequest  == ",self.sizePreference)
                            //  DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
                            // Some background work here
                            print("Home --> addFirstNewsDefault --> loadCardValues()")
                            //self.sizeArrayListNews = self.listNews.count
                            //self.loadCardValues()
                            //     }
                            //self.WeakSignalShow.isHidden = false
                            //self.WeakSignalShow.alpha = 1
                        }
                        
                        print("Home --> addFirstNewsDefault --> index:[",index,"]: lisNews.count:",self.listNews.count)
                        /*
                         
                         DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.5) {
                         // Some background work here
                         print("Home --> generalRequestApi -->  DispatchQueue.main self.loadCardValues()")
                         self.loadCardValues()
                         self.sizeArrayListNews = self.listNews.count
                         
                         
                         DispatchQueue.main.async {
                         // It's time to update the UI
                         print("UI updated on main queue")
                         }
                         }
                         
                         */
                        
                    }else{
                        print(json["status"] as? String ?? "testy") //Imprime en consola el "status" del servicio -> error
                        
                    }
                }
            }
        }
    }
    print("Home --> addFirstNewsDefault --> finish")
}


//////////////////////////
//MARK:
func addMoreNews(option:Int,type:String) {
    print("Home --> addMoreNews --> Start")
    for index in 0...1{
        print("Home --> addMoreNews --> index:",index)
        if index == 1{
            defaultMenu = arrayDefaultNewsAPIMenuSlide[option]
        }else{
            defaultMenu =  arrayMoreNewsAPIMenuSlide[option]
        }
        getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
            do {
                if let json = try? JSONSerialization.jsonObject(with: data as Data) as! [String:Any]{
                    let articles = json["articles"] as! NSArray
                    print("Man for Start")
                    for (index,element) in articles.enumerated(){
                        var art = element as! [String:Any]
                        let title = art["title"] as! String
                        var urlToImage = art["urlToImage"] as? String
                        if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                            urlToImage = ""                                 //Indica que se pondra una imagen por default
                        }
                        let url = art["url"] as! String
                        var src = art["source"] as! [String:Any]
                        let name = src["name"] as! String
                        self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage!,url: url,cate: type))
                        print(self.listNews.count,":",name)
                        self.valueArray.append(self.listNews.count)
                    }
                    print("Home --> addMoreNews --> index[",index,"]: lisNews.count:",self.listNews.count)
                }
            }
            
        }
    }
    print("Home --> addMoreNews --> finish")
}


//////////////////////////
//MARK:
func apiManagerMoreNews(opcion:Int) {  //Esta funcion es igual a apiManagerBlackJack, pero solo se ocupa cuando se selecciona un Tipo de Noticia del MenuSlide.
    print("Home --> apiManagerMoreNews --> start")
    for index in 0...1{
        print("Home --> apiManagerMoreNews --> index:",index)
        if index == 1{
            defaultMenu = arrayDefaultNewsAPIMenuSlide[opcion-1]
        }else{
            defaultMenu =  arrayMoreNewsAPIMenuSlide[opcion-1]
        }
        getDataFrom(urlString: defaultMenu) { (data) in   //defaultMenu fue modificado por la noticia seleccionada
            do {
                if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                    
                    if json["status"] as? String == "ok" {
                        let articles = json["articles"] as! NSArray
                        print("Response for Start")
                        for (index,element) in articles.enumerated(){
                            var art = element as! [String:Any]
                            let title = art["title"] as! String
                            var urlToImage = art["urlToImage"] as? String
                            if urlToImage == nil {                              //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                                urlToImage = ""                                 //Indica que se pondra una imagen por default
                            }
                            let url = art["url"] as! String
                            var src = art["source"] as! [String:Any]
                            let name = src["name"] as! String
                            self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage ?? "Nil",url: url,cate: self.kindOfNews))
                            print("Home --> apiManagerMoreNews --> news type is:",self.kindOfNews)
                            print(self.listNews.count,":",name)
                            self.valueArray.append(self.listNews.count)
                        }
                        print("Response End")
                        
                        print("Home --> apiManagerMoreNews --> index[",index,"]: lisNews.count:",self.listNews.count)
                    }else{
                        print(json["status"] as? String ?? "testy")
                    }
                }
            }
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
            //}
            if index == 1{
                self.loadCardValues()
                self.sizeArrayListNews = self.listNews.count
            }
        }
    }
    print("Home --> apiManagerMoreNews --> finish")
}


*/
