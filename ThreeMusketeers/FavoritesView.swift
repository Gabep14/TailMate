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
    init(name: String, lat: Double, lon: Double) {
        self.id = UUID()
        self.name = name
        self.lat = lat
        self.lon = lon
    }
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.lat = coordinate.latitude
        self.lon = coordinate.longitude
    }
}

struct FavoritesView: View {
    
    @Binding var favorites: [FavoriteLocation]
    @Binding var searchText: String
    @Binding var mapSelection: MKMapItem?
    @Binding var isShowing: Bool
    @Binding var getDirections: Bool
    @Binding var tailgateName: String
    @Binding var locationName: [String]


    
    func loadFavorites() {
        favorites = DirectoryService.readModelFromDisk()
    }
    
    func saveFavorites() {
        DirectoryService.writeModelToDisk(favorites)
    }
    
    
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
                    saveFavorites()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                loadFavorites()
            }
            
            .navigationTitle("Favorite Tailgates")
        }
    }
}

#Preview {
    FavoritesView(favorites: .constant([]), searchText: .constant(""), mapSelection: .constant(nil), isShowing: .constant(false), getDirections: .constant(false), tailgateName: .constant("test"), locationName: .constant(["test"]))
}
