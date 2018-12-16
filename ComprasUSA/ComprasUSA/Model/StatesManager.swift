//
//  StatesManager.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import CoreData

class StatesManager{
    
    static let shared = StatesManager()
    var state: [State] = []
    
    func loadStates(with context: NSManagedObjectContext){
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            state = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteStates(index: Int, context: NSManagedObjectContext ){
        let stateX = state[index]
        context.delete(stateX)
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
