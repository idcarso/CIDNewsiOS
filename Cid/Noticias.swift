//
//  Noticias.swift
//  Cid
//
//  Created by Mac CTIN  on 23/10/18.
//  Copyright © 2018 Mac CTIN . All rights reserved.
//

import Foundation


class Noticias :NSObject    //Se define el tipo de Objeto Noticias
{
    var title:String = ""
    var autor:String = ""
    var urlToImg:String = ""
    var url:String = ""
    var cat:String = ""
    
    init(title: String, autor: String, urlToImg: String, url: String,cate:String) {
        self.title = title
        self.autor = autor
        self.urlToImg = urlToImg
        self.url = url
        self.cat = cate
    }
}
