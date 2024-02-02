//
//  Locations.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/26/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var userPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var isFavorite = false
    @Binding var favorites: [FavoriteLocation]
    @GestureState private var tapLocation: CGPoint?
 
    var body: some View {
        
            Map(position: $userPosition , selection: $mapSelection) {
                        UserAnnotation()
                        Annotation("My location", coordinate: .userLocation) {
                            ZStack {
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.blue.opacity(0.25))
                                
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.blue)
                                
                            }
                        }
                        ForEach(results, id: \.self) {item in
                            if routeDisplaying {
                                if item == routeDestination {
                                    let placemark = item.placemark
                                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                }
                                
                            } else {
                                let placemark = item.placemark
                                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                            }
                        }
                        
                        if let route = route {
                            MapPolyline(route.polyline)
                                .stroke(.blue, lineWidth: 6)
                        }
                        
                    }
                
                
                
                //                .onTapGesture {
                //                    for favorite in favorites {
                //                        favorites.append(favorite)
                //                        print("Favorites is now: \(favorites)")
                //                    }
                //                }
                
                .overlay(alignment: .top) {
                    TextField("Search", text: $searchText)
                        .font(.subheadline)
                        .padding(12)
                        .background(.white)
                        .padding()
                        .shadow(radius: 10)
                }
                .onSubmit(of: .text) {
                    Task { await searchPlaces() }
                }
                .onChange(of: getDirections, { oldValue, newValue in
                    if newValue {
                        fetchRoute()
                    }
                })
                
                .onChange(of: mapSelection, {oldValue, newValue in
                    showDetails = newValue != nil
                })
                
                .sheet(isPresented: $showDetails, content: {
                    LocationDetailsView(mapSelection: $mapSelection, isShowing: $showDetails, getDirections: $getDirections, isFavorite: $isFavorite, results: $results, favorites: $favorites)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
                })
                
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                
            }
            
        }
    

    
        private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
            let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
            return try await lookAroundScene.scene
        }


extension MapView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        userPosition = .rect(rect)
                    }
                }
            }
        }
    }
}



extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 42.34, longitude: -83.0456)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}


    

#Preview {
    MapView(favorites: .constant([]))
}
