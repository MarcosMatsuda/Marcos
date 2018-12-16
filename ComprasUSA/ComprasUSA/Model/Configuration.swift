//
//  Configuration.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import Foundation

enum userDefaultKeys: String {
    case iof = "iof"
    case cotacao = "cotacao"
    
}

class Configuration {
    
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    var iof: Double{
        get{
            return defaults.double(forKey: userDefaultKeys.iof.rawValue)
        }
        set{
            defaults.set(newValue, forKey: userDefaultKeys.iof.rawValue)
        }
    }
    
    var cotacao: Double{
        get{
            return defaults.double(forKey: userDefaultKeys.cotacao.rawValue)
        }
        set{
            defaults.set(newValue, forKey: userDefaultKeys.cotacao.rawValue)
        }
    }
}
