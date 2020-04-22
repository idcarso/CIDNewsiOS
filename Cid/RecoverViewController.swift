//
//  ViewTableRecoverController.swift
//  Cid
//
//  Created by Mac CTIN  on 20/02/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Enumerado de las categorias para dejar los valores como constante
enum Types:String  {
    case Health = "HEALTH"
    case Construction = "CONSTRUCTION"
    case Retail = "RETAIL"
    case Education = "EDUCATION"
    case Entertainment = "ENTERTAINMENT"
    case Environment = "ENVIRONMENT"
    case Finance = "FINANCE"
    case Energy = "ENERGY"
    case Telecom = "TELECOM"
    case Reset = "RESET ALL"

}

class RecoverViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    //MARK:- VARIABLES
    let TAG:String = "RecoverViewController.swift"
    var banderaBorrar = false
    var banderaDeep = true
    var flagIsNews:Bool?    //Bandera que notifica si hay noticias o no
    var ListNewsRecover:[NoticiaRecover] = []   //Desde ListNewsRecover es posible acceder al Coredata
    var arrayListNews: [Int] = []   //Array para saber el numero de noticias
    let BasuraIcon = UIButton(type: .system)
    let image = UIButton(type: .system)
    var roundButton = UIButton()
    let label = UILabel()
    var imageAspect = 0 as CGFloat
    var cell = FavoritesTableViewCell() //cell es una celda con los UI declarados
    var tapGesture1 = UITapGestureRecognizer()
    var arrayBoolAux:[Bool] = []    //Array auxiliar para poder guardar los elementos a borrar
    var arrayBoolAuxMenuSelected:[Bool] = []    //Array auxiliar para poder guardar los elementos a borrar

    var WatchFav = "" //Se utiliza para ser cambiado por un string (puede ser "health","retail"..) ya que nos servira al momento de hacer un Filtro (FILTER) de noticias
    var banderaWatch = false
    var viewGreenBar = UIView()
    var divisionRows = 0
    var backItem = UIBarButtonItem()
    var flagFilterWatch = false
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var isNewShow:Bool? //Bandera que indica si existen noticias o no.
    
    // MARK: - IB OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CloseIcon: UIButton!
    @IBOutlet weak var MenuInside: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var insideViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var favoritesView: UIView!
    @IBOutlet var MenuButtons: [UIButton]!
    @IBOutlet weak var warningTextView: UITextView!
    
    
    //MARK:- LIFECYCLE VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RecoverViewController --> viewDidLoad")
        
        //Este array TODOS sus elementos seran TRUE,
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        print("RecoverViewController --> arrayBoolAux count:",arrayBoolAux.count)
        
        //Configuracion inicial del navegationBarItems
        setupOnceNavigationBarItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchData()
        self.tableView.reloadData()
        
        //Indica que no va a borrar
        banderaBorrar = false
        
        //Bandera auxiliar al borrado
        banderaDeep = false
        
        //Configuraciones de labels y botones
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.roundButton = UIButton(type: .custom)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        self.roundButton.isHidden = true
        self.view.layoutIfNeeded()

        //configuracion del menu FILTER (colores)
        MenuButtons.forEach { (button) in
            button.isHidden = true
            button.backgroundColor = UIColor.init(red: 35/255, green: 87/255, blue: 132/255, alpha: 1)
            button.titleLabel?.attributedText = NSAttributedString(string: (button.titleLabel?.text)!, attributes:[ NSAttributedString.Key.kern: 1.5])
        }
        
        //No se muestra el menu FILTER
        MenuInside.isHidden = true
        MenuInside.backgroundColor = UIColor.init(red: 0, green: 55/255, blue: 111/255, alpha: 1)
        arrayListNews = [Int](repeatElement(0, count: ListNewsRecover.count)) //Se inicializa el array con 0`s dependiendo del tamaño de noticias
        self.tableView.tableFooterView? = footerView
        
        isNewShow = getCountNews(arrayNews: arrayListNews)
        print(TAG, " --> viewDidLoad() --> isNewShow: ", isNewShow!)
        if isNewShow! == true {
            warningTextView.isHidden = false
            CloseIcon.isHidden = true
        } else {
            warningTextView.isHidden = true
            CloseIcon.isHidden = false
            setAnimationButtonAlpha(button: CloseIcon)
        }
    }
    
    //MARK:- LIFECYCLE VIEW CONTROLLER
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("RecoverViewController --> viewWillAppear")
       
        deletedDeadlines()

        setupNavigationBarItems()
        //Este array, TODOS sus elementos seran TRUE, porque al momento de dar tap a eliminar tiene que mostrar el Icono de Basura(Color rojo) en todos los elementos
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        print("RecoverViewController --> arrayBoolAux count:",arrayBoolAux.count)

        self.fetchData()
        banderaWatch = false
        tableView.allowsSelection = true
        
        //Habilita el scroll y selection para la tableview, ya que al momento de abrir FILTER esta deshabilitado
        tableView.isScrollEnabled = true
        self.tableView.reloadData()
        banderaBorrar = false
        image.isHidden = false
        
        MenuButtons.forEach { (button) in
            button.isHidden = true
        }
        
        MenuInside.isHidden=true
        
        //Se configura para que todos los Icoonos basura(rojo) se vuelvan a ver
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        banderaDeep = false
        
        //SI hay noticias, muestra las noticias
        if (ListNewsRecover.count > 0 ) {
            print("RecoverViewController --> BEGINNING LIST NEWS COUNT :",ListNewsRecover.count)
            BasuraIcon.isHidden = false
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            banderaWatch = false
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else { //Si no hay, muestra el view1 (barra verde con label "GO & SAVE..")
            
        }
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        self.roundButton.isHidden = true
        
        if isNewShow! == false {
            isNewShow = getCountNews(arrayNews: arrayListNews)
            if isNewShow! == true {
                warningTextView.isHidden = false
                CloseIcon.isHidden = true
            } else {
                warningTextView.isHidden = true
                CloseIcon.isHidden = false
                setAnimationButtonAlpha(button: CloseIcon)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        //Muestra el floating button (icono inferior derecho basura)
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.setImage(UIImage(named: "ic_recover_avatar"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
        roundButton.layer.shadowColor = UIColor.darkGray.cgColor
        roundButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        roundButton.layer.shadowOpacity = 0.6
    }
    
    //MARK:- OVERRIDES TABLE VIEW CONTROLLER
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var aux = 0
        arrayListNews = [Int](repeatElement(0, count: ListNewsRecover.count))
        
        //SI banderaWatch es TRUE, noticias por CATEGORIA
        if banderaWatch{
            
            if ListNewsRecover.count > 0 {
                for index in 0...ListNewsRecover.count - 1{
                    
                    //Si encuentra (WatchFav es un string p.ej "telecom") la misma categoria en el ListNewsRecover
                    if WatchFav == ListNewsRecover[index].categoria! {
                        aux += 1
                        // Este Array son las cantidad de noticias que existen y guarda su ubicacion en el ListNewsRecover del CoreData
                        arrayListNews[aux-1] = index
                        print("RecoverViewController --> numberOfRowsInSection --> ArrayListNews [",aux-1,"]","  Index: ",index)
                    }
                }
                
                //Este array TODOS sus elementos seran TRUE
                arrayBoolAuxMenuSelected = [Bool](repeatElement(true, count: aux))
                tableView.alpha = 1
                
                //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
                //CloseIcon.alpha = 0
                flagFilterWatch = false
                
                //Numero de noticias totales despues en FILTER
                aux = arrayBoolAuxMenuSelected.count
                
            print("RecoverViewController --> numberOfRowsInSection --> arrayBoolAuxMenu aux : ",aux)
            }
        } else {
            flagFilterWatch = false
            
            //Numero de noticias totales
            aux = ListNewsRecover.count
        }
        
        
        print("RecoverViewController --> numberOfRowsInSection --> aux:",aux)
        //Al final aux, sera el numero de noticias(con categoria seleccionada) o numero de noticias totales
        return aux
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Si es TRUE significa que selecciono una opcion del MENU FILTER
        if banderaWatch {
            print("RecoverViewController --> cellForRowAt --> banderaWatch TRUE")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
            cell.AvatarFav?.image = UIImage(data: ListNewsRecover[arrayListNews[indexPath.row]].imageNews! as Data)
            cell.AvatarFav.layer.borderWidth = 0
            cell.AvatarFav.layer.masksToBounds = false
            cell.AvatarFav.layer.cornerRadius = cell.AvatarFav.frame.size.height/2
            cell.AvatarFav.clipsToBounds = true
            
            //Asigna los titulos y autores correspondientes a las celdas
            cell.TitleFav?.text = ListNewsRecover[arrayListNews[indexPath.row]].titulo
            cell.AutorFav?.text = ListNewsRecover[arrayListNews[indexPath.row]].autor
            if  arrayListNews.count == 0{
                flagFilterWatch = true
            }
            if !arrayBoolAux[indexPath.row]{
                cell.BasuraIconAvatar.isHidden = false
                cell.BasuraIconAvatar.image = UIImage.init(named: "ic_recover_avatar")
            }
            else{
                cell.BasuraIconAvatar.isHidden = true
            }

        } else { // Si es FALSE es la configuracion normal
            //Config Normal
            print("banderaWatch FALSE")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
            
            cell.AvatarFav?.image = UIImage(data: ListNewsRecover[indexPath.row].imageNews!)
            cell.AvatarFav.layer.borderWidth = 0
            cell.AvatarFav.layer.masksToBounds = false
            cell.AvatarFav.layer.cornerRadius = cell.AvatarFav.frame.size.height/2
            cell.AvatarFav.clipsToBounds = true
            cell.TitleFav?.text = ListNewsRecover[indexPath.row].titulo
            cell.AutorFav?.text = ListNewsRecover[indexPath.row].autor
            
            let now = Date()
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute,.hour,.day, .weekOfMonth]
            formatter.unitsStyle = .abbreviated
            let end = ListNewsRecover[indexPath.row].deadlineTime
            let interval = end?.timeIntervalSince(now)
            if !(interval?.isLess(than: 0))!{
                
                let timeLeft = formatter.string(from: now, to: end!)!
                cell.TimeLeft.text = timeLeft
            }
            
            if  ListNewsRecover.count == 0{
                noNewsShow()
                flagFilterWatch = true
            }
            
            cell.BasuraIconAvatar.isHidden = true
            
            if arrayBoolAux.count > 0{
                if !arrayBoolAux[indexPath.row]{
                    cell.BasuraIconAvatar.isHidden = false
                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_recover_avatar")
                }
                else{
                    cell.BasuraIconAvatar.isHidden = true
                }
            }
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Al seleccionar UNA celda si banderaBorrar es TRUE signfica que esta en la opcion de RECUPERAR, y que va a SELECCIONAR las celdas que quiere recuperar.
        print("RecoverViewController --> didSelectRow -- Start Erasing ? ")
        //Este array sera utilizado para saber que noticia borrar(posicion)
        if arrayBoolAux[indexPath.row] {
            arrayBoolAux[indexPath.row] = false
            print("Marcado? NO!")
        }else{
            arrayBoolAux[indexPath.row] = true
            print("Marcado? YES!")
        }
        
        print("RecoverViewController --> didSelectRow --> You tapped cell number \(indexPath.row).")
        if banderaWatch{
            print(" Delete in  Menu Selected")
            //Este array sera utilizado para saber que noticia borrar(posicion)
            if arrayBoolAuxMenuSelected[indexPath.row] {
                arrayBoolAuxMenuSelected[indexPath.row] = true
                print("MARK? SAVED!")
            }else{
                arrayBoolAuxMenuSelected[indexPath.row] = false
                print("MARK? DELETE!")
            }
        }else{}
        if arrayBoolAux.contains(false){
            if self.roundButton.isHidden {
                animationShowFabRecover()
            }
        }else{
            if !self.roundButton.isHidden{
                animationHideFabRecover()
            }
        }
        //Recarga los valores de la tableview
        tableView.reloadData()
    }
    
    //MARK:- FUNCTIONS
    
    func deletedDeadlines() {
        //numax en este contexto es el ARRAY de las POSICIONES del total de noticias que debe borrar
        let numax = ListNewsRecover.count - 1
        if numax >= 0 {
            print("Start Deleting..")
            for n in (0...numax).reversed() {
                //numax sera el numero de elementos a borrar el conteo es REVERSIVO, ya que eliminara del ultimo elemento al primero
                
                //Inicio de la eliminacion
                let indexPath = IndexPath(row: n, section: 0)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = delegate.persistentContainer.viewContext
                
                //Elimina el registro del CoreData
                let now = Date()
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute,.hour,.day, .weekOfMonth]
                formatter.unitsStyle = .abbreviated
                let end = ListNewsRecover[indexPath.row].deadlineTime
                let interval = end?.timeIntervalSince(now)
                if (interval?.isLess(than: 0))! {
                    print("Delete ByInterval:",interval ?? "00")
                    let context:NSManagedObjectContext = managedObjectContext
                    context.delete(ListNewsRecover[n] as NSManagedObject)
                    
                    //Elimina del CoreData
                    ListNewsRecover.remove(at: n)
                }
                
                //Remueve de la Lista general de Noticias
                print("SIZE Array Booleano: ",arrayBoolAux.count)
                print("SIZE List News :",ListNewsRecover.count)
                print("SIZE TableView :",tableView.contentSize)
                delegate.saveContext()
                print("Deleted")
                
            }
        }
    }
    
    /// Función que muestra el menu filter (Default)
    func filtershow() {
        self.navigationItem.rightBarButtonItem?.isEnabled=true
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        tableView.alpha = 1
    }
    
    func noNewsShow() {
        label.text = "REMOVED"
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        roundButton.isHidden = false
        
        tableView.alpha = 0
        
        image.isHidden = true
        //CloseIcon.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.CloseIcon.alpha = 1.0
        })
        
        if ListNewsRecover.count == 0 {
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
        } else {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            banderaBorrar = false
            banderaDeep = false
            image.isHidden = banderaBorrar
            roundButton.isHidden = false
            flagFilterWatch = false
            favoritesView.bringSubviewToFront(MenuInside)
        }
    }
    
    /// Función que configura la navigation bar.
    private func setupOnceNavigationBarItems(){
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
        btnProfile.layer.cornerRadius = 6.0
        btnProfile.contentRect(forBounds: rect)
        btnProfile.setImage(UIImage.init(imageLiteralResourceName: "ic_trash_pink"), for: .normal)
        btnProfile.layer.masksToBounds = true
        
        //Crea un nuevo button
        let filterButton = UIButton()
        
        //Coloca imagen al button
        filterButton.setImage(UIImage(named: "ic_filter_white"), for: UIControl.State.normal)
        filterButton.addTarget(self, action: #selector(RecoverViewController.filterTapped), for: .touchUpInside)
        
        //Coloca el frame
        filterButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let barButton = UIBarButtonItem(customView: filterButton)
        
        //Asigna el button a la navigation bar
        self.navigationItem.rightBarButtonItem = barButton
        
        //Configuracion del label
        label.text = "REMOVED"
        label.textColor = UIColor.white
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        label.isUserInteractionEnabled = true
        label.frame.size.width = 170
        
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
    }
    
    /// Función que configura los items del navigation bar
    private func setupNavigationBarItems(){
        flagFilterWatch = false
        tableView.alpha = 1
        //CloseIcon.alpha = 0  //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
    }
    
    /// Función que oculta el menú filter
    func RecursiveButtonHide(){
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuInside.backgroundColor = UIColor.clear
            self.stackViewConstraintBottom.constant =  self.view.frame.size.height
            self.view.layoutIfNeeded()
        }, completion:{(finished:Bool) in
            self.view.layoutIfNeeded()
            self.MenuInside.isHidden=true
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true})
    }
    
    /// Función que muestra el menú filter
    func RecursiveButtonShow(){
        
        UIView.animate(withDuration: 0.37, animations: {
            self.MenuInside.isHidden=false
            self.MenuInside.backgroundColor = UIColor.init(red: 0, green: 55/255, blue: 111/255, alpha: 1)
            self.stackViewConstraintBottom.constant =  0
            self.view.layoutIfNeeded()
            
        }, completion:{(finished:Bool) in
            self.MenuInside.isHidden=false
            self.tableView.allowsSelection = false
            self.tableView.isScrollEnabled = false
            self.view.layoutIfNeeded()
        })
        
        
        print("RecoverViewController --> RecursiveButtonShow --> banderaWatch \(banderaWatch)")
        print("RecoverViewController --> RecursiveButtonShow --> MenuButtons.count \(self.MenuButtons.count)")

        
        if banderaWatch{
            UIView.animate(withDuration: 0.077, animations: {
                self.MenuButtons[9].isHidden = false
            })
        }else{
            self.MenuButtons[9].isHidden = true
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.MenuButtons[8].isHidden = false
        })
        UIView.animate(withDuration: 0.133, animations: {
            self.MenuButtons[7].isHidden = false
        })
        UIView.animate(withDuration: 0.166, animations: {
            self.MenuButtons[6].isHidden = false
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuButtons[5].isHidden = false
        })
        
        UIView.animate(withDuration: 0.233, animations: {
            self.MenuButtons[4].isHidden = false
        })
        
        UIView.animate(withDuration: 0.266, animations: {
            self.MenuButtons[3].isHidden = false
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.MenuButtons[2].isHidden = false
        })
        UIView.animate(withDuration: 0.333, animations: {
            self.MenuButtons[1].isHidden = false
        })
        UIView.animate(withDuration: 0.366, animations: {
            self.MenuButtons[0].isHidden = false
        })
    }
    
    /// Función que obtiene la imágen desde una URL
    /// - Parameters:
    ///   - url_str: URL de la imágen
    ///   - imageView: UIImageView para mostrar la imágen
    func get_image(_ url_str:String, _ imageView:UIImageView) {
        //Al momento de solicitar una imagen por medio de URL, y regresa  algo diferente a un String, url_str sera igual a  ""
        print("TEST 1: ",url_str)
        if url_str == "" {
            //Asigna una imagen por default
            imageView.image = #imageLiteral(resourceName: "LOGO_HAND")
        } else {  //Si no, hara una peticion mediante URLSession
            let url:URL = URL(string: url_str)!
            let session = URLSession.shared
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in if data != nil {
                let image = UIImage(data: data!)
                if(image != nil) {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        imageView.alpha = 1
                        UIView.animate(withDuration: 0.5, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
                }
            })
            task.resume()
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    /// Función que guarda la información de las listNews (Info de las API's) en el CoreData recover
    /// - Parameter urlIndex: índice del arreglo de url
    func savingNews(_ urlIndex:Int){
        let theNews = NSEntityDescription.insertNewObject(forEntityName: "NoticiaData", into: context)
        //"titulo" es el atributo de la entidad NoticiaData
        theNews.setValue(ListNewsRecover[urlIndex].titulo,forKey: "titulo")
        theNews.setValue(ListNewsRecover[urlIndex].urlToImg,forKey: "urlToImg")
        theNews.setValue(ListNewsRecover[urlIndex].url,forKey: "url")
        theNews.setValue(ListNewsRecover[urlIndex].autor,forKey: "autor")
        theNews.setValue(ListNewsRecover[urlIndex].categoria,forKey: "categoria")
        theNews.setValue(ListNewsRecover[urlIndex].imageNews,forKey: "imageNews")
    }
    
    /// Función que se utiliza para guardar la noticia (cuando se hace "swipe right")
    /// - Parameter urlToSave: índice de la URL
    func saveNews(_ urlToSave:Int) {
        print(" S A V E")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"NoticiaData")
        request.returnsObjectsAsFaults = false
        do {
            //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
            var Bandera=false
            let results = try context.fetch(request)
            if (results.count > 0){
                //es la noticia que queremos guardar
                let urlprueba = ListNewsRecover[urlToSave].url
                for result in results as! [NSManagedObject]{
                    //prueba tiene los valores (string) de url
                    let prueba = result.value(forKey:"url") as? String
                    // Si listNews(i).url es igual a noticia que queremos guardar, ya existe esa noticia
                    let isEqual = (prueba == urlprueba)
                    if isEqual {
                        print ("Noticia Repetida")
                        print("ListNews CurrentIndexHelper: ",urlToSave)
                        Bandera=true
                    }
                }
                //Si no existe, guarda la noticia
                if !Bandera {
                    savingNews(urlToSave)
                    print("CurrentIndex: ",urlToSave)
                }
            }else{  //Guarda si no hay ninguna noticia
                savingNews(urlToSave)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }catch  {
        }
    }
    
    /// Función que realiza la conexión con CoreData
    func  fetchData()  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            ListNewsRecover = try context.fetch(NoticiaRecover.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    func animationShowFabRecover(){
        self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.roundButton.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.roundButton.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: {
                        (finished: Bool) in
                        //self.addShadowForRoundedButton(view: self.view, button: self.roundButton, opacity:1)
                        
        })
    }
    
    func animationHideFabRecover(){
       // removeFABShadow()
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)},
                       completion: { (finished:Bool) in self.roundButton.isHidden = true})
    }
    
    func addShadowForRoundedButton(view: UIView, button: UIButton, opacity: Float = 1) {
        let shadowView = UIView()
        shadowView.tag=1010
        shadowView.backgroundColor = UIColor.black
        shadowView.layer.opacity = opacity
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.55
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        shadowView.layer.cornerRadius = button.bounds.size.width / 2
        shadowView.frame = CGRect(origin: CGPoint(x: button.frame.origin.x+3, y: button.frame.origin.y+3), size: CGSize(width: button.bounds.width-6, height: button.bounds.height-6))
        self.view.addSubview(shadowView)
        view.bringSubviewToFront(button)
    }
    
    func removeFABShadow(){
        for subview in self.view.subviews {
            if (subview.tag == 1010) {
                subview.isHidden = true
                subview.removeFromSuperview()
            }
        }
    }
    
    
    /// Función que verifica si existen noticias o no para mostrar en el view controller.
    /// - Parameter arrayNews: array de tipo entero
    /// - Returns: answer de tipo bool. True: hay noticias || False: no hay noticias
    private func getCountNews(arrayNews:[Int]) -> Bool {
        var answer = false
        if arrayNews.count > 0 {
            answer = true
        } else {
            answer = false
        }
        return answer
    }
    
    
    /// Función que configura la animación a un objeto de tipo UIButton modificando el atributo alpha.
    /// - Parameter button: Objeto de tipo UIButton
    private func setAnimationButtonAlpha(button:UIButton) {
        button.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
        })
    }
    
    //MARK:- IB ACTIONS
    
    /// IB Action que es la función de recuperar la noticia. (Floating button)
    /// - Parameter sender: objeto de la clase UIButton
    @IBAction func ButtonClick(_ sender: UIButton){
        print(TAG, " --> ButtonClick() --> Se mando llamar.")
        animationHideFabRecover()
        var numax = -1
        if banderaWatch{
            numax = arrayBoolAux.count - 1
        }else{
            //numax en este contexto es el ARRAY de las POSICIONES del total de noticias que debe borrar
            numax = ListNewsRecover.count - 1
        }
        if numax >= 0 {
            print("RecoverViewController --> ButtonClick (FAB) -- Start Deleting..")
            
            for n in (0...numax).reversed() {
                //numax sera el numero de elementos a borrar el conteo es REVERSIVO, ya que eliminara del ultimo elemento al primero
                if banderaWatch{
                    if !arrayBoolAux[n] {
                        print("RecoverViewController --> ButtonClick (FAB) -- banderaWatch.TRUE -- arrayBoolAux[\(n)]: !\(arrayBoolAux[n])")
                        //Start to erase
                        saveNews(arrayListNews[n])

                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let managedObjectContext = delegate.persistentContainer.viewContext
                        print("RecoverViewController --> ButtonClick (FAB) -- banderaWatch.TRUE")
                        let context:NSManagedObjectContext = managedObjectContext
                        context.delete(ListNewsRecover[arrayListNews[n]] as NSManagedObject)
                        //Remueve del Core Data
                        ListNewsRecover.remove(at: arrayListNews[n])
                    }
                }else{
                    if !arrayBoolAux[n] {
                        //Start to erase
                        saveNews(n)
                        let indexPath = IndexPath(row: n, section: 0)
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let managedObjectContext = delegate.persistentContainer.viewContext
                        //remove object from core data
                        let context:NSManagedObjectContext = managedObjectContext
                        context.delete(ListNewsRecover[n] as NSManagedObject)
                        //update UI methods
                        tableView.beginUpdates()
                        //Remueve del Core Data
                        ListNewsRecover.remove(at: n)
                        //Remueve de la Lista general de Noticias
                        tableView.deleteRows(at: [indexPath], with: .none)
                        tableView.endUpdates()
                        
                        print("SIZE Array Booleano: ",arrayBoolAux.count)
                        print("SIZE List News :",ListNewsRecover.count)
                        print("SIZE TableView :",tableView.contentSize)
                        delegate.saveContext()
                        print("Deleted")
                    }
                }
            }
            print("End of Deleting in MenuFILTER")
            banderaWatch = false
            
        }
        
        //Verifica si hay noticias que mostrar o no para modificaciones en view controller
        if ListNewsRecover.count > 0{
            arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
            filtershow()
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            warningTextView.isHidden = false
            CloseIcon.isHidden = true
            isNewShow = true
        }else{
            warningTextView.isHidden = true
            CloseIcon.isHidden = false
            isNewShow = false
            setAnimationButtonAlpha(button: CloseIcon)
        }
        
        // Despues de hacer tap, va al menu Home
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Recovering Fab..")
        }
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        tableView.reloadData()
        
    }
    
    /// Función que responde cuando se seleccionó una opción del menú filter.
    /// - Parameter sender: UIButton
    @IBAction func MenuFavTapped(_ sender: UIButton) {
        if !self.roundButton.isHidden {
            animationHideFabRecover()
        }
        //Este array TODOS sus elementos seran TRUE
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        guard let  title = sender.currentTitle, let MenuTitles = Types(rawValue: title) else {
            return
        }
        banderaWatch = true
        
        switch MenuTitles {
        case .Health:
            print("health")
            WatchFav = "health"
            label.text = "HEALTH"
            
            break
            
        case .Construction:
            print("construc")
            WatchFav = "construction"
            label.text = "CONSTRUCTION"
            break
            
        case .Retail:
            print("retail")
            WatchFav = "retail"
            label.text = "RETAIL"
            
            break
            
        case .Education:
            print("education")
            WatchFav = "education"
            label.text = "EDUCATION"
            
            break
            
        case .Entertainment:
            
            print("entertainment")
            WatchFav = "entertainment"
            label.text = "ENTERTAINMENT"
            
            break
        case .Environment:
            print("environ")
            WatchFav = "environment"
            label.text = "ENVIRONMENT"
            
            break
        case .Finance:
            print("finance")
            WatchFav = "finance"
            label.text = "FINANCE"
            
            
            break
        case .Energy:
            print("energy")
            WatchFav = "energy"
            label.text = "ENERGY"
            
            
            break
        case .Telecom:
            print("telecom")
            WatchFav = "telecom"
            label.text = "TELECOM"
            break
            
        case .Reset:
            print("reset all")
            WatchFav = ""
            backFavNormal()
            break
        }
        print("DONE")
        MenuButtons.forEach{(button) in
            button.isHidden = true
        }
        MenuInside.isHidden=true
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        
        tableView.reloadData()
    }
    
    /// IBAction para el button "cerrar", para regresar a Home
    /// - Parameter sender: Any
    @IBAction func CloseIconTapped(_ sender: Any) {
        print("Button CloseIcon Pressed!")
        // Despues de hacer tap, va al menu Home
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let firstTabC = self.tabBarController as! NavigationTabController
            firstTabC.updateTabbarIndicatorBySelectedTabIndex(index: 0)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    //MARK:- SELECTORS
    /// Función que controla si se muestra o no el menú filter
    @objc private func filterTapped() {
        print("Filter Tapped show Menu")
        favoritesView.bringSubviewToFront(MenuInside)
        //Show MenuFilter
        if MenuInside.isHidden {
            RecursiveButtonShow()
        } else { //Hide MenuFilter
            RecursiveButtonHide()
        }
    }
    
    /// Función para regresar a Home que escucha el button superior izquierda del navigation bar "Atras"
    @objc private func returnHome(){
        print("returning Home..")
        // Despues de hacer tap, va al menu Home
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let firstTabC = self.tabBarController as! NavigationTabController
            firstTabC.updateTabbarIndicatorBySelectedTabIndex(index: 0)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    /// Función que al dar tap al button superior izquierdo ("Atras"), si esta en el modo de recuperación, regresa a la configuración original de Recover
    @objc private func backFavNormal() {
        print("Configuration for return from Menu Filter..")
        label.text = "REMOVED"
        WatchFav = ""
        banderaWatch = false
        //Este array TODOS sus elementos seran TRUE, porque al momento de dar tap a eliminar tiene que mostrar el Icono de Basura(Color rojo) en todos los elementos
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        if !self.roundButton.isHidden {
            animationHideFabRecover()
        }
        tableView.reloadData()
    }
    
}
