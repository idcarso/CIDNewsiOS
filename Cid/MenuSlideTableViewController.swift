//
//  MenuSlideTableViewController.swift
//  Cid
//
//  Created by Ada Palazuelos on 1/13/20.
//  Copyright © 2020 Mac CTIN . All rights reserved.
//

import UIKit

// MARK: - GLOBAL VARIABLES
enum optionMenu:Int {
    case HEALTH
    case CONSTRUCTION
    case RETAIL
    case EDUCATION
    case ENTERTAINMENT
    case ENVIRONMENT
    case FINANCE
    case ENERGY
    case TELECOM
    case ABOUT
}

class MenuSlideTableViewController: UITableViewController {

    //MARK:- VARIABLES
    let TAG:String = "MenuSlideTableViewController.swift"
    
    // MARK: - CLOSURES
    var tapOptionMenu:((optionMenu) -> Void)?
    
    //MARK: - LIFECYCLE TABLEVIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        AddFooter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - OVERRIDES
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sizeCell = (SizeScreenMenuSlide() - 110) / 10
        return sizeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectOptionMenu = optionMenu(rawValue: indexPath.row) else {return}
        self.tapOptionMenu?(selectOptionMenu)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - FUNCTIONS
    func SizeTabBar () -> CGFloat {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewControllerNavigationTab = storyboard.instantiateViewController(withIdentifier: "MainTabID") as? NavigationTabController,
            let navigationController = viewControllerNavigationTab.viewControllers?[0] as? UINavigationController,
            let viewControllerContainer = navigationController.viewControllers[0] as? ContainerController else {return 0}
        guard let heightTabBar = viewControllerContainer.tabBarController?.tabBar.frame.height else {return 0}
        return heightTabBar
    }
    
    func SizeScreenMenuSlide () -> CGFloat{
        return self.view.frame.height - SizeTabBar()
    }
    
    func SizeHeightFooter () -> CGFloat {
        var sizeFooter:CGFloat = 0
        if UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                // SE
                sizeFooter = SizeScreenMenuSlide() / 9
            case 1334:
                // 6S, 7 u 8
                sizeFooter = SizeScreenMenuSlide() / 9
            case 1792:
                // XR (IPHONE 11)
                sizeFooter = (SizeScreenMenuSlide() - 100) / 11
            case 2208:
                // 6S PLUS, 7 PLUS u 8 PLUS
                sizeFooter = SizeScreenMenuSlide() / 9
            case 2436:
                // X o XS (IPHONE 11 PRO)
                sizeFooter = (SizeScreenMenuSlide() - 100) / 11
            case 2688:
                // XS MAX (IPHONE 11 PRO MAX)
                sizeFooter = SizeScreenMenuSlide() / 11
            default:
                sizeFooter = 0
            }
        }
        return sizeFooter
    }
    
    func PositionTopFooter () -> CGFloat {
        var positionFooter:CGFloat = 0
        if UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                // SE
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 13)
            case 1334:
                // 6S, 7 u 8
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 23)
            case 1792:
                // XR (IPHONE 11)
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 50)
            case 2208:
                // 6S PLUS, 7 PLUS u 8 PLUS
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 33)
            case 2436:
                // X o XS (IPHONE 11 PRO)
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 43)
            case 2688:
                // XS MAX (IPHONE 11 PRO MAX)
                positionFooter = SizeScreenMenuSlide() - ((self.view.frame.height / 5) - 50)
            default:
                positionFooter = 0
            }
        }
        return positionFooter
    }
    
    func AddFooter () {
        /*
        REGLA DE LOS CONSTRAINT
        LEADING -> SIEMPRE SE LE SUMA A SU VALOR (POR LO REGULAR SIEMPRE EMPIEZA DE 0, ES EL MARGEN IZQUIERDO)
        TRAILING -> SIEMPRE SE LE RESTA A SU VALOR (POR LO REGULAR SIEMPRE ES EL VALOR DEL ANCHO DE LA PANTALLA, MARGEN DERECHO)
        TOP -> SIEMPRE SE LE SUMA A SU VALOR (POR LO REGULAR SIEMPRE EMPIEZA DE 0, ES EL MARGEN DE ALTO)
        BOTTOM -> SIEMPRE SE LE RESTA A SU VALOR (POR LO REGULAR SIEMPRES ES EL VALOR DE ALTO DE LA PANTALLA, MARGEN INFERIOR)
        */
        let sizeCell = SizeHeightFooter()
        //CREATION
        let icon = UIImage(named: "logocidnews")
        let imageViewFooter = UIImageView(image: icon)
        //VIEW PROPERTIES
        imageViewFooter.translatesAutoresizingMaskIntoConstraints = false
        imageViewFooter.contentMode = .scaleAspectFit
        //ADD
        self.view.addSubview(imageViewFooter)
        //CONSTRAINT
        imageViewFooter.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        imageViewFooter.heightAnchor.constraint(equalToConstant: sizeCell).isActive = true
        imageViewFooter.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        imageViewFooter.topAnchor.constraint(equalTo: self.view.topAnchor, constant: PositionTopFooter()).isActive = true
    }
    
}
