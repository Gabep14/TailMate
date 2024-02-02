//
//  FavoritesSelectedView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI

struct FavoritesSelectedView: View {
    @Binding var favorites: [FavoriteLocation]

    var body: some View {
        VStack {
            List(favorites) { favorite in
                Text("Latitude: \(favorite.coordinate.latitude), Longitude: \(favorite.coordinate.longitude)")
            }
            
        }
        .navigationTitle("Tailgate Location")
    }
}

#Preview {
    FavoritesSelectedView(favorites: .constant([]))
                                     
}
