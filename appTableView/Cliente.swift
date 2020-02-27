//
//  Cliente.swift
//  appTableView
//
//  Created by Tecnologico Roque on 2/14/20.
//  Copyright © 2020 Tecnologico Roque. All rights reserved.
//

import Foundation

class Cliente{
    var cvt :String = ""
    var nomcte : String = ""
    var domcte : String = ""
    
    init(cvt :String, nombre : String, dom :String) {
        self.cvt = cvt
        self.nomcte = nombre
        self.domcte = dom
    }
}
