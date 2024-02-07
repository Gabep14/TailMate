//
//  ContentView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/24/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var showingSheet = false
    @State private var usernameText = ""
    @State private var passwordText = ""
    @State private var text = ""
   // @State var results = [MKMapItem]()
    @State var favorites: [FavoriteLocation] = []
    @State private var mapSelection: MKMapItem?
    @Binding var isShowing: Bool
    @Binding var getDirections: Bool
    @Binding var tailgateName: String
    @State var locationName: [String] = [] // REMOVE THIS TO FIX BUILD


    
    var body: some View {
        VStack {
            TabView {
                
                MapView(favorites: $favorites)
                    .tabItem { Label("Map", systemImage: "magnifyingglass") }
                    
                FavoritesView(favorites: $favorites, searchText: $searchText, mapSelection: $mapSelection, isShowing: $isShowing, getDirections: $getDirections, tailgateName: $tailgateName, locationName: $locationName)
                    .tabItem { Label("Favorites", systemImage: "heart") }
                
                AccountView(usernameText: $usernameText, passwordText: $passwordText)
                    .tabItem { Label("Account", systemImage: "person") }
            }
        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    ContentView(isShowing: .constant(false), getDirections: .constant(false), tailgateName: .constant(""))
}
