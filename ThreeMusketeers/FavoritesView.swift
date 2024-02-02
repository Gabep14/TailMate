//
//  FavoritesView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI
import MapKit

struct FavoriteLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct FavoritesView: View {

    @Binding var favorites: [FavoriteLocation]

    
    var body: some View {
        NavigationView {
            List(favorites) { favorite in
                NavigationLink(destination: FavoritesSelectedView(favorites: $favorites)) {
                    Text(favorite.name)
                }
            }
                .onAppear {
                    print("Favorites: \(favorites)")
                }
                
                .navigationTitle("Favorites")
            }
        }
    }

#Preview {
    FavoritesView(favorites: .constant([]))
}
