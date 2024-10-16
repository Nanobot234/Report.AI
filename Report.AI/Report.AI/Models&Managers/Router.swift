//
//  Router.swift
//  Report.AI
//
//  Created by Nana Bonsu on 10/13/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject
{
    @Published var loginNavPath: NavigationPath
    
    init() {
        loginNavPath = NavigationPath()
        
        
    }
    
}
