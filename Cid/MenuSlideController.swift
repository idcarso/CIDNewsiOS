//
//  MenuSlideController.swift
//  Cid
//
//  Created by Ada Palazuelos on 6/24/19.
//  Copyright © 2019 Mac CTIN . All rights reserved.
//

import UIKit

private let reuseIdentifier = "MenuOptionCell"

class MenuSlideController: UIViewController{
    
    //MARK: Properties
    
    var tableView:UITableView!
    var delegate: HomeControllerDelegate?
    
    
    //MARK: Init

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        // view.backgroundColor = .white
        // configureNavigationBar()

       
    }
    
  
    //MARK: Handlers
    
    func restoreDefaultTableView(index:Int){
        /*
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundView = nil*/
        
        for cells in tableView.visibleCells{
            cells.backgroundView = nil
        }
    }
    
    
    
    func configTableView(){
        
        let headerMenu = UIView()
        headerMenu.backgroundColor = UIColor.init(named: "MenuSlide")
        view.addSubview(headerMenu)
        headerMenu.translatesAutoresizingMaskIntoConstraints = false
        headerMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 250).isActive = true
        headerMenu.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let footerMenu = UIView()
        view.addSubview(footerMenu)
        footerMenu.translatesAutoresizingMaskIntoConstraints = false
        footerMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 150).isActive = true
        footerMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerMenu.heightAnchor.constraint(equalToConstant: 100).isActive = true
        footerMenu.backgroundColor = UIColor.init(named: "MenuSlide")

        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor.init(named: "MenuSlide")
        tableView.separatorStyle = .none
        tableView.rowHeight  = (view.frame.height - 150 )/11

        tableView.sizeToFit()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: footerMenu.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerMenu.bottomAnchor).isActive = true

        
        
        let imageName = "logocidnews"
        let image = UIImage(named: imageName)
        let iconCidImg = UIImageView(image: image!)
        let mFrame  = view.frame.width
        let xFooter = (mFrame - 80)/2
        let xDistance:CGFloat = 80 + xFooter - mFrame/8

        iconCidImg.frame = CGRect(x: xDistance, y: 0, width: mFrame/4, height: 50)
        iconCidImg.contentMode = .scaleAspectFit
        footerMenu.addSubview(iconCidImg)
   
    }
    
    /*
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Slide Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "HEALTH"), style: .plain, target: self, action: #selector(handleMenuToggle))
    }*/

}
extension MenuSlideController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionMenu.text = menuOption?.description
        cell.iconImgView.image = menuOption?.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption.init(rawValue: indexPath.row)
        delegate?.handleMenuToggle(forMenuOption: menuOption) //Close the Menu
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(named: "MenuSelected")
        
        tableView.cellForRow(at: indexPath)?.backgroundView = bgColorView
        
    }
    
}
