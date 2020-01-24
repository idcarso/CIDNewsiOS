//
//  ViewTableController.swift
//  Cid
//
//  Created by Mac CTIN  on 23/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewTableController : UIViewController,UITableViewDelegate, UITableViewDataSource{
    var mMenuSelected = ""
    var banderaBorrar = false
    var banderaDeep = false
    var ListNews:[Noticia] = []                     //Desde ListNews es posible acceder al Coredata
    var arrayListNews: [Int] = []                   //Array para saber el numero de noticias
    let BasuraIcon = UIButton(type: .system)
    let image = UIButton(type: .system)
    var roundButton = UIButton()
    let label = UILabel()
    var imageAspect = 0 as CGFloat
    var cell = FavoritesTableViewCell()             //cell es una celda con los UI declarados
    var tapGesture1 = UITapGestureRecognizer()
    var arrayBoolAux:[Bool] = []                    //Array auxiliar para poder guardar los elementos a borrar
    var WatchFav = ""                               //Se utiliza para ser cambiado por un string (puede ser "health","retail"..) ya que nos servira al momento de hacer un Filtro (FILTER) de noticias
    var banderaWatch = false
    var viewGreenBar = UIView()
    var divisionRows = 0
    var backItem = UIBarButtonItem()     //Icono para regresar
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
        print("viewDidLoadr")
        setupOnceNavigationBarItems()   //Configuracion inicial del navegationBarItems
        
        arrayBoolAux = [Bool](repeatElement(true, count: ListNews.count))   //Este array TODOS sus elementos seran TRUE, porque al momento de dar tap a eliminar tiene que mostrar el Icono de Basura(Color rojo) en todos los elementos
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchData()
        self.tableView.reloadData()
        
        banderaBorrar = false       //Indica que no va a borrar
        banderaDeep = false          //Bandera auxiliar al borrado
        label.font = UIFont.boldSystemFont(ofSize: 16.0)   //Configuraciones de labels y botones
        self.roundButton = UIButton(type: .custom)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.roundButton.setAllSideShadow(shadowShowSize: 3.0)
        self.view.addSubview(roundButton)
        self.view.layoutIfNeeded()
        self.roundButton.isHidden = true
        MenuButtons.forEach{(button) in             //configuracion del menu FILTER (colores)
            button.isHidden = true
            button.backgroundColor = UIColor.init(red: 35/255, green: 87/255, blue: 132/255, alpha: 1)
            //button.currentTitle.
            button.titleLabel?.attributedText = NSAttributedString(string: (button.titleLabel?.text)!, attributes:[ NSAttributedString.Key.kern: 1.5])
        }
        MenuInside.isHidden=true                    //No se muestra el menu FILTER
        MenuInside.backgroundColor = UIColor.init(red: 0, green: 55/255, blue: 111/255, alpha: 1)
        arrayListNews = [Int](repeatElement(0, count: ListNews.count)) //Se inicializa el array con 0`s dependiendo del tamaño de noticias
        self.tableView.tableFooterView? = footerView
        setupOnceGreenBar()
        hideGreenBar()
        
    }
///////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBarItems()
        self.fetchData()
        banderaWatch = false
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true //Habilita el scroll y selection para la tableview, ya que al momento de abrir FILTER esta deshabilitado
        self.tableView.reloadData()
        banderaBorrar = false
        image.isHidden = false
        //BasuraIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        MenuButtons.forEach{(button) in
            button.isHidden = true
        }
        MenuInside.isHidden=true
        arrayBoolAux = [Bool](repeatElement(true, count: ListNews.count))   //Se configura para que todos los Icoonos basura(rojo) se vuelvan a ver
        banderaDeep = false
        self.roundButton.isHidden = true
        print("View Return")

        if (ListNews.count > 0 ){                       //SI hay noticias, muestra las noticias
            print("BEGINNING LIST NEWS COUNT :",ListNews.count)
            BasuraIcon.isHidden = false
            //self.navigationItem.setLeftBarButton(nil, animated: false)
            
            print("ListNews count:",ListNews.count)
            
            
            if (ListNews.count == 0){
                //self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                
            }else{
               // self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled=true

            }
            banderaWatch = false
            self.navigationItem.titleView?.isUserInteractionEnabled = false
            hideGreenBar()
            label.text = "FAVORITES"
            
        }else{                                          //Si NO hay, muestra el view1 (barra verde con label "GO & SAVE..")
            //self.navigationItem.setLeftBarButton(nil, animated: false)
            //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            self.navigationItem.titleView?.isUserInteractionEnabled = false
            print("ListNews SettingNoNews count :",ListNews.count)
           // self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            
            print("showing Green Bar in viewWillAppear")
            noNewsShow()
            showGreenBar()
        }
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem
        removeFABShadow()
    }
    
    
///////////////////////////////////////////////
    override func viewWillLayoutSubviews() {                    //Configura y muestra el Floating Action Button (Icono Basura Inferior Derecha)
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named: "ic_trash_pink"), for: .normal)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Al seleccionar UNA celda, si banderaBorrar es FALSE, utiliza webView para ver la noticia, si es TRUE signfica que esta en la opcion de BORRAR, y que va a DESELECCIONAR las celdas que no quiere borrar.
        print("You tapped cell number \(indexPath.row).")
        if !banderaBorrar {
            let VC2 = self.storyboard!.instantiateViewController(withIdentifier: "WelcomeID") as! WebViewController           ///Genera WebView
            self.navigationController!.pushViewController(VC2, animated: true)
            
            if banderaWatch{
                VC2.text1 = ListNews[arrayListNews[indexPath.row]].url!
            }else{
                VC2.text1 = ListNews[indexPath.row].url!
            }
            
        }else{
            if banderaWatch{
                print("Yey borrrar")
                if arrayBoolAux[indexPath.row] {            //Este array sera utilizado para saber que noticia borrar(posicion)
                    arrayBoolAux[indexPath.row] = false
                    print("Marcado? NO!")
                }else{
                    arrayBoolAux[indexPath.row] = true
                    print("Marcado? YES!")
                }
            
            
            
            }else{
                print("Yey borrrar")
                if arrayBoolAux[indexPath.row] {            //Este array sera utilizado para saber que noticia borrar(posicion)
                    arrayBoolAux[indexPath.row] = false
                    print("Marcado? NO!")
                }else{
                    arrayBoolAux[indexPath.row] = true
                    print("Marcado? YES!")
                }
            }
        }
        tableView.reloadData()                          //Recarga los valores de la tableview
    }
    
///////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var aux = 0
        arrayListNews = [Int](repeatElement(0, count: ListNews.count))
        if banderaWatch{    //SI banderaWatch es TRUE, va a buscar en todas las noticias, la POSICION en donde haya una noticia con la CATEGORIA deseada
            for index in 0...ListNews.count - 1{
                if WatchFav == ListNews[index].categoria!{          //Si encuentra (WatchFav es un string p.ej "telecom") la misma categoria en el ListNews
                    aux += 1
                    arrayListNews[aux-1] = index   // Este Array son las cantidad de noticias que existen y guarda su ubicacion en el ListNews del CoreData
                    print("ArrayListNews [",aux-1,"]","  Index: ",index)
                }
            }

            
            if aux == 0 {
                print("showing Green Bar in Table View numbweOfRows,aux = 0")

            noNewsShow()
                flagFilterWatch = true


            }else{
                hideGreenBar()
                tableView.alpha = 1
                CloseIcon.alpha = 0  //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
                flagFilterWatch = false

            }
        }else{
            
            flagFilterWatch = false

            aux = ListNews.count //Numero de noticias totales
            print("tableView numberOfRowsInsection, aux:",aux)
        }
        print("TESTY :",aux)
        if aux == 0 {
            print("showing Green Bar in Table View numbweOfRows AtEnd")

            noNewsShow()
        }
        return aux //Al final aux, sera el numero de noticias(con categoria seleccionada) o numero de noticias totales
    }
///////////////////////////////////////////////
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  //Va cell x cell
        if banderaWatch {  // Si es TRUE significa que selecciono una opcion del MENU FILTER
                            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
                           /* get_image(ListNews[arrayListNews[indexPath.row]].urlToImg!,cell.AvatarFav)  //Obtiene la imagen (dependiendo si fue por Categoria o todas las noticias) y la asigna a cell.Avatar
                            if  let auxii = ListNews[arrayListNews[indexPath.row]].imageNews as Data? {
                                print("\n",auxii)
                            }*/
            
                            cell.AvatarFav?.image = UIImage(data: ListNews[arrayListNews[indexPath.row]].imageNews! as Data)
                            cell.AvatarFav.layer.borderWidth = 0
                            cell.AvatarFav.layer.masksToBounds = false
                            cell.AvatarFav.layer.cornerRadius = cell.AvatarFav.frame.size.height/2
                            cell.AvatarFav.clipsToBounds = true
                            cell.TitleFav?.text = ListNews[arrayListNews[indexPath.row]].titulo       //Asigna los titulos y autores correspondientes a las celdas
                            cell.AutorFav?.text = ListNews[arrayListNews[indexPath.row]].autor
                            if  arrayListNews.count == 0{
                                noNewsShow()
                                flagFilterWatch = true
                            }
                            if banderaDeep{
                                if !arrayBoolAux[indexPath.row]{
                                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_trash_pink")
                                    cell.BasuraIconAvatar.alpha = 1
                                }
                                else{
                                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_trashfab_grey")
                                    cell.BasuraIconAvatar.alpha = 0.5

                                }
                                //cell.BasuraIconAvatar.isHidden = !arrayBoolAux[indexPath.row]
                            }

            
            
            
        }else{ // Si es FALSE es la configuracion normal
            //Config Normal
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
            //get_image(ListNews[indexPath.row].urlToImg!,cell.AvatarFav)
            
            
            
           /* if  let auxii = ListNews[indexPath.row].imageNews as Data? {
                print("\nListNEws ImageNWs",auxii)
            }*/
            
            print("tableView cellForRowAt, ListNews count1:",ListNews.count)
            
            
            cell.AvatarFav?.image = UIImage(data: ListNews[indexPath.row].imageNews as! Data)
            cell.AvatarFav.layer.borderWidth = 0
            cell.AvatarFav.layer.masksToBounds = false
            cell.AvatarFav.layer.cornerRadius = cell.AvatarFav.frame.size.height/2
            cell.AvatarFav.clipsToBounds = true
            cell.TitleFav?.text = ListNews[indexPath.row].titulo
            cell.AutorFav?.text = ListNews[indexPath.row].autor
            if !banderaBorrar && !banderaDeep{
                print("Banderas: bandaBorrar:",!banderaBorrar,"BanderaDeep: ",!banderaDeep)
                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_trashfab_grey")
                    cell.BasuraIconAvatar.alpha = 0.5

                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.basuraPressed))
                    tapGestureRecognizer.numberOfTapsRequired = 1
                    cell.BasuraIconAvatar.isUserInteractionEnabled = true
                    cell.BasuraIconAvatar.addGestureRecognizer(tapGestureRecognizer)
            }
            if banderaDeep{
                if !arrayBoolAux[indexPath.row]{
                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_trashfab_grey")
                    cell.BasuraIconAvatar.alpha = 0.5

                }
                else{
                    cell.BasuraIconAvatar.image = UIImage.init(named: "ic_trash_pink")
                    cell.BasuraIconAvatar.alpha = 1

                }
                //cell.BasuraIconAvatar.isHidden = !arrayBoolAux[indexPath.row]
            }
        }
        return cell;
    }
///////////////////////////////////////////////
    func  fetchData()  {                                //Conexion al Coredata
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            ListNews = try context.fetch(Noticia.fetchRequest())
        }catch{
        print(error)
        }
    }
    
    ///////////////////////////////////////////////
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
        
        label.text = "FAVORITES"
        WatchFav = ""
        banderaWatch = false
        tableView.reloadData()
        
        if ListNews.count > 0{
            tableView.alpha = 1
            hideGreenBar()
        }

        //noNewsShow()//Show a function that say go and save...

        

    }
///////////////////////////////////////////////
    @objc private func basuraPressed(){                     //Si es presionado el Icono de Basura (Superior Derecha) cambia los labels, navigationbar, Iconos
        if !banderaBorrar{
            print("Basura pressed")
            

            backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.basuraPressed))
            self.navigationItem.leftBarButtonItem = backItem
            self.navigationItem.rightBarButtonItem?.isEnabled = false
           //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0


            label.text = "REMOVE"
            navigationController?.navigationBar.barTintColor = UIColor(red: 235/255, green: 18/255, blue: 55/255, alpha: 1)
            MenuButtons.forEach{(button) in
                button.isHidden = true
            }
            MenuInside.isHidden=true
            self.navigationItem.titleView?.isUserInteractionEnabled = false
            ////

            banderaBorrar = true
            image.isHidden = banderaBorrar
            roundButton.isHidden = false
            self.roundButton.contentRect(forBounds: CGRect.init(x: 0, y: 0, width: 0, height: 0))

            /*UIView.transition(with: roundButton,
                              duration: 1.9,
                              options: [.beginFromCurrentState],
                              animations: {
            },completion: nil)*/
            self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.roundButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            },completion: { (finished: Bool) in self.addShadowForRoundedButton(view: self.view, button: self.roundButton, opacity:1)})
            
            
            if banderaWatch{
                banderaDeep = true
                banderaWatch = true
                tableView.reloadData()
            
            }else{
                banderaDeep = true
                banderaWatch = false
                tableView.reloadData()
            }
        }else{
            print("Return from Basura pressed")
            
            //self.navigationItem.setLeftBarButton(nil, animated: false)
            if (ListNews.count == 0){
                //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
                self.navigationItem.rightBarButtonItem?.isEnabled = false


            }else{
               // self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = true

            }

            removeFABShadow()

            filtershow()
            roundButton.isHidden = false
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.roundButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            })
            self.roundButton.isHidden = false

            if banderaWatch{
                backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.backFavNormal))
                self.navigationItem.leftBarButtonItem = backItem
                label.text = mMenuSelected

               // banderaWatch = false
            }else{
                backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
                self.navigationItem.leftBarButtonItem = backItem
                label.text = "FAVORITES"


            }
            
            
            tableView.reloadData()

           
        }
    }
/////////////////////////////////////////////////
    func filtershow(){              //Muestra el Menu Filter por default
        
        if (ListNews.count == 0){
            //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            
        }else{
            //self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            self.navigationItem.rightBarButtonItem?.isEnabled=true

        }
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
       // BasuraIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        roundButton.isHidden = true
        
        tableView.alpha = 1
    }
/////////////////////////////////////////////////
    func noNewsShow(){                                      //Muestra el view(barra verde con label("GO & SAVE..."), cuando no hay ninguna noticia en el Coredata
        //self.navigationItem.setLeftBarButton(nil, animated: false)
        //self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
        //self.navigationItem.rightBarButtonItem?.isEnabled=false
        print("--> No NewsShow")
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        image.frame = CGRect(x: label.frame.size.width, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        //BasuraIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        banderaBorrar = false
        banderaDeep = false
        image.isHidden = banderaBorrar
        roundButton.isHidden = true
        
                tableView.alpha = 0

            image.isHidden = true
            hideGreenBar()
            CloseIcon.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.showGreenBar()
                self.CloseIcon.alpha = 1.0
            })
        
        
        if ListNews.count == 0 {
            //if banderaWatch{
            label.text = "FAVORITES"
           // self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            self.navigationItem.rightBarButtonItem?.isEnabled = false

          //  }
        }else{
            print("ListNews count:",ListNews.count)
            if (ListNews.count == 0){
            //    self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                
            }else{
           //     self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = true

            }
            // label.text = "FAVORITES"
            banderaBorrar = false
            banderaDeep = false
            image.isHidden = banderaBorrar
            roundButton.isHidden = true
            flagFilterWatch = false
            favoritesView.bringSubviewToFront(MenuInside)
        }
        removeFABShadow()
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
        
        
        
        filterButton.addTarget(self, action: #selector(ViewTableController.filterTapped), for: .touchUpInside)
        //set frame
        filterButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        
        
        
        let barButton = UIBarButtonItem(customView: filterButton)
        
        let filterRightButton = UIBarButtonItem(image: UIImage(named: "ic_filter_white"), style: .plain,target: self,action: #selector(ViewTableController.filterTapped))
        

        
        //assign button to navigationbar
        //self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem = filterRightButton
        
        if (ListNews.count == 0){
           // self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
            self.navigationItem.rightBarButtonItem?.isEnabled=false

        }else{
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            self.navigationItem.rightBarButtonItem?.isEnabled=true
        }

        label.text = "FAVORITES"                               // Configuracion Label
        label.textColor = UIColor.white
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        label.isUserInteractionEnabled = true
        label.frame.size.width = 120

        
        tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewTableController.filterTapped))
        image.setImage(#imageLiteral(resourceName: "abajo").withRenderingMode(.alwaysOriginal),for: .normal)          //Configuracion Imagen(flecha blanca) del menu FILTER
        imageAspect = (image.currentImage?.size.width)!/(image.currentImage?.size.height)!
        image.frame = CGRect(x: label.frame.size.width - 30, y: label.frame.height/3, width: label.frame.size.height*imageAspect/2, height: label.frame.size.height/2)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.addGestureRecognizer(tapGesture1)
        self.navigationItem.titleView = label
        //self.navigationItem.titleView?.addSubview(image)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationItem.titleView?.addGestureRecognizer(tapGesture1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.returnHome))
        self.navigationItem.leftBarButtonItem = backItem

    }
///////////////////////////////////////////////
    private func setupNavigationBarItems(){
        flagFilterWatch = false
        tableView.alpha = 1
        CloseIcon.alpha = 0  //Boton Cerrar Inferior en el centro (cuando no hay ninguna noticia)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 121/255, blue: 219/255, alpha: 1)
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
///////////////////////////////////////////////
    func RecursiveButtonHide(){
        
        if flagFilterWatch {
            UIView.animate(withDuration: 0.2, animations: {
            self.showGreenBar()
            })
        }

        
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuInside.backgroundColor = UIColor.clear
            self.stackViewConstraintBottom.constant =  self.view.frame.size.height
            self.view.layoutIfNeeded()

        }, completion:{(finished:Bool) in
            self.view.layoutIfNeeded()
            self.MenuInside.isHidden=true
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
            
            if self.flagFilterWatch{
            
            }
        })
        
      /*  UIView.animate(withDuration: 0.1, animations: {  //TELECOM
            self.MenuButtons[7].isHidden = true
        })
        UIView.animate(withDuration: 0.133, animations: {  //ENERGY
            self.MenuButtons[6].isHidden = true
        })
        UIView.animate(withDuration: 0.166, animations: {  //FINANCE
            self.MenuButtons[5].isHidden = true
        })
        
        UIView.animate(withDuration: 0.2,  animations: {
            self.MenuButtons[4].isHidden = true
        })
    /*    UIView.animate(withDuration: 0.2+1, options: UIViewAnimationOptions.cross,animations: {  //ENVIRONMENT
        })*/
        
        UIView.animate(withDuration: 0.23, animations: { //ENTERTIANMENT
            self.MenuButtons[8].isHidden = true
        })
        
        UIView.animate(withDuration: 0.266, animations: {  //EDUCATION
            self.MenuButtons[3].isHidden = true
        })
        UIView.animate(withDuration: 0.3, animations: {//RETAIL
            self.MenuButtons[2].isHidden = true
        })
        UIView.animate(withDuration: 0.1, animations: { //CONSTRUC
            self.MenuButtons[1].isHidden = true
        })
        UIView.animate(withDuration: 0.1, animations: {  //HEALTH
            self.MenuButtons[0].isHidden = true
        })*/
    }
///////////////////////////////////////////////
    func RecursiveButtonShow(){
        if  flagFilterWatch {
            UIView.animate(withDuration: 0.2, animations: {
                self.hideGreenBar()
            })
        }
    
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
            (data, response, error) in if data != nil {
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
    @IBAction func ButtonClick(_ sender: UIButton){    //Boton Eliminar (FAB) elminara los elementos apartir del arrayBoolAux
        
        var numax = -1
        if banderaWatch{
            numax = arrayBoolAux.count - 1
        }else{
            numax = ListNews.count - 1  //numax en este contexto es el ARRAY de las POSICIONES del total de noticias que debe borrar
        }

        for n in (0...numax).reversed() {                       //numax sera el numero de elementos a borrar el conteo es REVERSIVO, ya que eliminara del ultimo elemento al primero
            
            if banderaWatch{
                if !arrayBoolAux[n] {
                    print("arrayBoolAux n:",n)
                    /////////////  Start to Erase
                    saveNews(arrayListNews[n])
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let managedObjectContext = delegate.persistentContainer.viewContext
                    print("Deleting.. banderaWatch TRUE")
                    let context:NSManagedObjectContext = managedObjectContext
                    context.delete(ListNews[arrayListNews[n]] as NSManagedObject)
                    ListNews.remove(at: arrayListNews[n])                                  //Remueve del Core Data
                }
            }else{
                if arrayBoolAux[n] {
                    /////////////  Start to Erase
                    saveNews(n)
                    let indexPath = IndexPath(row: n, section: 0)
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    let managedObjectContext = delegate.persistentContainer.viewContext
                    //remove object from core data
                    let context:NSManagedObjectContext = managedObjectContext
                    context.delete(ListNews[n] as NSManagedObject)
                    //update UI methods
                    tableView.beginUpdates()
                    ListNews.remove(at: n)                                  //Remueve del Core Data
                    tableView.deleteRows(at: [indexPath], with: .none)      //Remueve de la Lista general de Noticias
                    tableView.endUpdates()
                    //arrayBoolAux.remove(at: indexPath.row - 1)
                    print("SIZE Array Booleano: ",arrayBoolAux.count)
                    print("SIZE List News :",ListNews.count)
                    print("SIZE TableView :",tableView.contentSize)
                    delegate.saveContext()
                    print("Deleted")
                    filtershow()
                    ////////////
                }
            }
            
                
        }
        
        banderaWatch = false
        
        if ListNews.count > 0{
            
            
            arrayBoolAux = [Bool](repeatElement(true, count: ListNews.count))
            hideGreenBar()
            filtershow()
            self.navigationItem.titleView?.isUserInteractionEnabled = false
            label.text = "FAVORITES"
            if (ListNews.count == 0){
                self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                
            }else{
                self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }else{
            print("showing Green Bar in Table View ButtonFabClick")

                print("GO AND SAVE YOUR FAVORITES!")
                noNewsShow()//Show a function that say go and save...
                self.navigationItem.titleView?.isUserInteractionEnabled = false
        }
        removeFABShadow()
        tableView.reloadData()
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

    @IBAction func MenuFavTapped(_ sender: UIButton) {                          //Funcion cuando un boton del menu FILTER, es seleccionado
        
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
        mMenuSelected = label.text!
        
        MenuButtons.forEach{(button) in
            button.isHidden = true
            //button.currentTitle.
        }
        MenuInside.isHidden=true
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        
        backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,target: self,action: #selector(self.backFavNormal))
        self.navigationItem.leftBarButtonItem = backItem

        

    tableView.reloadData()
    //WatchFav = ""  //
    }
    
    
    func setupOnceGreenBar()  {
        viewGreenBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/10))
        viewGreenBar.backgroundColor = UIColor.init(red: 159/255, green: 255/255, blue: 92/255, alpha: 1)
        viewGreenBar.removeFromSuperview()
        view.addSubview(viewGreenBar)   //Agrega el view (barra verde..)
        let btn = UIButton(frame: CGRect(x:0, y: viewGreenBar.frame.size.height/2-viewGreenBar.frame.size.height/6, width: viewGreenBar.frame.size.width, height: viewGreenBar.frame.size.height/3))
        btn.setTitle("GO & SAVE YOUR FAVORITES", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.init(red: 30/255, green: 55/255, blue: 175/255, alpha: 1), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(ButtonGoFavorites(_:)), for: UIControl.Event.touchUpInside)
        btn.titleLabel?.textAlignment = NSTextAlignment.center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        viewGreenBar.addSubview(btn)     //Añade btn que es la barra verde, al view donde estara alojado, para realizar el gestureTap
    }
    
    func showGreenBar(){
        viewGreenBar.isHidden  = false
        viewGreenBar.alpha = 1
    }
    func hideGreenBar(){
        viewGreenBar.isHidden  = true
        viewGreenBar.alpha = 0
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
    
    
    /////////////////////////////////
    func saveNews(_ urlToSave:Int) {                   // Se utiliza para salvar la noticia (cuando hace swipe a la derecha)
        print(" S A V E")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"RecoverData")
        request.returnsObjectsAsFaults = false
        do {
            var Bandera=false    //Antes de guardar la noticia, checa si no existe ya en el CoreData, para eso usamos esta bandera
            let results = try context.fetch(request)
            if (results.count > 0){
                let urlprueba = ListNews[urlToSave].url  //es la noticia que queremos guardar
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
    ////////////////////////////////
    func savingNews(_ urlIndex:Int){   //Guarda la informacion de las listNews (Info de las API's) en el CoreData Recover
        let theNews = NSEntityDescription.insertNewObject(forEntityName: "RecoverData", into: context)
       // print("Funcion Guardar, currentIndex -1 : ",currentIndex-1)
        theNews.setValue(ListNews[urlIndex].titulo,forKey: "titulo")          //"titulo" es el atributo de la entidad NoticiaData
        theNews.setValue(ListNews[urlIndex].urlToImg,forKey: "urlToImg")
        theNews.setValue(ListNews[urlIndex].url,forKey: "url")
        theNews.setValue(ListNews[urlIndex].autor,forKey: "autor")
        theNews.setValue(ListNews[urlIndex].categoria,forKey: "categoria")
        theNews.setValue(ListNews[urlIndex].imageNews,forKey: "imageNews")
       // theNews.setValue(Date().addingTimeInterval(60*60*24*5), forKey: "deadlineTime")
        theNews.setValue(Date().addingTimeInterval(60*60*24*5), forKey: "deadlineTime")

    }
}
extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil) { // this method adds shadow to right and bottom side of button
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func setAllSideShadow(shadowShowSize: CGFloat = 1.0) { // this method adds shadow to allsides
        let shadowSize : CGFloat = shadowShowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }

}
