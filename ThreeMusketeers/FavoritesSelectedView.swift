//
//  FavoritesSelectedView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI
import MapKit

struct FavoritesSelectedView: View {
  //  @Binding var favorites: [FavoriteLocation]
    var selectedFavorite: FavoriteLocation
    @Binding var tailgateName: String
    @Binding var locationName: [String]  //remove this


    
    var body: some View {
        NavigationStack {
            VStack {
                Text(tailgateName)
                    .font(.title)
                    .padding()
                Text(selectedFavorite.name)
                Text("Latitude: \(selectedFavorite.coordinate.latitude), Longitude: \(selectedFavorite.coordinate.longitude)")
                    .padding()
            }
            .navigationTitle("Tailgate Location")
        }
    }

}

#Preview {
    FavoritesSelectedView(selectedFavorite: FavoriteLocation(name: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), subThoroughfare: ""), tailgateName: .constant(""), locationName: .constant([""]))
                                     
}
