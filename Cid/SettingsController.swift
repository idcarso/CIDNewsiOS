//
//  ViewController.swift
//  Cid
//
//  Created by Mac CTIN  on 10/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SettingsController: UIViewController{
    
    @IBOutlet weak var CerrarIcon: UIButton!
    @IBOutlet weak var TitleT: UILabel!                 //TitleT = Title Text
    @IBOutlet weak var HealthIcon: UIImageView!
    @IBOutlet weak var HealthT: UILabel!
    @IBOutlet weak var RetailIcon: UIImageView!
    @IBOutlet weak var RetailT: UILabel!
    @IBOutlet weak var ConstructionIcon: UIImageView!
    @IBOutlet weak var ConstructionT: UILabel!
    @IBOutlet weak var EntertainmentIcon: UIImageView!
    @IBOutlet weak var EntertainmentT: UILabel!
    @IBOutlet weak var EnvironmentIcon: UIImageView!
    @IBOutlet weak var EnvironmentT: UILabel!
    @IBOutlet weak var EducationIcon: UIImageView!
    @IBOutlet weak var EducationT: UILabel!
    @IBOutlet weak var EnergyIcon: UIImageView!
    @IBOutlet weak var EnergyT: UILabel!
    @IBOutlet weak var FinanceIcon: UIImageView!
    @IBOutlet weak var FinanceT: UILabel!
    @IBOutlet weak var TelecomIcon: UIImageView!
    @IBOutlet weak var TelecomT: UILabel!
    @IBOutlet weak var ToastShow: UIView!

    var arrayBD:[PreferenciaData] = []  //Obtiene los valores de Coredata de la entidad PreferenciaData
    var arrayBoolAux:[Bool] = []        //Este array se igualara al Coredata, y de este mismo se usara para guardar la configuracion final.
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allIconsInOff:Bool = false

// MARK: - LIFECYLCE VIEW CONTROLLER
    override func viewWillAppear(_ animated: Bool) {
        print("Setting --> viewWillAppear()")
        
        arrayBoolAux = [Bool](repeatElement(true, count: 9)) //
        SetupIcon()
        self.fetchData()
        setupInicio()
        print("Setting --> viewWillAppear -- firstTab Start")
        let firstTab = self.tabBarController?.viewControllers?[0].children[0] as! ContainerController
        
       firstTab.homeController.helpfullLabel = ""   //helpfullLabel, es utilizado en Home para saber si el usuario hizo un cambio en las preferencias
        print("Setting --> viewWillAppear -- firstTab Finish")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        arrayBoolAux = [Bool](repeatElement(true, count: 9)) //Al iniciar sera TRUE las 9 preferencias
        SetupIcon()                                          //Configuracion por default (colores)
        setupInicio()                                        //Confifguracion ON/OFF (preferencias)
        SetupFontSizeLabel()
        print(UIScreen.main.nativeBounds.height)
    }

// MARK: - IB ACTIONS
    @IBAction func CrossIcon(_ sender: UIButton) {   //boton para regresar al menu Home
        print("Button CrossIcon Pressed!")
        if allIconsInOff {
            
            ToastShow.alpha = 0        //animacion al boton Cerrar
            UIView.animate(withDuration: 0.3, animations: {
                self.ToastShow.alpha = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { //Delay para despues de haber dado Tap al boton
                UIView.animate(withDuration: 0.3, animations: {
                    self.ToastShow.alpha = 0
                })
            }

        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //Delay para despues de haber dado Tap al boton
                
                let firstTabC = self.tabBarController as! NavigationTabController
                firstTabC.updateTabbarIndicatorBySelectedTabIndex(index: 0)
                self.tabBarController?.selectedIndex = 0
                
            }
        }
    }

// MARK: - OBJC FUNCTIONS
    
    /**
     CAMBIA EL COLOR Y GUARDA LA CONFIGURACION
     */
    @objc func IconHealthTapped(){
        print("Health Tapped!")
        if HealthIcon.image == #imageLiteral(resourceName: "salud_on")  {
            MenuOn(i: 0)
        }else{
           MenuOff(j: 0)
        }
        guardarConfig(i: 0)
        
        
        }
    
    @objc func IconRetailTapped(){
        print("Retail Tapped!")
        if  RetailIcon.image == #imageLiteral(resourceName: "retail_on") {
            MenuOn(i: 1)
        }else{
            MenuOff(j: 1)
        }
        guardarConfig(i: 1)
    }
    
    @objc func IconConstructionTapped(){
        print("Construction Tapped!")
        if  ConstructionIcon.image == #imageLiteral(resourceName: "construction_on") {
            MenuOn(i: 2)
        }else{
            MenuOff(j: 2)
        }
        guardarConfig(i: 2)

    }
    
    @objc func IconEntertainmentTapped(){
        print("Entertainment Tapped!")
        if  EntertainmentIcon.image == #imageLiteral(resourceName: "entretenimiento_on"){
            MenuOn(i: 3)
        }else{
            MenuOff(j: 3)
        }
        guardarConfig(i: 3)
    }
    
    @objc func IconEnvironmentTapped(){
        print("Environment Tapped!")
        if EnvironmentIcon.image == #imageLiteral(resourceName: "ambiente_on") {
            MenuOn(i: 4)
        }else{
            MenuOff(j: 4)
        }
        guardarConfig(i: 4)
    }
    
    @objc func IconEducationTapped(){
        print("Education Tapped!")
        if EducationIcon.image == #imageLiteral(resourceName: "education_on") {
            MenuOn(i: 5)
        }else{
            MenuOff(j: 5)
        }
        guardarConfig(i: 5)
    }
    
    @objc func IconEnergyTapped(){
        print("Energy Tapped!")
        if EnergyIcon.image == #imageLiteral(resourceName: "energia_on") {
            MenuOn(i: 6)
        }else{
            MenuOff(j: 6)
        }
        guardarConfig(i: 6)
    }
    
    @objc func IconFinanceTapped(){
        print("Finance Tapped!")
        if FinanceIcon.image == #imageLiteral(resourceName: "bancaria_on") {
            MenuOn(i: 7)
        }else{
            MenuOff(j: 7)
        }
        guardarConfig(i: 7)
    }
    
    @objc func IconTelecomTapped(){
        print("Telecom Tapped!")
        if TelecomIcon.image == #imageLiteral(resourceName: "telecom_on") {
            MenuOn(i: 8)
        }else{
            MenuOff(j: 8)
        }
        guardarConfig(i: 8)

    }
    
// MARK: - FUNCTIONS

    /**
     CONFIGURA COLORES Y TAP GESTURES
     */
    func SetupIcon() {
        let jsjn = UIView()
        jsjn.updateConstraintsIfNeeded()
        jsjn.updateConstraints()
        
        TitleT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
        HealthT.textColor = TitleT.textColor
        RetailT.textColor = TitleT.textColor
        ConstructionT.textColor = TitleT.textColor
        EntertainmentT.textColor = TitleT.textColor
        EnvironmentT.textColor = TitleT.textColor
        EducationT.textColor = TitleT.textColor
        EnergyT.textColor = TitleT.textColor
        FinanceT.textColor = TitleT.textColor
        TelecomT.textColor = TitleT.textColor



        let tapGestureSet1 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconHealthTapped))
        self.HealthIcon.isUserInteractionEnabled = true
        self.HealthIcon.addGestureRecognizer(tapGestureSet1)
        let tapGestureSet2 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconRetailTapped))
        self.RetailIcon.isUserInteractionEnabled = true
        self.RetailIcon.addGestureRecognizer(tapGestureSet2)
        
        let tapGestureSet3 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconConstructionTapped))
        self.ConstructionIcon.isUserInteractionEnabled = true
        self.ConstructionIcon.addGestureRecognizer(tapGestureSet3)
        
        let tapGestureSet4 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconEntertainmentTapped))
        self.EntertainmentIcon.isUserInteractionEnabled = true
        self.EntertainmentIcon.addGestureRecognizer(tapGestureSet4)
        
        let tapGestureSet5 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconEnvironmentTapped))
        self.EnvironmentIcon.isUserInteractionEnabled = true
        self.EnvironmentIcon.addGestureRecognizer(tapGestureSet5)
        
        let tapGestureSet6 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconEducationTapped))
        self.EducationIcon.isUserInteractionEnabled = true
        self.EducationIcon.addGestureRecognizer(tapGestureSet6)
        
        let tapGestureSet7 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconEnergyTapped))
        self.EnergyIcon.isUserInteractionEnabled = true
        self.EnergyIcon.addGestureRecognizer(tapGestureSet7)

        let tapGestureSet8 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconFinanceTapped))
        self.FinanceIcon.isUserInteractionEnabled = true
        self.FinanceIcon.addGestureRecognizer(tapGestureSet8)

        let tapGestureSet9 = UITapGestureRecognizer(target: self, action: #selector(SettingsController.IconTelecomTapped))
        self.TelecomIcon.isUserInteractionEnabled = true
        self.TelecomIcon.addGestureRecognizer(tapGestureSet9)

        
    }
    
    /**
     CONFIGURA EL TAMAÑO DE LA LETRA DEPENDIENDO EL TAMAÑO DE PANTALLA
     */
    func SetupFontSizeLabel() {
        if UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: // IPHONE SE
                HealthT.font = HealthT.font.withSize(11)
                RetailT.font = RetailT.font.withSize(11)
                ConstructionT.font = ConstructionT.font.withSize(11)
                EntertainmentT.font = EntertainmentT.font.withSize(11)
                EnvironmentT.font = EnvironmentT.font.withSize(11)
                EducationT.font = EducationT.font.withSize(11)
                EnergyT.font = EnergyT.font.withSize(11)
                FinanceT.font = FinanceT.font.withSize(11)
                TelecomT.font = TelecomT.font.withSize(11)
            case 1334: // IPHONE 6S, 7, 8
                HealthT.font = HealthT.font.withSize(12)
                RetailT.font = RetailT.font.withSize(12)
                ConstructionT.font = ConstructionT.font.withSize(12)
                EntertainmentT.font = EntertainmentT.font.withSize(12)
                EnvironmentT.font = EnvironmentT.font.withSize(12)
                EducationT.font = EducationT.font.withSize(12)
                EnergyT.font = EnergyT.font.withSize(12)
                FinanceT.font = FinanceT.font.withSize(12)
                TelecomT.font = TelecomT.font.withSize(12)
            case 1792: // IPHONE 11
                HealthT.font = HealthT.font.withSize(13)
                RetailT.font = RetailT.font.withSize(13)
                ConstructionT.font = ConstructionT.font.withSize(13)
                EntertainmentT.font = EntertainmentT.font.withSize(13)
                EnvironmentT.font = EnvironmentT.font.withSize(13)
                EducationT.font = EducationT.font.withSize(13)
                EnergyT.font = EnergyT.font.withSize(13)
                FinanceT.font = FinanceT.font.withSize(13)
                TelecomT.font = TelecomT.font.withSize(13)
            case 2208.0:  // IPHONE 6S PLUS, 7 PLUS, 8 PLUS
                HealthT.font = HealthT.font.withSize(13)
                RetailT.font = RetailT.font.withSize(13)
                ConstructionT.font = ConstructionT.font.withSize(13)
                EntertainmentT.font = EntertainmentT.font.withSize(13)
                EnvironmentT.font = EnvironmentT.font.withSize(13)
                EducationT.font = EducationT.font.withSize(13)
                EnergyT.font = EnergyT.font.withSize(13)
                FinanceT.font = FinanceT.font.withSize(13)
                TelecomT.font = TelecomT.font.withSize(13)
            case 2436.0: // IPHONE 11 PRO
                HealthT.font = HealthT.font.withSize(12)
                RetailT.font = RetailT.font.withSize(12)
                ConstructionT.font = ConstructionT.font.withSize(12)
                EntertainmentT.font = EntertainmentT.font.withSize(12)
                EnvironmentT.font = EnvironmentT.font.withSize(12)
                EducationT.font = EducationT.font.withSize(12)
                EnergyT.font = EnergyT.font.withSize(12)
                FinanceT.font = FinanceT.font.withSize(12)
                TelecomT.font = TelecomT.font.withSize(12)
            case 2688.0: // IPHONE 11 PRO MAX
                HealthT.font = HealthT.font.withSize(13)
                RetailT.font = RetailT.font.withSize(13)
                ConstructionT.font = ConstructionT.font.withSize(13)
                EntertainmentT.font = EntertainmentT.font.withSize(13)
                EnvironmentT.font = EnvironmentT.font.withSize(13)
                EducationT.font = EducationT.font.withSize(13)
                EnergyT.font = EnergyT.font.withSize(13)
                FinanceT.font = FinanceT.font.withSize(13)
                TelecomT.font = TelecomT.font.withSize(13)
            default:
                print("NO ES SMARTPHONE")
            }
        }
    }
    
    /**
     GUARDA CAMBIOS Y ALMACENA EN COREDATA
     */
    func guardarConfig(i:Int) {
        let firstTab = self.tabBarController?.viewControllers?[0].children[0] as! ContainerController
        firstTab.homeController.helpfullLabel = "HEY WHATS UP "
        
       
        arrayBD[i].arrayPreferencias = arrayBoolAux[i]  //Guarda el array actual en el Coredata
        if !arrayBD[0].arrayPreferencias && !arrayBD[1].arrayPreferencias && !arrayBD[2].arrayPreferencias && !arrayBD[3].arrayPreferencias && !arrayBD[4].arrayPreferencias && !arrayBD[5].arrayPreferencias && !arrayBD[6].arrayPreferencias && !arrayBD[7].arrayPreferencias && !arrayBD[8].arrayPreferencias {
            print("TODOS ESTAN EN OFF")
            allIconsInOff = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }else{
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            allIconsInOff = false
        }

        do{
            try context.save()
        }catch{
            print(error)
        }
        print("Health :",arrayBD[0].arrayPreferencias)  //Auxilia a saber la configuracion
        print("Retail :",arrayBD[1].arrayPreferencias)
        print("Construction :",arrayBD[2].arrayPreferencias)
        print("Entertain :",arrayBD[3].arrayPreferencias)
        print("environ :",arrayBD[4].arrayPreferencias)
        print("Education :",arrayBD[5].arrayPreferencias)
        print("Energy :",arrayBD[6].arrayPreferencias)
        print("finance :",arrayBD[7].arrayPreferencias)
        print("Telecom :",arrayBD[8].arrayPreferencias)
        
    }
    
    /**
     CONEXION AL COREDATA
     */
    func  fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            arrayBD = try context.fetch(PreferenciaData.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    /**
     OBTIENE LA INFORMACION DEL COREDATA. TRUE O FALSE PARA EL arrayBool(i)
     */
    func setupInicio() {
         for index in 0...8 {
            if !arrayBD[index].arrayPreferencias {
                MenuOn(i: index)
            }else{
                MenuOff(j: index)
                
            }
        }
        allIconsInOff = false
        ToastShow.alpha = 0        //animacion al boton Cerrar
        CerrarIcon.alpha = 0        //animacion al boton Cerrar
        UIView.animate(withDuration: 0.5, animations: {
            self.CerrarIcon.alpha = 1.0
        })
    }
    
    /**
     CONFIGURACION DE IMAGEN Y TEXTO (OFF)
     */
    func MenuOff(j:Int){
        switch j {
        case 0:
            HealthIcon.image = #imageLiteral(resourceName: "salud_on")
            HealthT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[0]  = true
            break
        case 1:
            RetailIcon.image = #imageLiteral(resourceName: "retail_on")
            RetailT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[1]  = true
            break
        case 2:
            ConstructionIcon.image = #imageLiteral(resourceName: "construction_on")
            ConstructionT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[2]  = true
            break
        case 3:
            EntertainmentIcon.image = #imageLiteral(resourceName: "entretenimiento_on")
            EntertainmentT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[3]  = true
            break
        case 4:
            EnvironmentIcon.image = #imageLiteral(resourceName: "ambiente_on")
            EnvironmentT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[4]  = true
            break
        case 5:
            EducationIcon.image = #imageLiteral(resourceName: "education_on")
            EducationT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[5]  = true
            break
        case 6:
            EnergyIcon.image = #imageLiteral(resourceName: "energia_on")
            EnergyT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[6]  = true
            break
        case 7:
            FinanceIcon.image = #imageLiteral(resourceName: "bancaria_on")
            FinanceT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[7]  = true
            break
        case 8:
            TelecomIcon.image = #imageLiteral(resourceName: "telecom_on")
            TelecomT.textColor = UIColor(red: 18/255, green: 169/255, blue: 236/255, alpha: 1)
            arrayBoolAux[8]  = true
            break
        default:
            break
        }
        
    }
    
    /**
     CONFIGURACION DE IMAGEN Y TEXTO (ON)
     */
    func MenuOn(i:Int){
        switch i {
        case 0:
            HealthIcon.image = #imageLiteral(resourceName: "salud_off2")
            HealthT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[0]  = false
            break
        case 1:
            RetailIcon.image = #imageLiteral(resourceName: "retail_off2")
            RetailT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[1]  = false

            break
        case 2:
            ConstructionIcon.image = #imageLiteral(resourceName: "construccion_off2")
            ConstructionT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[2]  = false
            break
        case 3:
            EntertainmentIcon.image = #imageLiteral(resourceName: "entretenimiento_off2")
            EntertainmentT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[3]  = false
            break
        case 4:
            EnvironmentIcon.image = #imageLiteral(resourceName: "ambiente_off2")
            EnvironmentT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[4]  = false
            break
        case 5:
            EducationIcon.image = #imageLiteral(resourceName: "educacion_off2")
            EducationT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[5]  = false
            break
        case 6:
            EnergyIcon.image = #imageLiteral(resourceName: "energia_off2")
            EnergyT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[6]  = false
            break
        case 7:
            FinanceIcon.image = #imageLiteral(resourceName: "bancaria_off2")
            FinanceT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[7]  = false
            break
        case 8:
            TelecomIcon.image = #imageLiteral(resourceName: "telecom_off2")
            TelecomT.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
            arrayBoolAux[8]  = false
            break
        default:
            break
        }
    }

}

