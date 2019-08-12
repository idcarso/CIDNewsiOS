//
//  MenuOption.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//
import UIKit
enum MenuOption:Int,CustomStringConvertible {
    
    case Health
    case Construction
    case Retail
    case Education
    case Entertainment
    case Environment
    case Finance
    case Energy
    case Telecom
    case About

    var description: String{
        switch self {
        case .Health: return "HEALTH"
        case .Construction: return "CONSTRUCTION"
        case .Retail: return "RETAIL"
        case .Education: return "EDUCATION"
        case .Entertainment: return "ENTERTAINMENT"
        case .Environment: return "ENVIRONMENT"
        case .Finance: return "FINANCE"
        case .Energy: return "ENERGY"
        case .Telecom: return "TELECOM"
        case .About: return "ABOUT US"

        }
    }
    
    var image: UIImage{
        switch self {
        case .Health: return UIImage.init(named: "HEALTH") ?? UIImage()
        case .Construction: return UIImage.init(named: "CONSTRUCTION") ?? UIImage()
        case .Retail: return UIImage.init(named: "RETAIL") ?? UIImage()
        case .Education: return UIImage.init(named: "EDUCATION")  ?? UIImage()
        case .Entertainment: return UIImage.init(named: "ENTERTAINMENT") ?? UIImage()
        case .Environment: return UIImage.init(named: "ENVIRONMENT") ?? UIImage()
        case .Finance: return UIImage.init(named: "FINANCE") ?? UIImage()
        case .Energy: return UIImage.init(named: "ENERGY") ?? UIImage()
        case .Telecom: return UIImage.init(named: "TELECOM") ?? UIImage()
        case .About: return UIImage.init(named: "TELECOM") ?? UIImage()

        }
    }
    
}
