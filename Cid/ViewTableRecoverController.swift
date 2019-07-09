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


class ViewTableRecoverController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var banderaBorrar = false
    var banderaDeep = true
    var ListNewsRecover:[NoticiaRecover] = []                     //Desde ListNewsRecover es posible acceder al Coredata
    var arrayListNews: [Int] = []                   //Array para saber el numero de noticias
    let BasuraIcon = UIButton(type: .system)
    let image = UIButton(type: .system)
    var roundButton = UIButton()
    let label = UILabel()
    var imageAspect = 0 as CGFloat
    var cell = FavoritesTableViewCell()             //cell es una celda con los UI declarados
    var tapGesture1 = UITapGestureRecognizer()
    var arrayBoolAux:[Bool] = []                    //Array auxiliar para poder guardar los elementos a borrar
    var arrayBoolAuxMenuSelected:[Bool] = []                    //Array auxiliar para poder guardar los elementos a borrar

    var WatchFav = ""                               //Se utiliza para ser cambiado por un string (puede ser "health","retail"..) ya que nos servira al momento de hacer un Filtro (FILTER) de noticias
    var banderaWatch = false
    var viewGreenBar = UIView()
    var divisionRows = 0
    var backItem = UIBarButtonItem()
    var flagFilterWatch = false
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //////////////////////////////////////////////
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CloseIcon: UIButton!
    @IBOutlet weak var MenuInside: UIView!
    @IBOutlet var MenuButtons: [UIButton]!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var insideViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var favoritesView: UIView!
    
    
    ///////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewTableRecoverController --> viewDidLoad")

        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))   //Este array TODOS sus elementos seran TRUE,
        print("ViewTableRecoverController --> arrayBoolAux count:",arrayBoolAux.count)
        setupOnceNavigationBarItems()   //Configuracion inicial del navegationBarItems
        
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchData()
        self.tableView.reloadData()
        
        banderaBorrar = false       //Indica que no va a borrar
        banderaDeep = false          //Bandera auxiliar al borrado
        label.font = UIFont.boldSystemFont(ofSize: 16.0)   //Configuraciones de labels y botones
        self.roundButton = UIButton(type: .custom)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        //self.roundButton.setAllSideShadow(shadowShowSize: 3.0)
        self.view.addSubview(roundButton)
        self.roundButton.isHidden = true
        self.view.layoutIfNeeded()
        //animationShowFabRecover()

        MenuButtons.forEach{(button) in             //configuracion del menu FILTER (colores)
            button.isHidden = true
            button.backgroundColor = UIColor.init(red: 35/255, green: 87/255, blue: 132/255, alpha: 1)
            //button.currentTitle.
            button.titleLabel?.attributedText = NSAttributedString(string: (button.titleLabel?.text)!, attributes:[ NSAttributedString.Key.kern: 1.5])
        }
        MenuInside.isHidden=true                    //No se muestra el menu FILTER
        MenuInside.backgroundColor = UIColor.init(red: 0, green: 55/255, blue: 111/255, alpha: 1)
        arrayListNews = [Int](repeatElement(0, count: ListNewsRecover.count)) //Se inicializa el array con 0`s dependiendo del tamaño de noticias
        self.tableView.tableFooterView? = footerView
    }
    ///////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("ViewTableRecoverController --> viewWillAppear")
        //deletedDeadlines()
        deletedDeadlines()

        setupNavigationBarItems()
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))   //Este array TODOS sus elementos seran TRUE, porque al momento de dar tap a eliminar tiene que mostrar el Icono de Basura(Color rojo) en todos los elementos
        print("ViewTableRecoverController --> arrayBoolAux count:",arrayBoolAux.count)

        self.fetchData()
        banderaWatch = false
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true                //Habilita el scroll y selection para la tableview, ya que al momento de abrir FILTER esta deshabilitado
        self.tableView.reloadData()
        banderaBorrar = false
        image.isHidden = false
        //BasuraIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        MenuButtons.forEach{(button) in
            button.isHidden = true
        }
        MenuInside.isHidden=true
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))   //Se configura para que todos los Icoonos basura(rojo) se vuelvan a veru
        banderaDeep = false
        //animationShowFabRecover()
        
        if (ListNewsRecover.count > 0 ){                       //SI hay noticias, muestra las noticias
            print("ViewTableRecoverController --> BEGINNING LIST NEWS COUNT :",ListNewsRecover.count)
            BasuraIcon.isHidden = false
            //self.navigationItem.setLeftBarButton(nil, animated: false)
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            
            banderaWatch = false
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        }else{                                          //Si NO hay, muestra el view1 (barra verde con label "GO & SAVE..")
            //backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
            //self.navigationItem.leftBarButtonItem = backItem

            //self.navigationItem.setLeftBarButton(nil, animated: false)
            //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
           // noNewsShow()
        }
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        self.roundButton.isHidden = true
        removeFABShadow()
        
    }
    

    ///////////////////////////////////////////////
    override func viewWillLayoutSubviews() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named: "ic_recover_avatar"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
        roundButton.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        roundButton.layer.shadowOffset = CGSize(width: 110, height:  221)
        roundButton.layer.shadowOpacity = 0.5
        roundButton.layer.shadowRadius = 5
        roundButton.layer.masksToBounds = false
    }
    ///////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ///////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var aux = 0
        arrayListNews = [Int](repeatElement(0, count: ListNewsRecover.count))
        if banderaWatch{    //SI banderaWatch es TRUE, noticias por CATEGORIA
            
            if ListNewsRecover.count > 0 {
                for index in 0...ListNewsRecover.count - 1{
                    if WatchFav == ListNewsRecover[index].categoria!{          //Si encuentra (WatchFav es un string p.ej "telecom") la misma categoria en el ListNewsRecover
                        aux += 1
                        arrayListNews[aux-1] = index   // Este Array son las cantidad de noticias que existen y guarda su ubicacion en el ListNewsRecover del CoreData
                        print("ViewTableRecoverController --> numberOfRowsInSection --> ArrayListNews [",aux-1,"]","  Index: ",index)
                    }
                }
                arrayBoolAuxMenuSelected = [Bool](repeatElement(true, count: aux))   //Este array TODOS sus elementos seran TRUE
                tableView.alpha = 1
                CloseIcon.alpha = 0  //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
                flagFilterWatch = false
                aux = arrayBoolAuxMenuSelected.count //Numero de noticias totales despues en FILTER
            print("ViewTableRecoverController --> numberOfRowsInSection --> arrayBoolAuxMenu aux : ",aux)
            }
                //ListNewsRecover[arrayListNews[arrayBoolAuxMenuSelected[0]]]
        }else{
        
            flagFilterWatch = false
            aux = ListNewsRecover.count //Numero de noticias totales
        }
        
        
        print("ViewTableRecoverController --> numberOfRowsInSection --> aux:",aux)
        return aux //Al final aux, sera el numero de noticias(con categoria seleccionada) o numero de noticias totales
    }
    ///////////////////////////////////////////////
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  //Va cell x cell
        if banderaWatch {  // Si es TRUE significa que selecciono una opcion del MENU FILTER
            print("ViewTableRecoverController --> cellForRowAt --> banderaWatch TRUE")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
            cell.AvatarFav?.image = UIImage(data: ListNewsRecover[arrayListNews[indexPath.row]].imageNews! as Data)
            cell.AvatarFav.layer.borderWidth = 0
            cell.AvatarFav.layer.masksToBounds = false
            cell.AvatarFav.layer.cornerRadius = cell.AvatarFav.frame.size.height/2
            cell.AvatarFav.clipsToBounds = true
            cell.TitleFav?.text = ListNewsRecover[arrayListNews[indexPath.row]].titulo //Asigna los titulos y autores correspondientes a las celdas
            cell.AutorFav?.text = ListNewsRecover[arrayListNews[indexPath.row]].autor
            if  arrayListNews.count == 0{
               // noNewsShow()
                flagFilterWatch = true
            }
        
            if !arrayBoolAux[indexPath.row]{
                cell.BasuraIconAvatar.isHidden = false
                cell.BasuraIconAvatar.image = UIImage.init(named: "ic_recover_avatar")
            }
            else{
                cell.BasuraIconAvatar.isHidden = true
            }

        }else{ // Si es FALSE es la configuracion normal
            //Config Normal
            print("banderaWatch FALSE")
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
            cell.AvatarFav?.image = UIImage(data: ListNewsRecover[indexPath.row].imageNews as! Data)
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
                let timeLeft = formatter.string(from: now, to: end as! Date)!
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
    
    ///////////////////////////////////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*Al seleccionar UNA celda si banderaBorrar es TRUE signfica que esta en la opcion de RECUPERAR,
         y que va a SELECCIONAR las celdas que quiere recuperar.
         */
        print("ViewTableRecoverController --> didSelectRow -- Start Erasing ? ")
        if arrayBoolAux[indexPath.row] {            //Este array sera utilizado para saber que noticia borrar(posicion)
            arrayBoolAux[indexPath.row] = false
            print("Marcado? NO!")
        }else{
            arrayBoolAux[indexPath.row] = true
            print("Marcado? YES!")
        }
        
        print("ViewTableRecoverController --> didSelectRow --> You tapped cell number \(indexPath.row).")
        if banderaWatch{
            print(" Delete in  Menu Selected")
            if arrayBoolAuxMenuSelected[indexPath.row] {            //Este array sera utilizado para saber que noticia borrar(posicion)
                arrayBoolAuxMenuSelected[indexPath.row] = true
                print("MARK? SAVED!")
            }else{
                arrayBoolAuxMenuSelected[indexPath.row] = false
                print("MARK? DELETE!")
            }
        }else{
        }
       
        if arrayBoolAux.contains(false){
            if self.roundButton.isHidden {
                animationShowFabRecover()
            }
        }else{
            if !self.roundButton.isHidden{
                removeFABShadow()
                animationHideFabRecover()
            }
        }
        tableView.reloadData()                          //Recarga los valores de la tableview
    }
    ///////////////////////////////////////////////
    @IBAction func ButtonClick(_ sender: UIButton){    //Boton Eliminar (FAB) elminara los elementos apartir del arrayBoolAux
        removeFABShadow()
        animationHideFabRecover()
        var numax = -1
        if banderaWatch{
            numax = arrayBoolAux.count - 1
            
        }else{
            numax = ListNewsRecover.count - 1  //numax en este contexto es el ARRAY de las POSICIONES del total de noticias que debe borrar
        }
        if numax >= 0 {
            print("ViewTableRecoverController --> ButtonClick (FAB) -- Start Deleting..")
            
            for n in (0...numax).reversed() {
                //numax sera el numero de elementos a borrar el conteo es REVERSIVO, ya que eliminara del ultimo elemento al primero
                if banderaWatch{
                    if !arrayBoolAux[n] {
                        print("ViewTableRecoverController --> ButtonClick (FAB) -- banderaWatch.TRUE -- arrayBoolAux[\(n)]: !\(arrayBoolAux[n])")
                        /////////////  Start to Erase
                        saveNews(arrayListNews[n])

                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let managedObjectContext = delegate.persistentContainer.viewContext
                        print("ViewTableRecoverController --> ButtonClick (FAB) -- banderaWatch.TRUE")
                        let context:NSManagedObjectContext = managedObjectContext
                        context.delete(ListNewsRecover[arrayListNews[n]] as NSManagedObject)
                        ListNewsRecover.remove(at: arrayListNews[n])                                  //Remueve del Core Data
                    }
                }else{
                    if !arrayBoolAux[n] {
                        /////////////  Start to Erasec
                        saveNews(n)
                        let indexPath = IndexPath(row: n, section: 0)
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let managedObjectContext = delegate.persistentContainer.viewContext
                        //remove object from core data
                        let context:NSManagedObjectContext = managedObjectContext
                        context.delete(ListNewsRecover[n] as NSManagedObject)
                        //update UI methods
                        tableView.beginUpdates()
                        ListNewsRecover.remove(at: n)                                  //Remueve del Core Data
                        tableView.deleteRows(at: [indexPath], with: .none)      //Remueve de la Lista general de Noticias
                        tableView.endUpdates()
                        //arrayBoolAux.remove(at: indexPath.row - 1)
                        print("SIZE Array Booleano: ",arrayBoolAux.count)
                        print("SIZE List News :",ListNewsRecover.count)
                        print("SIZE TableView :",tableView.contentSize)
                        delegate.saveContext()
                        print("Deleted")
                        ////////////
                    }
                }
            }
            print("End of Deleting in MenuFILTER")
            banderaWatch = false
            
        }
        
        if ListNewsRecover.count > 0{
            arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
            filtershow()
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
        }else{
            print("GO AND SAVE YOUR FAVORITES!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Despues de hacer tap, va al menu Home
            print("Recovering Fab..")
            //self.animationShowFabRecover()
        }
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        tableView.reloadData()
        
    }
    
    func deletedDeadlines(){
         let   numax = ListNewsRecover.count - 1  //numax en este contexto es el ARRAY de las POSICIONES del total de noticias que debe borrar
         if numax >= 0 {
            print("Start Deleting..")
            for n in (0...numax).reversed() {
                //numax sera el numero de elementos a borrar el conteo es REVERSIVO, ya que eliminara del ultimo elemento al primero
                        /////////////  Start to Erasec
                        let indexPath = IndexPath(row: n, section: 0)
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        let managedObjectContext = delegate.persistentContainer.viewContext
                        //remove object from core data
                
                        let now = Date()
                        let formatter = DateComponentsFormatter()
                        formatter.allowedUnits = [.minute,.hour,.day, .weekOfMonth]
                        formatter.unitsStyle = .abbreviated
                        let end = ListNewsRecover[indexPath.row].deadlineTime
                        let interval = end?.timeIntervalSince(now)
                        if (interval?.isLess(than: 0))!{
                            print("Delete ByInterval:",interval ?? "00")
                            let context:NSManagedObjectContext = managedObjectContext
                            context.delete(ListNewsRecover[n] as NSManagedObject)
                            ListNewsRecover.remove(at: n)                                  //Remueve del Core Data
                        }
                        //tableView.deleteRows(at: [indexPath], with: .none)      //Remueve de la Lista general de Noticias
                        //tableView.endUpdates()
                        //arrayBoolAux.remove(at: indexPath.row - 1)
                        print("SIZE Array Booleano: ",arrayBoolAux.count)
                        print("SIZE List News :",ListNewsRecover.count)
                        print("SIZE TableView :",tableView.contentSize)
                        delegate.saveContext()
                        print("Deleted")
                        ////////////
            }
            /// Setup TimeLeft
        }
    }
    /////////////////////////////////////////////////
    func filtershow(){              //Muestra el Menu Filter por default
        //self.navigationItem.setLeftBarButton(nil, animated: false)
        self.navigationItem.rightBarButtonItem?.isEnabled=true
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        tableView.alpha = 1
    }
    /////////////////////////////////////////////////
    func noNewsShow(){                                      //Muestra el view(barra verde con label("GO & SAVE..."), cuando no hay ninguna noticia en el Coredata
        //self.navigationItem.setLeftBarButton(nil, animated: false)
        
        
        //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
        // self.navigationItem.rightBarButtonItem?.isEnabled=false
        
        label.text = "REMOVED"
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        //BasuraIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        roundButton.isHidden = false
        
        tableView.alpha = 0
        
        image.isHidden = true
        CloseIcon.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.CloseIcon.alpha = 1.0
        })
        
        
        if ListNewsRecover.count == 0 {
            label.text = "REMOVED"
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            
        }else{
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            //label.text = "REMOVED"
            banderaBorrar = false
            banderaDeep = false
            image.isHidden = banderaBorrar
            roundButton.isHidden = false
            flagFilterWatch = false
            
            favoritesView.bringSubviewToFront(MenuInside)
        }
    }
    ///////////////////////////////////////////////
    private func setupOnceNavigationBarItems(){
        //        MARK1:
        
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 25))
        btnProfile.layer.cornerRadius = 6.0
        btnProfile.contentRect(forBounds: rect)
        btnProfile.setImage(UIImage.init(imageLiteralResourceName: "ic_trash_pink"), for: .normal)
        btnProfile.layer.masksToBounds = true
        
        //create a new button
        let filterButton = UIButton()
        //set image for button
        filterButton.setImage(UIImage(named: "ic_filter_white"), for: UIControl.State.normal)
        filterButton.addTarget(self, action: #selector(ViewTableRecoverController.filterTapped), for: .touchUpInside)
        //set frame
        filterButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        
        
        
        
        let barButton = UIBarButtonItem(customView: filterButton)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        label.text = "REMOVED"                               // Configuracion Label
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
    ///////////////////////////////////////////////
    private func setupNavigationBarItems(){
        flagFilterWatch = false
        tableView.alpha = 1
        CloseIcon.alpha = 0  //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
    }
    
    ///////////////////////////////////////////////
    @objc private func filterTapped() {
        print("Filter Tapped show Menu")
        favoritesView.bringSubviewToFront(MenuInside)

        if MenuInside.isHidden{   //Show MenuFilter
            RecursiveButtonShow()
            
        }else{                          //Hide MenuFilter
            RecursiveButtonHide()
        }
    }
    
    
    
    
    
    
    
    ///////////////////////////////////////////////                     MENU FILTER
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
    ///////////////////////////////////////////////
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
        
        
        
        UIView.animate(withDuration: 0.1, animations: {
            self.MenuButtons[7].isHidden = false
        })
        UIView.animate(withDuration: 0.133, animations: {
            self.MenuButtons[6].isHidden = false
        })
        UIView.animate(withDuration: 0.166, animations: {
            self.MenuButtons[5].isHidden = false
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuButtons[4].isHidden = false
        })
        
        UIView.animate(withDuration: 0.233, animations: {
            self.MenuButtons[8].isHidden = false
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
    ///////////////////////////////////////////////
    
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        print("TEST 1: ",url_str)                                       //Al momento de solicitar una imagen por medio de URL, y regresa  algo diferente a un String, url_str sera igual a  ""
        if url_str == ""{
            imageView.image = #imageLiteral(resourceName: "LOGO_HAND")                              //Asigna una imagen por default
        }else{                                                          //Si no hara una peticion, mediante URLSession
            let url:URL = URL(string: url_str)!
            let session = URLSession.shared
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in if data != nil
                
                {
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
        ///////////////////////////////////////////////
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    ///////////////////////////////////////////////
    @IBAction func ButtonGoFavorites(_ sender: UIButton){               //Boton para ir al menu Home
        print(" IR A HOME RIGHT NOW")
        tabBarController?.selectedIndex = 0
    }
    
    
    ////////////////////////////////
    func savingNews(_ urlIndex:Int){   //Guarda la informacion de las listNews (Info de las API's) en el CoreData Recover
        let theNews = NSEntityDescription.insertNewObject(forEntityName: "NoticiaData", into: context)
        // print("Funcion Guardar, currentIndex -1 : ",currentIndex-1)
        theNews.setValue(ListNewsRecover[urlIndex].titulo,forKey: "titulo")          //"titulo" es el atributo de la entidad NoticiaData
        theNews.setValue(ListNewsRecover[urlIndex].urlToImg,forKey: "urlToImg")
        theNews.setValue(ListNewsRecover[urlIndex].url,forKey: "url")
        theNews.setValue(ListNewsRecover[urlIndex].autor,forKey: "autor")
        theNews.setValue(ListNewsRecover[urlIndex].categoria,forKey: "categoria")
        theNews.setValue(ListNewsRecover[urlIndex].imageNews,forKey: "imageNews")
    }
    
    /////////////////////////////////
    func saveNews(_ urlToSave:Int) {                   // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
        print(" S A V E")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"NoticiaData")
        request.returnsObjectsAsFaults = false
        do {
            var Bandera=false    //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
            let results = try context.fetch(request)
            if (results.count > 0){
                let urlprueba = ListNewsRecover[urlToSave].url  //es la noticia que queremos guardar
                for result in results as! [NSManagedObject]{
                    let prueba = result.value(forKey:"url") as? String //prueba tiene los valores (string) de url
                    let isEqual = (prueba == urlprueba)   // Si listNews(i).url es igual a noticia que queremos guardar, ya existe esa noticia
                    if isEqual {
                        print ("Noticia Repetida")
                        print("ListNews CurrentIndexHelper: ",urlToSave)
                        //  print("listNews(autor): ",listNews[currentIndexHelper-1].autor) //0 --> 19
                        Bandera=true
                    }
                }
                if !Bandera {  //Si no existe, guarda la noticia
                    savingNews(urlToSave)
                    //     print(listNews[currentIndexHelper-1].cat)
                    print("CurrentIndex: ",urlToSave)
                }
            }else{//Guarda si no hay ninguna noticia
                savingNews(urlToSave)
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

    /*////////////////////////////////
    func deleteNews(n:Int) {                   // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
        
        
        
        ////////
                   if banderaWatch{
                            print("arrayBoolAux n:",n)
                            /////////////  Start to Erase
                    
                                            }else{
                            /////////////  Start to Erasec
                            let indexPath = IndexPath(row: n, section: 0)
                            let delegate = UIApplication.shared.delegate as! AppDelegate
                            let managedObjectContext = delegate.persistentContainer.viewContext
                            //remove object from core data
                            let context:NSManagedObjectContext = managedObjectContext
                            context.delete(ListNewsRecover[n] as NSManagedObject)
                            //update UI methods
                            tableView.beginUpdates()
                            ListNewsRecover.remove(at: n)                                  //Remueve del Core Data
                            tableView.deleteRows(at: [indexPath], with: .none)      //Remueve de la Lista general de Noticias
                            tableView.endUpdates()
                            //arrayBoolAux.remove(at: indexPath.row - 1)
                            print("SIZE Array Booleano: ",arrayBoolAux.count)
                            print("SIZE List News :",ListNewsRecover.count)
                            print("SIZE TableView :",tableView.contentSize)
                            delegate.saveContext()
                            print("Deleted")
                            ////////////
        }
        
    }*/
    
    
    @IBAction func MenuFavTapped(_ sender: UIButton) {                          //Funcion cuando un boton del menu FILTER, es seleccionado
        
        if !self.roundButton.isHidden {
            animationHideFabRecover()
        }
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))   //Este array TODOS sus elementos seran TRUE
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.backFavNormal))
        self.navigationItem.leftBarButtonItem = backItem
        
        guard let  title = sender.currentTitle, let MenuTitles = Types(rawValue: title) else {
            return
        }
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
        }
        print("DONE")
        banderaWatch = true
        
        
        MenuButtons.forEach{(button) in
            button.isHidden = true
            //button.currentTitle.
        }
        MenuInside.isHidden=true
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))
        
        
        tableView.reloadData()
    }
    ///////////////////////////////////////////////
    func  fetchData()  {                                //Conexion al Coredata
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            ListNewsRecover = try context.fetch(NoticiaRecover.fetchRequest())
        }catch{
            print(error)
        }
    }
    ///////////////////////////////////////////////
    func animationShowFabRecover(){
        self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.roundButton.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.roundButton.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: { (finished: Bool) in  self.addShadowForRoundedButton(view: self.view, button: self.roundButton, opacity:1)})
    }
    
    ///////////////////////////////////////////////
    func animationHideFabRecover(){
        removeFABShadow()
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)},
                       completion: { (finished:Bool) in self.roundButton.isHidden = true})
    }
    ///////////////////////////////////////////////
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
    ///////////////////////////////////////////////
    func removeFABShadow(){
        for subview in self.view.subviews {
            if (subview.tag == 1010) {
                subview.isHidden = true
                subview.removeFromSuperview()
            }
        }
    }
    ///////////////////////////////////////////////
    
    @IBAction func CloseIconTapped(_ sender: Any) {                 //Boton para ir al menu Home
        print("Button CloseIcon Pressed!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
            self.tabBarController?.selectedIndex = 0
        }
    }
    ///////////////////////////////////////////////
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
    }
    
    @objc private func returnHome(){                     //Si es presionado el Icono de Atras (Superior Izquierda) va a Home
        print("returning Home..")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Despues de hacer tap, va al menu Home
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    
    ///////////////////////////////////////////////
    @objc private func backFavNormal(){                     //Si es presionado el Icono de Atras (Superior Izquierda) config normal
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        
        print("Configuration for return from Menu Filter..")
        
        label.text = "REMOVED"
        WatchFav = ""
        banderaWatch = false
        
        
        arrayBoolAux = [Bool](repeatElement(true, count: ListNewsRecover.count))   //Este array TODOS sus elementos seran TRUE, porque al momento de dar tap a eliminar tiene que mostrar el Icono de Basura(Color rojo) en todos los elementos
        if !self.roundButton.isHidden {
            animationHideFabRecover()
        }
        tableView.reloadData()
        
    }


}
