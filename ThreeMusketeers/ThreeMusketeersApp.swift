//
//  ThreeMusketeersApp.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/24/24.
//

import SwiftUI

@main
struct ThreeMusketeersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(isShowing: .constant(false), getDirections: .constant(false), tailgateName: .constant(""))
        }
    }
}
