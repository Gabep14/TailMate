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
    @State private var tailgateName = ""
    @State private var showingAlert = false
    @State private var showingTextField = false
    
    func saveFavorites() {
        DirectoryService.writeModelToDisk(favorites)
    }

    var body: some View {
    
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mapSelection?.placemark.coordinate.latitude ?? 0, longitude: mapSelection?.placemark.coordinate.longitude ?? 0)
        
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
                    .frame(height: 180)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
           
            VStack(spacing: 20) {
                Button {
                    isFavorite.toggle()
                    if isFavorite {
                        showingAlert = true
                        showingTextField = true
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                    Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(isFavorite ? .red : .gray)
                        .cornerRadius(12)
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
                            .frame(width: 120, height: 40)
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
                            .frame(width: 120, height: 40)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            .alert("Enter tailgate name", isPresented: $showingAlert) {
                TextField("Enter tailgate name", text: $tailgateName)
                Button("OK") {
                        submit(location: location, geoCoder: geoCoder, tailgateName: tailgateName)
                }
            }
            .foregroundColor(isFavorite ? .red : .blue)
            .padding()
        }
        .onAppear {
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
            print("DEBUG: Did call on change")

        }
        
            
        .padding()
        .persistentSystemOverlays(.hidden)
    }
    
    func submit(location: CLLocation, geoCoder: CLGeocoder, tailgateName: String) {
        if mapSelection != nil {
            reverse(location: location, geoCoder: geoCoder, tailgateName: tailgateName)
        }
    }
    
    func reverse(location: CLLocation, geoCoder: CLGeocoder, tailgateName: String) {
        geoCoder.reverseGeocodeLocation(location)  {
            placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            var favoriteName = tailgateName + "\n"
            
            if let subThoroughfare = placemark.subThoroughfare {
                favoriteName += subThoroughfare + " "
            }
            if let thoroughfare = placemark.thoroughfare {
                favoriteName += thoroughfare + ", "
                print(thoroughfare)
            }
            if let city = placemark.locality {
                favoriteName += city + ", "
                print(city)
            }
            if let country = placemark.isoCountryCode {
                favoriteName += country + " "

                print(country)
            }
            if let zip = placemark.postalCode {
                favoriteName += zip + " "

                print(zip)
            }
            favorites.append(FavoriteLocation(name: favoriteName, coordinate: location.coordinate))
            saveFavorites()
       
        }
    }
    
}


extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection = mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                let scene = try? await request.scene
                lookAroundScene = scene
            }
        }
    }
    
//    func addToFavorites(name: String, coordiante: CLLocationCoordinate2D, subThoroughFare: String) {
//        let favorite = FavoriteLocation(name: name, coordinate: coordiante, subThoroughfare: subThoroughFare)
//        favorites.append(favorite)
//        print("Favorites after adding: \(favorites)")
//    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), isShowing: .constant(false), getDirections: .constant(false), isFavorite: .constant(false), results: .constant([]), favorites: .constant([]))
}
