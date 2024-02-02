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
    @State var searchResults = [SearchResult]()
    @State private var showingSheet = false
    @State var locations: [Location] = []
    var body: some View {
        VStack {
          
                Button("Search", systemImage: "magnifyingglass") {
                    
                    showingSheet = true
                }
                .padding(10)
                .cornerRadius(10)
                .foregroundColor(.primary)
                
            }
            TabView {
                if showingSheet == false {
                    MapView(isSheetPresented: false, locations: $locations)
                        .tabItem { Label("Map", systemImage: "magnifyingglass") }
                                   
                } else {
                    MapView(isSheetPresented: true, locations: $locations)
                        .tabItem { Label("Map", systemImage: "magnifyingglass") }
                }
                FavoritesView(locations: $locations, searchResults: $searchResults)
                    .tabItem { Label("Favorites", systemImage: "heart") }
                

                AccountView()
                    .tabItem { Label("Account", systemImage: "person") }
            }
        }
   
}

#Preview {
    ContentView()
}

//extension CLLocationCoordinate2D {
//    static let fordField = CLLocationCoordinate2D(latitude: 42.34000, longitude: -83.0456)
//}
