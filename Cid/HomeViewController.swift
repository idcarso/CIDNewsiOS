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
import FirebaseAnalytics

class HomeViewController: UIViewController {
    
    // MARK: - INSTANCES
    let protocolTransition = MenuTransition()
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var shareMainButton: UIButton!
    @IBOutlet weak var WeakSignalShow: UIView!
    @IBOutlet weak var TrashLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var TrashIcon: UIImageView!
    @IBOutlet weak var FavoriteIcon: UIImageView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var BarBottom: UIView!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var LabelSnackbar: UILabel!
    @IBOutlet weak var customScrollBar: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var topIndicator: NSLayoutConstraint!
    @IBOutlet var Shares: [UIButton]!
    @IBOutlet weak var imgLoader: UIImageView!
    
    // MARK: - VARIABLES
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayBDHome:[PreferenciaData] = []
    var currentIndex = 0
    var helpfullLabel = ""

    var currentLoadedCardsArray = [TinderCard]()
    var currentLoadedCardsArrayEspecial = [[TinderCard]]()
    var allCardsArray = [TinderCard]()
    var shareFabButton = UIButton()
    var valueArray = [Int]()//
    var valueArrayEspecial = [[Int]]()//
    var listNews = [Noticias]() // ES EL ARREGLO DONDE SE ENCUENTRAN LAS NOTICIAS
    var listNewsEspecial = [[Noticias]]()
    var shareFabInAnimation = false
    var menuShowing = false
    var shareFabShow = false
    var showFabInScrolling = true

    var newsrefresh = 0
    var realSizeArrayNews = 0
    var countingHelper = 0
    var sizeArrayListNews = 0
    var currentIndexHelper = 0 // CONTADOR QUE AYUDA A SABER QUE NÚMERO DE CARTA ESTA EN ACTIVO EN EL HOME
    var lastIndexState = -1 //Utilizado para saber la posición de los arreglos de preferencias y así siendo el ultimo que realiza la petición de noticias
    // llama al métodoo loadCardValues()
    var positionForDownloadCard = 9
    //Utilizado para descargar la siguiente cartaa la derecha
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
    "q=healthy+technology","q=retail+technology","q=construction+technology",
    "q=entertainment+technology","q=environment+technology","q=education+technology",
    "q=energy+power+technology","q=economy+technology","q=telecom+technology"]
    
    
    let urlTypeMenuSlide :[String] = [
    "q=healthy+technology","q=construction+technology","q=retail+technology",
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

    var defaultMenu:String = "https://newsapi.org/v2/everything?q=health+technology&sortBy=popularity&apiKey=83bff4ded3954c35862369983b88c41b"
    var kindOfNews: String = ""

    let typeOfNewsMenuSlide:[String] = ["health","construction","retail","education","entertainment","environment","finance","energy","telecom"]
    let typeOfNews:[String] = ["health","retail","construction","entertainment","environment","education","energy","finance","telecom"]
    
    
    // MARK: - OVERRIDES
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - LIFECYCLE VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()

        //BOTON INVISIBLE DEL MENU PARA CERRAR
        protocolTransition.buttonInvisible.addTarget(self, action: #selector(ButtonListenerInvisible(sender:)), for: .touchUpInside)
        
        self.restorationIdentifier = "HomeId"
        
        //SE VERIFICA SI ES EL PRIMER LANZAMIENTO DE LA APLICACION
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("HomeViewController --> viewDidLoad() --> Not first launch.")
        } else {
            print("HomeViewController --> viewDidLoad() --> First launch.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            inicioDB() //Pone en TRUE todas las preferencias de Settings
        }
        
        self.fetchData()  // Peticion para el CoreData a la entidad  PreferenciasData (Tiene la configuracion para saber que noticias cargar)
        
        setupStart()
        
        setupUI()
        
        setupTinderAndFabShare()
        
        //SE PRUEBA LA CONEXION A INTERNET
        if Reachability.isConnectedToNetwork(){
            WeakSignalShow.isHidden = true
            print("HomeViewController --> viewDidLoad --> Internet Connection Available!")
            generalRequestApi()  //Empieza a pedir y a mostrar las noticias en la siguiente funcion
        } else {
            print("HomeViewController --> viewDidLoad -->Internet Connection not Available!")
            WeakSignalShow.isHidden = false
        }
        
        print("HomeViewController --> viewDidLoad --> Start")
        print("HomeViewController --> viewDidLoad --> Preferencia Health :",arrayBDHome[0].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Retail :",arrayBDHome[1].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Construction :",arrayBDHome[2].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Entertainment :",arrayBDHome[3].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Environment :",arrayBDHome[4].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Education :",arrayBDHome[5].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Energy :",arrayBDHome[6].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia finance :",arrayBDHome[7].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Preferencia Telecom :",arrayBDHome[8].arrayPreferencias)
        print("HomeViewController --> viewDidLoad --> Finish \n\n")
        
        for mInd in 0...arrayBDHome.count - 1{
            if(arrayBDHome[mInd].arrayPreferencias){
                lastIndexState = mInd
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)  // Esconde el NavigationBar
        
        let firstTabC = self.tabBarController as! NavigationTabController
        firstTabC.updateTabbarIndicatorBySelectedTabIndex(index: 0)
        
        //SE VERIFICA LA CONEXION A INTERNET
        if Reachability.isConnectedToNetwork(){
            WeakSignalShow.isHidden = true

            self.fetchData()  // Peticion para el CoreData a la entidad  PreferenciasData (Tiene la configuracion para saber que noticias cargar)
            
            // HelpfullLabel es utilizado para saber, si el usuario hizo un cambio en Settings, si selecciono diferentes preferencias o no
            if helpfullLabel != "" {
                shareMainButton.isHidden = true
                positionForDownloadCard = 9
                for mInd in 0...arrayBDHome.count - 1{
                    if(arrayBDHome[mInd].arrayPreferencias){
                        lastIndexState = mInd
                    }
                }
                
                print("HomeViewController --> viewWillAppear --> Actualizar News")
                //Remueve todas las Noticias y Arreglos cargados
                currentLoadedCardsArray.removeAll()
                listNews.removeAll()
                valueArray.removeAll()
                allCardsArray.removeAll()
                currentIndex = 0
                currentIndexHelper = 0
                countingHelper = 0
                
                dismissUICard()

                //Remueve todas subvistas
                for subUIView in self.viewTinderBackGround.subviews as [UIView] {
                    if (subUIView.tag != 1011){
                        subUIView.removeFromSuperview()
                    }
                }
                
                // Vuelve a cargar las noticias, con las nuevas preferencias
                generalRequestApi()
                
                helpfullLabel = ""
            }
        } else {
            print("HomeViewController --> viewWillAppear --> Internet Connection not Available!")
            WeakSignalShow.isHidden = false
        }
        
        //OPACIDAD DEL ICONO DE OPACIDAD
        TrashIcon.alpha = 0
        FavoriteIcon.alpha = 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Cuando se da Tap a una noticia, muestra el NavigationBar para poder regresar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - FUNCTIONS
    
    // Pone en TRUE todas las preferencias, en caso de que sea la primera vez que entra, es el default
    func inicioDB(){
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

    
    func generalRequestApi() {
        print("HomeViewController --> generalRequestApi")
          for i in 0...8 {
            print("HomeViewController --> generalRequestApi --> ARRAY BD HOME: ",self.arrayBDHome[i].arrayPreferencias," i:",i)  //BD Preferencias: TRUE o FALSE
            print("HomeViewController --> generalRequestApi --> type of news Menu Slide :",typeOfNewsMenuSlide[i])
            
                //Apartir de las preferencias si es TRUE agregara la noticia, *falta optimizarlo*
                if self.arrayBDHome[i].arrayPreferencias {
                    addFirstNewsDefault(option: i,type:  typeOfNews[i])
                }
        }
        print("HomeViewController --> generalRequestApi --> ApiManager End")
    }
    
    //CARGA LAS NOTICIAS DEPENDIENDO LA SELECCION DEL MENU SLIDE EN HOME
    func specificRequestMenuSlide(optionSelected:Int) {
        
        print("HomeViewController --> specificRequestMenuSlide --> optionSelected:",optionSelected)
        print("HomeViewController --> specificRequestMenuSlide --> type of news (MenuSelected):",typeOfNewsMenuSlide[optionSelected-1])
            addFirstNewsMenuSlide(option: optionSelected-1,type:  typeOfNewsMenuSlide[optionSelected-1])
        print("HomeViewController --> specificRequestMenuSlide --> finish")
        
    }
    
    func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
   
    //Se utiliza para obtener las imagenes para de las noticias
    func getDataFrom(urlString: String, completion: @escaping (_ data: NSData)-> ()) {
            if let url = URL(string: urlString) {
                
                //Indica que sea un Session para no tenerlo en el hilo principal
                let session = URLSession.shared
                
                //Hace la peticion y espera a el resultado
                let task = session.dataTask(with: url) { (data, response, error) in
                print("HomeViewController --> getDataFrom --> Before calling completion")
                    if let data = data {
                        completion(data as NSData)
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            
            //Indica que realice la peticion
            task.resume()
            } else {
                print("HomeViewController --> getDataFrom --> URL is invalid")
            }
    }
    
    
    func loadOneCardMoreInBackground(){
        if valueArray.count > 0 {
            
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            print("HomeViewController --> loadOneCardMoreInBackground --> capCount",capCount)
            print("HomeViewController --> loadOneCardMoreInBackground --> positionForDownloadCard",positionForDownloadCard)


            
            //Quitar el FOR
            for (i,value) in valueArray.enumerated() {
                print("HomeViewController --> loadOneCardMoreInBackground --> Create Tinder Card --> i:",i,"  value:",value)
                if i >= capCount && i == positionForDownloadCard {
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        print("HomeViewController --> loadOneCardMoreInBackground --> i > capCount --> add new Card")
                        let newCard = self.createTinderCardInBackground(at: i,value: value)
                        self.allCardsArray.append(newCard)
                    }
                    //Usar un Dispatch.main y ponerle un retardo para el siguiente for
                }
            }
        }
        
    }
    
    
    func loadCardValuesInBackGround(){
        if valueArray.count > 0 {
            print("HomeViewController --> loadCardValuesInBackGround --> Start loadCardValues, valueArray.count:",valueArray.count)
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            for (i,value) in valueArray.enumerated() {
                print("HomeViewController --> loadCardValuesInBackGround --> Create Tinder Card --> i:",i,"  value:",value)
                if i >= capCount && i < 10 {
                     DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        print("HomeViewController --> loadCardValuesInBackGround --> i > capCount --> add new Card")
                        let newCard = self.createTinderCardInBackground(at: i,value: value)
                        self.allCardsArray.append(newCard)
                    }
                    //Usar un Dispatch.main y ponerle un retardo para el siguiente for
                    usleep(60000)
                }
            }
        }
    }
    
    // MARK: - ESTE ES EL METODO QUE CREA LA CARTA Y AÑADE EL GESTURE DE TAP A LA CARTA
    
    // CARGA LOS VALORES A LAS CARTAS
    func loadCardValues() {
        self.sizeArrayListNews = self.listNews.count
        print("HomeViewController --> loadCardValues --> size.ArrayListNews:",self.sizeArrayListNews)

        if valueArray.count > 0 {
            print("HomeViewController --> loadCardValues --> Start loadCardValues, valueArray.count:",valueArray.count)
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            
            for (i,value) in valueArray.enumerated() {
                print("HomeViewController --> loadCardValues --> Create Tinder Card --> i:",i,"  value:",value)
                if i < capCount {
                    print("HomeViewController --> loadCardValues --> i > capCount --> add new Card")
                        let newCard = self.createTinderCard(at: i,value: value)
                        self.allCardsArray.append(newCard)
                        self.currentLoadedCardsArray.append(newCard)
                        self.viewTinderBackGround.insertSubview(self.currentLoadedCardsArray[i], at: 0)
                    
                    print("HomeViewController --> loadCardValues --> viewTinderBackGround.reloadInput")
                    viewTinderBackGround.reloadInputViews()
                    viewTinderBackGround.updateConstraintsIfNeeded()
                    //shareMainButton.isHidden = false
                    self.animationShowItem(item: shareMainButton)
                }else{
                }
            }
        }
        
       
        
        DispatchQueue.global(qos: .background).async {
            //DispatchQueue.main.async {
                print("HomeViewController --> loadCardValues --> BG --> loadCardValuesInBackGround")
                self.loadCardValuesInBackGround() //This is the ONE!! SAVED IT!
           // }
        }
        
        print("HomeViewController --> loadCardValues --> animateCardAfterSwiping")
        animateCardAfterSwiping()
        // perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTapped))
        self.viewTinderBackGround.addGestureRecognizer(tapGesture)
        print("HomeViewController --> loadCardValues --> finish")
            
    }
    
    //ANIMACIÓN A TODAS LAS CARTAS CARGADAS
    func animateCardAfterSwiping() {
        
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
    
    // MARK: - ESTE ES EL SELECTOR QUE ES TAP GESTURE PARA LA CARTA
    
    //Muestra la noticia en un WebView
    @objc func imageTapped(){
        print("HomeViewController --> @objc func imageTapped() --> Tap en la noticia")
        
        // VERIFICA SI ALGUNA CARTA SE CARGÓ
        if listNews.count != 0 {
            // SE OBTIENE LA URL DE LA NOTICIA SELECCIONADA EN EL HOME. CON AYUDA DEL CURRENT INDEX HELPER, SE SABE QUE CARTA SE TOCO PARA OBTENER LA URL
            let urlNew = listNews[currentIndexHelper].url
            
            // SE ESCONDE LA BARRA SCROLL DEL TAB BAR
            NavigationTabController.rectShape.isHidden = true
            
            // SE CAMBIA EL COLOR DEL ICONO EN LA TAB BAR (HOME)
            self.tabBarController?.tabBar.tintColor = UIColor.init(named: "ItemNoSeleccionado")
            
            // INSTANCIA DEL STORYBOARD
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            // INSTANCIA DEL VIEW CONTROLLER DEL WEB VIEW
            guard let viewControllerWebView = storyboard.instantiateViewController(withIdentifier: "ID_WebView") as? NewWebViewController else { return }
            
            // SE ASIGNA LA URL EN LA VARIABLE DE LA CLASE DEL VIEW CONTROLLER DE LA WEB VIEW
            viewControllerWebView.urlNew = urlNew
            
            // SE MUESTRA EL VIEW CONTROLLER COMO SUBVISTA
            self.addChild(viewControllerWebView)
            self.view.addSubview(viewControllerWebView.view)
            viewControllerWebView.didMove(toParent: self)
        } else {
            print("HomeViewController --> @objc func imageTapped() --> Tap in news --> No existen noticias en el home")
        }
        // newsrefresh es una opcion para poder volver a ver las noticias, una vez que el usuario haya visto todas las noticias.
    }
    
    //Crea la Carta apartir de los arreglos, listNews y TinderCard
    func createTinderCardInBackground(at index: Int , value :Int) -> TinderCard {
        print("\nHome --> createTinderCardInBackGround --> viewTinderBackGround.height:",self.viewTinderBackGround.frame.height)
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height ) ,value : value, list: listNews)
        print("HomeViewController --> createTinderCardInBackground: before delegate Card ")
        card.delegate = self
        print("HomeViewController --> createTinderCardInBackground: return Card ")
        return card
    }
    
    //Crea la Carta apartir de los arreglos, listNews y TinderCard
    func createTinderCard(at index: Int , value :Int) -> TinderCard {
      
        self.viewTinderBackGround.updateConstraints()
        self.viewTinderBackGround.updateFocusIfNeeded()
        self.viewTinderBackGround.updateConstraints()
        self.viewTinderBackGround.layoutIfNeeded()
        self.viewTinderBackGround.frame.size.height = self.viewTinderBackGround.frame.size.height
        print("HomeViewController --> createTinderCard: ",self.viewTinderBackGround.frame.height)
        
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height ) ,value : value, list: listNews)
        print("HomeViewController --> createTinderCard: before delegate Card ")

        card.delegate = self
        print("HomeViewController --> createTinderCard: return Card ")
        return card
    }
    
    //Remueve la carta y añade nuevas cartas, utilizado despues de un swipe(izquierda o derecha)
    func removeObjectAndAddNewValues() {
       currentLoadedCardsArray.remove(at: 0)
        
        //Contador de arreglo de cartas
        currentIndex = currentIndex + 1
       // Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)  //Aparece el boton Undo
        
        // Lleva la apariencia de las cantidades de cartas
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            
            //Obtiene la carta siguiente a mostrar
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            
            // Separa las cartas, la primera de la segunda carta
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            
            // Muestra las cartas
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
            
            
            positionForDownloadCard += 1 //TODO: Verificar que este correcto para validar la posicion de la carta a descargar
            loadOneCardMoreInBackground()
            
        } else {
            if currentIndex == allCardsArray.count {
                print("HomeViewController --> removeObjectAndAddNewValues --> Reload Cards NOW!")
                positionForDownloadCard = 9
                
                //Carga las noticias de nuevo
                loadCardValues()
                
                //Ayuda a notificar que se acabaron las cartas
                countingHelper = countingHelper + 1
            }
        }
        print("HomeViewController --> removeObjectAndAddNewValues --> CurrentIndex:",currentIndex)
        
        //Ayuda a saber la cantidad de Cartas, util para saber cuando se han acabo y tiene que hacer reload
        print("HomeViewController --> removeObjectAndAddNewValues --> allCardArray.count:",allCardsArray.count)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if(self.shareMainButton.isHidden){
                self.animationShowItem(item: self.shareMainButton)
            }
        }
        
        animateCardAfterSwiping()

    }

    // Ayuda en el conteo de las noticias cuando el usuario ya recorrio todas
    func countingForUrl(){
        
        if countingHelper == 0{
            print("HomeViewController --> countingForUrl() State 0")
            print("HomeViewController --> countingForUrl --> currentIndex:\(currentIndex)")
            currentIndexHelper = currentIndex
            
        }else{
                print("HomeViewController --> countingForUrl() State 1")
                print("HomeViewController --> countingForUrl --> currentIndex:\(currentIndex)")
                currentIndexHelper = currentIndex - (countingHelper)*(sizeArrayListNews)
                
                print("HomeViewController --> countingForUrl --> sizeArrayListNews:\(sizeArrayListNews)")
                print("HomeViewController --> countingForUrl --> countingHelper:\(countingHelper)")
                print("HomeViewController --> countingForUrl --> currentIndex:\(currentIndex)")
                print("HomeViewController --> countingForUrl --> currentIndexHelper(currentIndex - (countingHelper-1)*(sizeArrayListNews)):\(currentIndexHelper)")
        }
    }
    
    // MARK: - SETUP
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
            print("HomeViewController --> arrayDefaultNewsAPISettings[",i,"] = ",arrayDefaultNewsAPISettings[i])
            print("HomeViewController --> arrayDefaultNewsAPISettings[",i,"] = ",arrayDefaultNewsAPISettings[i])
        }
        print("HomeViewController --> setupStart () Finish")
    }
    
    func setupUI(){
        
        Shares.forEach{(button) in
            button.isHidden = true
            button.layer.cornerRadius = button.frame.height / 3
        }
        
        TrashIcon.alpha = 0
        FavoriteIcon.alpha = 0  //Son los iconos que aparecen cuando realiza uno Swipe
        buttonUndo.alpha = 0
        BarBottom.alpha = 0// Barra negra donde esta ubicado el boton Undo, cuando ha realizado un Swipe
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        
        //indicatorBar.backgroundColor = UIColor.red
        indicatorBar.layer.cornerRadius = indicatorBar.frame.size.width / 2;
        customScrollBar.tag = 1011
        customScrollBar.layer.cornerRadius = customScrollBar.frame.size.width / 2;
        customScrollBar.alpha=0
        topIndicator.isActive = true
        
        print("HomeViewController --> SetupUI --> customScrollBar Height:",customScrollBar.frame.size.height)

        imgLoader.loadGif(name: "loadernews")
        view.layoutIfNeeded()
       
    }
    
    
    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
    func setupTinderAndFabShare() {
        viewTinderBackGround.layer.shadowColor = UIColor.black.cgColor
        viewTinderBackGround.layer.shadowOffset = CGSize(width: 0, height:  4)
        viewTinderBackGround.layer.shadowOpacity = 0.3
        viewTinderBackGround.layer.shadowRadius = 3
        viewTinderBackGround.layer.masksToBounds = false
        
        shareMainButton.layer.cornerRadius = shareFabButton.layer.frame.size.width/2
             
        shareMainButton.contentVerticalAlignment = .fill
        shareMainButton.contentHorizontalAlignment = .fill
        shareMainButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        shareMainButton.layer.shadowColor = UIColor.black.cgColor
        shareMainButton.layer.shadowOffset = CGSize(width: 0, height:  3)
        shareMainButton.layer.shadowOpacity = 0.3
        shareMainButton.layer.shadowRadius = 3
        shareMainButton.isHidden = true
        
    }

    // MARK: - COREDATA
    //Conexion con el CoreData
    func  fetchData()  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            arrayBDHome = try context.fetch(PreferenciaData.fetchRequest())
        }catch{
            print(error)
        }
    }

    //Guarda la informacion de las listNews (Info de las API's) en el CoreData
    func savingDefault(mType:String){
        var theNews:NSManagedObject

        if mType == "Saved"{
            theNews = NSEntityDescription.insertNewObject(forEntityName: "NoticiaData", into: context)
        }else{
            theNews = NSEntityDescription.insertNewObject(forEntityName: "RecoverData", into: context)
            theNews.setValue(Date().addingTimeInterval(60*60*24*5), forKey: "deadlineTime")
        }
        
        print("HomeViewController --> savingDefault --> currentIndex -1 : ",currentIndex)
        
        //"titulo" es el atributo de la entidad NoticiaData
        theNews.setValue(listNews[currentIndexHelper].title,forKey: "titulo")
        theNews.setValue(listNews[currentIndexHelper].urlToImg,forKey: "urlToImg")
        theNews.setValue(listNews[currentIndexHelper].url,forKey: "url")
        theNews.setValue(listNews[currentIndexHelper].autor,forKey: "autor")
        theNews.setValue(listNews[currentIndexHelper].cat,forKey: "categoria")
        
        var auxImage = UIImage()
        if (listNews[currentIndexHelper].urlToImg == "")  ||  (allCardsArray[currentIndexHelper].backGroundImageView.image == nil){
            
            //Asigna una imagen por default
            auxImage = #imageLiteral(resourceName: "ic_cidnewsiOS")
        }else{
            auxImage = allCardsArray[currentIndexHelper].backGroundImageView.image!
        }
        
        let auxiliarimg = auxImage.pngData () as NSData?
        theNews.setValue(auxiliarimg,forKey: "imageNews")
        print("HomeViewController --> savingDefault --> currentIndex -2 : ",currentIndex)

    }
    
    // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
    func saveNewsDefault(mType:String) {
        print("HomeViewController --> saveNewsDefault")
        var request:NSFetchRequest<NSFetchRequestResult>
        if mType == "Saved"{
            request = NSFetchRequest<NSFetchRequestResult>(entityName:"NoticiaData")
        }else{
            request = NSFetchRequest<NSFetchRequestResult>(entityName:"RecoverData")
        }
      
        
        request.returnsObjectsAsFaults = false
        print("HomeViewController --> saveNewsDefault --> sizeArrayListNews: ",sizeArrayListNews)
        do {
            //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
            var Bandera=false
            let results = try context.fetch(request)
            if (results.count > 0){
                print("HomeViewController --> saveNewsDefault --> currentIndexHelper:",currentIndexHelper)
                print("HomeViewController --> saveNewsDefault --> currentIndex: ",currentIndex)
                
                for result in results as! [NSManagedObject]{
                    
                    //prueba tiene los valores (string) de url
                    let prueba = result.value(forKey:"url") as? String
                    
                    //es la noticia que queremos guardar
                    let urlprueba = listNews[currentIndexHelper].url
                    
                    // Si listNews(i).url es igual a noticia que queremos guardar, ya existe esa noticia
                    let isEqual = (prueba == urlprueba)
                    if isEqual {
                        print ("HomeViewController --> saveNewsDefault --> Noticia Repetida")
                        print("HomeViewController --> saveNewsDefault --> for --> currentIndexHelper: ",currentIndexHelper)
                        Bandera=true
                    }
                }
                if !Bandera {
                    
                    //Si no existe, guarda la noticia
                    savingDefault(mType: mType)
                    print("HomeViewController --> saveNewsDefault --> currentIndex: ", currentIndexHelper)
                }
                
            }else{
                //Guarda si no hay ninguna noticia
                savingDefault(mType: mType)
            }
            do{
                try context.save()
                
            }catch{
                print(error)
            }
        }catch  {
        }
    }
    
    // MARK: - REQUEST
    func addFirstNewsDefault(option:Int,type:String) {
        print("HomeViewController --> addFirstNewsDefault -->Start")
        print("HomeViewController --> addFirstNewsDefault --> index(option):",option)
        defaultMenu = arrayDefaultNewsAPISettings[option]


        //defaultMenu fue modificado por la noticia seleccionada
            getDataFrom(urlString: defaultMenu) { (data) in
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                        if json["status"] as? String == "ok" {
                            
                            
                            /// Valida que la noticia a guardar el en Array para ser mostrado en las cartas no se repita con las eliminadas.
                            let requestData = NSFetchRequest<NSFetchRequestResult>(entityName:"RecoverData")
                            requestData.returnsObjectsAsFaults = false
                            var mSetRecover:Set<String> = [""]
                            do{
                                let mResults = try self.context.fetch(requestData)
                                if mResults.count > 0 {
                                    for mUrl in mResults as! [NSManagedObject]{
                                        
                                        mSetRecover.insert((mUrl.value(forKey:"url") as? String)!)
                                    }
                                }else{
                                    
                                }
                            }catch{
                                
                            }
                            

                            let articles = json["articles"] as! NSArray
                            print("HomeViewController --> addFirstNewsDefault --> getDataFrom -- for Start, option: \(option)")
                            for (index,element) in articles.enumerated(){
                                var art = element as! [String:Any]
                                let title =  art["title"]  as? String
                                var img = art["urlToImage"] as AnyObject
                                var urlToImage =  ""
                                if img is NSNull{urlToImage = "Nil"}
                                else{ urlToImage = art["urlToImage"] as? String ?? "Nil"}
                                let url = art["url"] as! String
                                var src = art["source"] as! [String:Any]
                                let name = src["name"] as? String
                                
                                //  Comparacion del mSet con  mSetRecover(contiene todas las noticias a recuperar)
                                let mSet:Set<String> = [art["url"] as! String]
                                
                                //TRUE si la noticia a mostrar esta en el Set de Noticias Recover
                                if mSet.isSubset(of: mSetRecover){
                                    print("HomeViewController --> addFirstNewsMenuSlide --> Noticia en RECOVER, url(title):\(title ?? "No title")")
                                }else{
                                    self.listNews.append(Noticias(title: title ?? "Untitled",autor: name ?? "Unknown",urlToImg: urlToImage ,url: url ,cate: type))
                                    print(self.listNews.count,":",name ?? "Unknown Name")
                                    self.valueArray.append(self.listNews.count)
                                }
                                
                            }
                            print("HomeViewController --> addFirstNewsDefault --> getDataFrom -- index:[",self.index,"]: lisNews.count:",self.listNews.count)
                        }else{
                            //Imprime en consola el "status" del servicio -> error
                            print(json["status"] as? String ?? "testy")
                        }
                    }
                    
                    if  (option == self.lastIndexState){
                        DispatchQueue.main.async {
                            print("HomeViewController --> addFirstNewsDefault --> getDataFrom -- do -- self.loadCardValues() -- option:\(option)")
                            self.loadCardValues()
                        }
                    }
                }
            }
        
        print("HomeViewController --> addFirstNewsDefault --> finish")
    }

    
    func addFirstNewsMenuSlide(option:Int,type:String) {
        print("HomeViewController --> addFirstNewsMenuSlide -->Start")
        print("HomeViewController --> addFirstNewsMenuSlide --> index:",option)
        defaultMenu = arrayDefaultNewsAPIMenuSlide[option]
        print("HomeViewController --> addFirstNewsMenuSlide[\(option)]:",defaultMenu)
        
        //Reinicio de variables
        
        //Reinicia la posicion
        positionForDownloadCard = 9
        countingHelper = 0
        sizeArrayListNews = 0
        countingHelper = 0
        currentIndex = 0
        
        //defaultMenu fue modificado por la noticia seleccionada
        getDataFrom(urlString: defaultMenu) { (data) in
            do {
                if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                    if json["status"] as? String == "ok" {
                        
                        
                        /// Valida que la noticia a guardar el en Array para ser mostrado en las cartas no se repita con las eliminadas.
                        let requestData = NSFetchRequest<NSFetchRequestResult>(entityName:"RecoverData")
                        requestData.returnsObjectsAsFaults = false
                        var mSetRecover:Set<String> = [""]
                        do{
                            let mResults = try self.context.fetch(requestData)
                            if mResults.count > 0 {
                                for mUrl in mResults as! [NSManagedObject]{
                                    
                                    mSetRecover.insert((mUrl.value(forKey:"url") as? String)!)
                                }
                            }else{
                                
                            }
                        }catch{
                            
                        }
                        
                        
                        let articles = json["articles"] as! NSArray
                        print("HomeViewController --> addFirstNewsMenuSlide --> for Start")
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
                            
                            //  Comparacion del mSet con  mSetRecover(contiene todas las noticias a recuperar)
                            let mSet:Set<String> = [art["url"] as! String]
                
                            //TRUE si la noticia a mostrar esta en el Set de Noticias Recover
                            if mSet.isSubset(of: mSetRecover){
                                print("HomeViewController --> addFirstNewsMenuSlide --> Noticia en RECOVER, url(title):\(title ?? "No title")")
                            }else{
                                self.listNews.append(Noticias(title: title ?? "Untitled",autor: name ?? "Unknown",urlToImg: urlToImage ,url: url ,cate: type))
                                print(self.listNews.count,":",name ?? "Unknown Name")
                                self.valueArray.append(self.listNews.count)
                            }
                            
                        }
                        print("HomeViewController --> addFirstNewsMenuSlide --> index:[",option,"]: lisNews.count:",self.listNews.count)
                        DispatchQueue.main.async {
                            print("HomeViewController --> specificRequestMenuSlide --> self.loadCardValues()")
                            self.loadCardValues()
                            self.sizeArrayListNews = self.listNews.count
                        }
                    
                    }else{
                        //Imprime en consola el "status" del servicio -> error
                        print(json["status"] as? String ?? "testy")
                    }
                }
            }
        }
        print("HomeViewController --> addFirstNewsDefault --> finish")
    }

    
    
    func dismissUICard(){
        
        if !Shares[0].isHidden {
            Shares.forEach{(button) in
                animationHideItem(item: button)
            }
        }
        
        if(!shareMainButton.isHidden){
            if !shareMainButton.isHidden  {
                animationHideItem(item: shareMainButton)
            }
        }
        
        customScrollBar.alpha = 0
        
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    //Esta funcion es igual a apiManagerBlackJack, pero solo se ocupa cuando se selecciona un Tipo de Noticia del MenuSlide.
    func apiManagerMoreNews(opcion:Int) {
        print("HomeViewController --> apiManagerMoreNews --> start")
        for index in 0...1{
            print("HomeViewController --> apiManagerMoreNews --> index:",index)
            if index == 1{
                defaultMenu = arrayDefaultNewsAPIMenuSlide[opcion-1]
            }else{
                defaultMenu =  arrayMoreNewsAPIMenuSlide[opcion-1]
            }
            //defaultMenu fue modificado por la noticia seleccionada
            getDataFrom(urlString: defaultMenu) { (data) in
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data as Data) as? [String:Any]{
                        
                        if json["status"] as? String == "ok" {

                            // Valida que la noticia a guardar el en Array para ser mostrado en las cartas no se repita con las eliminadas.
                            let requestData = NSFetchRequest<NSFetchRequestResult>(entityName:"RecoverData")
                            requestData.returnsObjectsAsFaults = false
                            var mSetRecover:Set<String> = [""]
                            do{
                                let mResults = try self.context.fetch(requestData)
                                if mResults.count > 0 {
                                    for mUrl in mResults as! [NSManagedObject]{
                                        
                                        mSetRecover.insert((mUrl.value(forKey:"url") as? String)!)
                                    }
                                }else{
                                    
                                }
                            }catch{
                                
                            }
                            
                        
                            
                            let articles = json["articles"] as! NSArray
                            print("Response for Start")
                            for (index,element) in articles.enumerated(){
                                var art = element as! [String:Any]
                                let title = art["title"] as! String
                                var urlToImage = art["urlToImage"] as? String
                                
                                //Si no hay imagen para la noticia por parte de la API (nil), le asigna un valor
                                if urlToImage == nil {
                                    
                                    //Indica que se pondra una imagen por default
                                    urlToImage = ""
                                }
                                let url = art["url"] as! String
                                
                                
                                var src = art["source"] as! [String:Any]
                                let name = src["name"] as! String
                                
                                
                                var mSet:Set<String> = art["url"] as! Set
                                

                                //TRUE si la noticia a mostrar esta en el Set de Noticias Recover
                                if mSet.isSubset(of: mSetRecover){
                                    print("HomeViewController --> apiManagerMoreNews --> Noticia en RECOVER, url(title):",title)
                                }else{
                                    self.listNews.append(Noticias(title: title,autor: name,urlToImg: urlToImage ?? "Nil",url: url,cate: self.kindOfNews))
                                    print("HomeViewController --> apiManagerMoreNews --> news type is:",self.kindOfNews)
                                    print(self.listNews.count,":",name)
                                    self.valueArray.append(self.listNews.count)
                                    
                                }
                                
                                
                                
                                
                            }
                            print("Response End")
                            
                            print("HomeViewController --> apiManagerMoreNews --> index[",index,"]: lisNews.count:",self.listNews.count)
                        }else{
                            print(json["status"] as? String ?? "testy")
                        }
                    }
                }
                
                if index == 1{
                    self.loadCardValues()
                    self.sizeArrayListNews = self.listNews.count
                }
            }
        }
        print("HomeViewController --> apiManagerMoreNews --> finish")
    }
    
    // MARK: - MENU SLIDE
    
    //Esta funcion se utiliza para hacer aparecer el MenuSlide, a través del Constrait del MenuSlide desde el boton (Menu 3 puntos)
    @IBAction func MenuHome(_ sender: Any) {
        
        NavigationTabController.rectShape.isHidden = true
        tabBarController?.tabBar.tintColor = UIColor.init(named: "ItemNoSeleccionado")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let tableViewControllerMenu = storyboard.instantiateViewController(withIdentifier: "ID_MenuSlide") as? MenuSlideTableViewController else {return}
        tableViewControllerMenu.modalPresentationStyle = .overCurrentContext
        tableViewControllerMenu.transitioningDelegate = self
        tableViewControllerMenu.didMove(toParent: self)
        present(tableViewControllerMenu, animated: true, completion: nil)
        
        tableViewControllerMenu.tapOptionMenu = {optionMenu in
            self.EventOptionMenu(optionMenu: optionMenu)
        }
    }
    
    func ShowAboutUs () {
        //MOSTRAR VIEW CONTROLLER ABOUT US
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewControllerAbout = storyboard.instantiateViewController(withIdentifier: "IDAbout") as? AboutViewController else { return }
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.addChild(viewControllerAbout)
            self.view.addSubview(viewControllerAbout.view)
            viewControllerAbout.didMove(toParent: self)
        }, completion: nil)
    }
    
    func EventOptionMenu(optionMenu:optionMenu){
        var index:Int = 0
        var mAnalyticsCategory = ""
        switch optionMenu {
        case .HEALTH:
            mAnalyticsCategory = "HEALTH"
            index = 0
        case .CONSTRUCTION:
            mAnalyticsCategory = "CONSTRUCTION"
            index = 1
        case .RETAIL:
            mAnalyticsCategory = "RETAIL"
            index = 2
        case .EDUCATION:
            mAnalyticsCategory = "EDUCATION"
            index = 3
        case .ENTERTAINMENT:
            mAnalyticsCategory = "ENTERTAINMENT"
            index = 4
        case .ENVIRONMENT:
            mAnalyticsCategory = "ENVIRONMENT"
            index = 5
        case .FINANCE:
            mAnalyticsCategory = "FINANCE"
            index = 6
        case .ENERGY:
            mAnalyticsCategory = "ENERGY"
            index = 7
        case .TELECOM:
            mAnalyticsCategory = "TELECOM"
            index = 8
        case .ABOUT:
            mAnalyticsCategory = "ABOUT"
            index = 9
        }
        print("VIEW CONTROLLER HOME -- EventOptionMenu -- mAnalyticsCategory:\(mAnalyticsCategory)")
        
        Analytics.logEvent(AnalyticsEventViewItemList, parameters: [AnalyticsParameterItemCategory: mAnalyticsCategory])
        
        if index < 9 {
            NavigationTabController.rectShape.isHidden = false
            tabBarController?.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
            self.loadMenuSlideNews(index: index)
            self.dismissUICard()
            
        } else if index == 9 {
            NavigationTabController.rectShape.isHidden = true
            tabBarController?.tabBar.tintColor = UIColor.init(named: "ItemNoSeleccionado")
            ShowAboutUs()
        }
    }
    
    // MARK: - SELECTORS
    @objc func ButtonListenerInvisible (sender: UIButton!) {
        dismiss(animated: true, completion: nil)
        NavigationTabController.rectShape.isHidden = false
        tabBarController?.tabBar.tintColor = UIColor.init(named: "ItemSeleccionado")
    }
    
    //Utilizado para borrar la informacion,vistas de las cartas y cargar los nuevos valores del menuSlide
    func MenuTappedBorrarData(opcion:Int){
        defaultMenu = selectMenu
        
        //Remueve todas las Noticias y Arreglos cargados
        currentLoadedCardsArray.removeAll()
        listNews.removeAll()
        valueArray.removeAll()
        allCardsArray.removeAll()
        currentIndex = 0
        currentIndexHelper = 0
        countingHelper = 0
        
        //Remueve todas subvistas
        for subUIView in self.viewTinderBackGround.subviews as [UIView] {
            if (subUIView.tag != 1011){
                subUIView.removeFromSuperview()
            }
        }

        selectMenu = arrayDefaultNewsAPIMenuSlide[opcion]
        
        switch opcion {
        case 0:
            kindOfNews="health"
            break
        case 1:
            kindOfNews="construction"
            break
        case 2:
            kindOfNews="retail"
            break
        case 3:
            kindOfNews="education"
            break
        case 4:
            kindOfNews="entertainment"
            break
        case 5:
            kindOfNews="environment"
            break
        case 6:
            kindOfNews="finance"
            break
        case 7:
            kindOfNews="energy"
            break
        case 8:
            kindOfNews="telecom"
            break
        default:
            kindOfNews="health"
        }
        
        specificRequestMenuSlide(optionSelected: opcion+1)
        self.shareMainButton.isHidden = true
        for shareBtn in Shares{
            shareBtn.isHidden = true
        }
        customScrollBar.alpha=0
    }
    
    // MARK: - ALERTS
    func showAlertShare(service:String){
            let alert = UIAlertController(title: "Ops!", message: "You are not connected  \(service)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    
    // MARK: - EVENT GESTURES
    
    
    // MARK: - LISTENERS CLICS
    @IBAction func ShareFBPressed(_ sender: UIButton) {
        print("HomeViewController --> ShareFBPressed --> Main Facebook Pressed")
        
        var urlTxt  = ""//URL.init(string: "")
        if currentIndexHelper - listNews.count > -1{
            print("HomeViewController --> ShareFBPressed --> ImageTap 1")
            //urlTxt = URL.init(string: listNews[0].url)
            urlTxt = listNews[0].url
        }else{
            print("HomeViewController --> ShareFBPressed --> ImageTap 2")
            //urlTxt = URL.init(string: listNews[currentIndexHelper].url)
            urlTxt = listNews[currentIndexHelper].url
        }
        
        print("HomeViewController --> ShareFBPressed --> urlTxt:"+urlTxt)
        
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
    
    //EVENTO QUE LANZA EL FLOATING ACTION BOTTON
    @IBAction func shareFabPressed(_ sender: Any) {
        print("HomeViewController --> shareFabPressed")
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
    
    @IBAction func ShareTWPressed(_ sender: UIButton) {
        print("HomeViewController --> ShareTWPressed --> Main Twitter Pressed")
        
        var urlTxt = ""
        if currentIndexHelper - listNews.count > -1{
            print("HomeViewController --> ShareTWPressed --> ImageTap 1")
            urlTxt = listNews[0].url
        }else{
            print("HomeViewController --> ShareTWPressed --> ImageTap 2")
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
    
    @IBAction func ShareWAPressed(_ sender: UIButton) {
        print("HomeViewController --> ShareWAPressed --> Main Whatsapp Pressed")
        var msg = ""
        if currentIndexHelper - listNews.count > -1{
            print("HomeViewController --> ShareWAPressed --> ImageTap 1")
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
                    print("HomeViewController --> ShareWAPressed --> WhatsApp accessed successfully")
                } else {
                    self.showAlertShare(service: "Whatsapp")
                }
            }
        }
    }
  
    // MARK: - ANIMATIONS
    func animationDismissFavTrash(viewIcon:String, icon:UIImageView){
        var direction = 0
        if viewIcon == "Fav" {
            direction = Int(view.frame.size.width)
        }else{
            direction = 0
        }
        
        print("HomeViewController --> animationDismissFavTrash --> icon.frame.origin",icon.frame.origin)
        UIView.animate(withDuration: 0.3, animations: {
            icon.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            icon.frame.origin.x = CGFloat(direction)
        }, completion: { (finished: Bool) in
                icon.alpha = 0
        })
        
    }
    
    func animationShowItem(item: UIButton){
        if(item.isHidden){
            print("HomeViewController --> animationShowItem --> Start")
            item.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            item.isHidden = false
            
            UIView.animate(withDuration: 0.2, animations: {
                item.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (finished: Bool) in })
        }
        print("HomeViewController --> animationShowItem --> Finish")
    }
    
    func animationHideItem(item: UIButton){
        if(!item.isHidden){
            print("HomeViewController --> animationHideItem --> Start")
            item.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.2, animations: {
                item.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: { (finished: Bool) in
                item.isHidden = true
            })
            
        }
        print("HomeViewController --> animationHideItem --> Finish")
    }
    
    func animationRotateFab(){
        print("HomeViewController --> animationRotateMainFab")
        
        print("HomeViewController --> animationRotateMainFab --> Animation rotation is GOING")
        let imageRotation = 90
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .allowUserInteraction], animations:{
            self.shareMainButton.transform = CGAffineTransform(rotationAngle: CGFloat(imageRotation))
        }, completion: { (t) -> Void in
            self.shareMainButton.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.shareFabInAnimation = false
        })
    }
    
    @objc func loadMenuSlideNews(index:Int){
        
        MenuTappedBorrarData(opcion: index)
        viewTinderBackGround.isUserInteractionEnabled = true
        Shares[2].isUserInteractionEnabled = true
        shareMainButton.isUserInteractionEnabled = true

    }
    
}
//////////////////////////////////

extension HomeViewController: TinderCardDelegate{
 
    func movingScrollBar(initialDistance: Float,currentDistance: Float){
        
        let percentScrolling = (currentDistance/initialDistance)*100   //100%e
        let newPosition = (Float(customScrollBar.frame.size.height - indicatorBar.frame.size.height)/100)*percentScrolling
        print("HomeViewController --> TinderCardDelegate --> movingScrollBar --> initialDistance(All distance Bar):",initialDistance)
        print("HomeViewController --> TinderCardDelegate --> movingScrollBar --> currentDistance:",currentDistance)
        print("HomeViewController --> TinderCardDelegate --> movingScrollBar --> Porcentaje: ",percentScrolling)
        print("HomeViewController --> TinderCardDelegate --> movingScrollBar --> newPosition:",newPosition)
        print("HomeViewController --> TinderCardDelegate --> movingScrollBar --> topIndicator Max:",customScrollBar.frame.size.height - indicatorBar.frame.size.height)
        
        if (newPosition > -4 && newPosition < (Float(customScrollBar.frame.size.height - indicatorBar.frame.size.height) + 4)) {
            topIndicator.constant = CGFloat(newPosition)
        }
        
        self.customScrollBar.alpha = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.scrollBarIsHidding = false
        })
        
        if !scrollBarIsHidding {
            scrollBarIsHidding = true
            UIView.animate(withDuration: 0.5, animations: {
                self.customScrollBar.alpha = 0
            },completion: {(finished: Bool) in
                self.scrollBarIsHidding = false
            })
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
        } else {
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
    
    // MARK: - EVENTOS DE LA ANIMACION DE LA CARTA
    func cardGoesLeft(card: TinderCard) {    //Accion llamada cuando la carta va hacia la izquierda
        
        LabelSnackbar.text = "Deleted"
        
        saveNewsDefault(mType: "Trash")
        
        animationDismissFavTrash(viewIcon: "Trash",icon:TrashIcon)
        animationShowItem(item: shareMainButton)
        resetSetupAnimation()
        Shares.forEach{(button) in
            animationHideItem(item: button)
        }
        
    }
    
    func cardGoesRight(card: TinderCard) {   //Accion llamada cuando la carta va hacia la derecha
        LabelSnackbar.text = "Saved"
        
        saveNewsDefault(mType: "Saved")
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
            /*
            print("ANIMACION --> IZQUIERDA")
            self.TrashIcon.layer.removeAllAnimations()
            self.TrashIcon.frame.origin.x = -distance*0.25
            let dist: Float = Float(distance)
            self.TrashIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.0*dist)/(100-dist))), y: CGFloat(fabsf((2.0*dist)/(100-dist)))); //Se muestra Icono Basura
            TrashIcon.alpha = min(abs(distance) / 200, 1)
            FavoriteIcon.alpha = 0
            */
            self.TrashIcon.layer.removeAllAnimations()
            // DISTANCIA DE LA CARGA DESDE SU ORIGEN
            let distanciaCarta:Float = Float(distance)
            // TAMAÑO DEL ICONO. SE MUESTRA EL ICONO DE BASURA
            self.TrashIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.0*distanciaCarta)/(100-distanciaCarta))), y: CGFloat(fabsf((2.0*distanciaCarta)/(100-distanciaCarta))));
            // OPACIDAD DEL ICONO DE BASURA
            TrashIcon.alpha = min(abs(distance) / 200, 1)
            // TRASLADO DEL ICONO
            self.TrashIcon.frame.origin.x =  -distance * 0.25
        }
        
        if distance > 0 {
            /*
            print("ANIMACION --> DERECHA")
            self.FavoriteIcon.layer.removeAllAnimations()
            self.FavoriteIcon.frame.origin.x = view.frame.size.width - FavoriteIcon.frame.size.width - distance*0.25
            print("ANIMACION --> ORIGIN.X --> \(self.view.frame.size.width) - \(self.FavoriteIcon.frame.size.width) - \(distance * 0.25) = \(view.frame.size.width - FavoriteIcon.frame.size.width - distance*0.25)")
            let dist: Float = Float(distance)
            // TAMAÑO DEL ICONO. SE MUESTRA EL ICONO DE FAVORITO
            self.FavoriteIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.2*dist)/(100+dist))), y: CGFloat(fabsf((2.2*dist)/(100+dist))));
            // OPACIDAD DEL CIONO FAVORITO
            FavoriteIcon.alpha = min(abs(distance) / 200, 1)
            
            TrashIcon.alpha = 0
            */
            self.FavoriteIcon.layer.removeAllAnimations()
            // DISTANCIA DE LA CARGA DESDE SU ORIGEN
            let distanciaCarta:Float = Float(distance)
            // TAMAÑO DEL ICONO. SE MUESTRA EL ICONO DE FAVORITO
            self.FavoriteIcon.transform = CGAffineTransform(scaleX: CGFloat(fabsf((2.2*distanciaCarta)/(100+distanciaCarta))), y: CGFloat(fabsf((2.2*distanciaCarta)/(100+distanciaCarta))));
            // OPACIDAD DEL ICONO FAVORITO
            FavoriteIcon.alpha = min(abs(distance) / 200, 1)
            // TRASLADO DEL ICONO
            self.FavoriteIcon.frame.origin.x = view.frame.size.width - FavoriteIcon.frame.size.width - distance*0.25
        }
        
        if distance == 0 {
            print("ANIMACION --> ORIGEN")
            TrashIcon.alpha = 0
            FavoriteIcon.alpha = 0
            ViewIsInAnimation = false
            print("distance == 0")
            if (shareMainButton.isHidden && showFabInScrolling){
                animationShowItem(item: shareMainButton)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    if (self.shareMainButton.isHidden && self.showFabInScrolling){
                        self.animationShowItem(item: self.shareMainButton)
                    }
                })
            }
            
        }
        
        if distance != 0{
            print("HomeViewController --> currentCardStatus --> distance != 0"
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

//  MARK:- UIViewControllerRestoration
extension HomeViewController: UIViewControllerRestoration{
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        if let storyboard = coder.decodeObject(forKey: UIApplication.stateRestorationViewControllerStoryboardKey) as? UIStoryboard{
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeId") as? HomeViewController{
                return vc;
            }
        }
        return nil;
    }
    
}

extension HomeViewController:UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return protocolTransition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return protocolTransition
    }
}
