//
//  FavoritesView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var locations: [Location]
    @Binding var searchResults: [SearchResult]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locations, id: \.name) { location in
                    NavigationLink(destination: FavoritesSelectedView(locations: $locations, searchResults: $searchResults), label:  {
                        Text(location.name)
                        
                        
                    }
                    )
                }
                
                .navigationTitle("Favorites")
            }
        }
    }
}
#Preview {
    FavoritesView(locations: .constant([]), searchResults: .constant([]))
}
