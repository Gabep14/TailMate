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
    @State var results = [MKMapItem]()
    @State private var favorites = [FavoriteLocation]()

    
    var body: some View {
        VStack {
            TabView {
                
                MapView(favorites: $favorites)
                    .tabItem { Label("Map", systemImage: "magnifyingglass") }
                    
                FavoritesView(favorites: $favorites)
                    .tabItem { Label("Favorites", systemImage: "heart") }
                
                AccountView()
                    .tabItem { Label("Account", systemImage: "person") }
            }
        }
    }
}

#Preview {
    ContentView()
}
