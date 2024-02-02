//
//  Locations.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/26/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    @State var isSheetPresented = false
    @State private var scene: MKLookAroundScene?
    @Binding var locations: [Location]
    //    @State var newLoaction: Location
    
    var body: some View {
        
//       let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.34, longitude: -83.0456), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        
    //    MapReader { proxy in
            Map(position: $position, selection: $mapSelection) {
            //    UserAnnotation()
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
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }

//                    ForEach(searchResults) { result in
//                        Marker(coordinate: result.location) {
//                            Image(systemName: "mappin")
//                        }
//                        .tag(result)
//                    }
//                ForEach(locations) { location in
//                    Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
//                }
                }
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
                } })
        
            .onChange(of: mapSelection, {oldValue, newValue in
                showDetails = newValue != nil
            })
        
            .sheet(isPresented: $showDetails, content: {
                LocationDetailsView(mapSelection: $mapSelection, isShowing: $showDetails, getDirections: $getDirections)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            })
          
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            
            
          //      .mapStyle(.hybrid)
//                .onTapGesture {
//                    position in
//                    if let coordinate = proxy.convert( position, from: .local) {
//                        let newLocation = Location(id: UUID(), name: "Tailgate", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
//                        locations.append(newLocation)
//                        let newSearch = SearchResult(location: coordinate)
//                    }
//                }
//                .overlay(alignment: .bottom) {
//                    if selectedLocation != nil {
//                        LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
//                            .frame(height: 150)
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .safeAreaPadding(.bottom, 40)
//                            .padding(.horizontal, 20)
//                    }
//                }
//              //  .ignoresSafeArea()
//                
//                .onChange(of: selectedLocation) {
//                    if let selectedLocation {
//                        Task {
//                            scene = try? await fetchScene(for: selectedLocation.location)
//                        }
//                    }
//                    isSheetPresented = selectedLocation == nil
//                }
//                
//                
//                .onChange(of: searchResults) {
//                    if let firstResult = searchResults.first, searchResults.count == 1 {
//                        selectedLocation = firstResult
//                    }
//                }
//                
//                .sheet(isPresented: $isSheetPresented) {
//                    SheetView(searchResults: $searchResults, locations: $locations)
//                }
                
           // }
       
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
                        position = .rect(rect)
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
    MapView(locations: .constant([]))
}
