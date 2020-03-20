//
//  Info.swift
//  insulina
//
//  Created by Julia  on 10/03/20.
//  Copyright © 2020 Julia Machado. All rights reserved.
//

import Foundation

class Info {
    var dose: Int
    var glicemia1: Int
    var resultado: String = ""
    // var glicemia2: Int?
                    
    init(dose: Int, glicemia1: Int, resultado: String){
        self.dose = dose
        self.glicemia1 = glicemia1
        self.resultado = resultado
        //self.glicemia2 = glicemia2
        //glicemia2: Int
    }
    
    func doseFinal() -> Int {
        let doseFinal: Int
        
        doseFinal = dose * glicemia1 / 100
        
        return doseFinal
        
    }
}

