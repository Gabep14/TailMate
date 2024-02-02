//
//  LocationDetailsView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 2/1/24.
//

import SwiftUI
import MapKit




struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var isShowing: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    @Binding var isFavorite: Bool
    @Binding var results: [MKMapItem]
    @Binding var favorites: [FavoriteLocation]

 
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                Spacer()
                
                Button {
                    isShowing.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                    
                }
                
                
            }
            .padding(.horizontal)
            .padding(.top)
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
           
           
            HStack(spacing: 24) {
                
                
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                    
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                Button {
                    getDirections = true
                    isShowing = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            Button {
                isFavorite.toggle()
                if isFavorite, let mapSelection {
                    addToFavorites(name: mapSelection.placemark.name ?? "", coordiante: mapSelection.placemark.coordinate)
                }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
            }
            .foregroundColor(isFavorite ? .red : .blue)
        }
        .onAppear {
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
            print("DEBUG: Did call on change")

        }
//        .onChange(of: favorites) { _ in
//            print("Favorites: \(favorites)")
//        }
        .padding()
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
    
    func addToFavorites(name: String, coordiante: CLLocationCoordinate2D) {
        let favorite = FavoriteLocation(name: name, coordinate: coordiante)
        favorites.append(favorite)
        print("Favorites after adding: \(favorites)")
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), isShowing: .constant(false), getDirections: .constant(false), isFavorite: .constant(false), results: .constant([]), favorites: .constant([]))
}
