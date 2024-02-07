//
//  FavoritesView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI
import MapKit

struct FavoriteLocation: Identifiable, Codable {
    let id: UUID
    let name: String
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    var lat: Double
    var lon: Double
    let subThoroughfare: String
    init(name: String, lat: Double, lon: Double, subThoroughfare: String) {
        self.id = UUID()
        self.name = name
        self.lat = lat
        self.lon = lon
        self.subThoroughfare = subThoroughfare
    }
    init(name: String, coordinate: CLLocationCoordinate2D, subThoroughfare: String) {
        self.id = UUID()
        self.name = name
        self.lat = coordinate.latitude
        self.lon = coordinate.longitude
        self.subThoroughfare = subThoroughfare
    }
}

struct FavoritesView: View {
    
    @Binding var favorites: [FavoriteLocation]
//    @AppStorage("Favorite") var selectedFavorite: FavoriteLocation?
    @Binding var searchText: String
    @Binding var mapSelection: MKMapItem?
    @Binding var isShowing: Bool
    @Binding var getDirections: Bool
    @Binding var tailgateName: String
    @Binding var locationName: [String]


    
    var filteredFavorites: [FavoriteLocation] {
        if searchText.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredFavorites) { favorite in
                    NavigationLink(destination: FavoritesSelectedView(selectedFavorite: favorite, tailgateName: $tailgateName, locationName: $locationName)) {
                        Text("Tailgate at:  \(favorite.name)")
                    }
                }
                .onDelete { indexSet in
                    favorites.remove(atOffsets: indexSet)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
    FavoritesView(favorites: .constant([]), searchText: .constant(""), mapSelection: .constant(nil), isShowing: .constant(false), getDirections: .constant(false), tailgateName: .constant("test"), locationName: .constant(["test"]))
}
