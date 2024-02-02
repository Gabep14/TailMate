//
//  FavoritesSelectedView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI

struct FavoritesSelectedView: View {
    @Binding var locations: [Location]
    @Binding var searchResults: [SearchResult]

  //  var selectedLocation: Location
    var body: some View {
        VStack {
            Text("Tailgate")
            .navigationTitle("Tailgate Locations")
        }
    }
}

#Preview {
    FavoritesSelectedView(locations: .constant([]), searchResults: .constant([]))
                                     
}
