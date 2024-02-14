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
    @State private var mapSelection: MKMapItem? = nil
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var isFavorite = false
    @Binding var favorites: [FavoriteLocation]
    @State var sampleTailgateAddresses: [String] = ["419 E Fort St Detroit, MI 48226", "1902 Saint Antoine St Detroit, MI 48226", "1600 Woodward Ave Detroit, MI  48226", "1777 Third St Detroit, MI  48226", "1445 Adelaide St Detroit, MI  48207", "168 W Columbia St Detroit, MI  48201", "1 Washington Blvd Detroit, MI 48226"]
    @State var sampleTailgates: [MKMapItem] = []
    
    
    var body: some View {
        VStack {
            HStack() {
                if routeDisplaying {
                    Text("Cancel Route")
                    Button {
                        routeDisplaying=false
                        showDetails = false
                        getDirections = false
                        route = nil
                        userPosition = .region(.userRegion)
                        routeDestination = nil
                    } label: {Image(systemName:"x.circle")
                    }
                }
            }
            Map(position: $userPosition , selection: $mapSelection) {
                UserAnnotation()
                let square1 = [CLLocationCoordinate2D(latitude: 42.34614, longitude: -83.06790), CLLocationCoordinate2D(latitude: 42.35132, longitude: -83.04957), CLLocationCoordinate2D(latitude: 42.32957, longitude: -83.04429), CLLocationCoordinate2D(latitude: 42.32636, longitude: -83.05803)]
                let square2 = [CLLocationCoordinate2D(latitude: 42.34531, longitude: -83.06716), CLLocationCoordinate2D(latitude: 42.3340354, longitude: -83.0740565), CLLocationCoordinate2D(latitude: 42.3250097, longitude: -83.0675565), CLLocationCoordinate2D(latitude: 42.327587, longitude: -83.054431)]
                let square3 = [CLLocationCoordinate2D(latitude: 42.35309, longitude: -83.05009), CLLocationCoordinate2D(latitude: 42.35452, longitude: -83.03903), CLLocationCoordinate2D(latitude: 42.33263, longitude: -83.03094), CLLocationCoordinate2D(latitude: 42.32999, longitude: -83.04322)]
                
                
                MapPolygon(coordinates: square1)
                    .foregroundStyle(.orange.opacity(0.60))
                    .mapOverlayLevel(level: .aboveLabels)
                
                MapPolygon(coordinates: square2)
                    .foregroundStyle(.green.opacity(0.60))
                    .mapOverlayLevel(level: .aboveLabels)
                
                MapPolygon(coordinates: square3)
                    .foregroundStyle(.red.opacity(0.60))
                    .mapOverlayLevel(level: .aboveLabels)
                
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
                ForEach(sampleTailgates, id: \.self) { item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
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
        }
        
        
        //                                .onTapGesture {
        //                                    for favorite in favorites {
        //                                        favorites.append(favorite)
        //                                        print("Favorites is now: \(favorites)")
        //                                    }
        //                                }
        
        
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
        
        .onChange(of: mapSelection) { oldValue, newValue in
            if let newValue = newValue {
                Task {
                    let _ = await fetchScene(for: newValue.placemark.coordinate)
                }
            }
            showDetails = newValue != nil
        }
        
        .sheet(isPresented: $showDetails, content: {
            LocationDetailsView(mapSelection: $mapSelection, isShowing: $showDetails, getDirections: $getDirections, isFavorite: $isFavorite, results: $results, favorites: $favorites)
                .presentationDetents([.height(400)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
                .presentationCornerRadius(12)
                .onAppear {
                    //                            if mapSelection != nil {
                    //                                reverse(location: location, geoCoder: geoCoder)
                    //                            }
                }
        })
        .onChange(of: showDetails, {oldValue, newValue in
            if !newValue {
                isFavorite = false
            }
        })
        //        .onChange(of: mapSelection) { oldValue, newValue in
        //            if let newValue = newValue {
        //                Task {
        //                    do {
        //                        let lookAroundScene = try await fetchScene(for: newValue.placemark.coordinate)
        //                        // Use the fetched lookAroundScene here
        //                    } catch {
        //                        print("Error fetching scene: \(error)")
        //                    }
        //                }
        //            }
        //            showDetails = newValue != nil
        //        }
        
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .persistentSystemOverlays(.hidden)
        .onAppear {
            for address in sampleTailgateAddresses {
                fetchCoordinates(address)

            }
            //                Task {
            //                    for tailgate in sampleTailgates {
            //                        do {
            //                            if let mapSelection {
            //                                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
            //                                let lookAroundScene = try await request.scene
            //                            }
            //                        }
            //                        catch {
            //                            print("Error")
            //                    }
            //                }
            //            }
            //       }
        }
        .onChange(of: mapSelection) {
            Task {
                for address in sampleTailgateAddresses {
                   await searchSampleTailgate(address)
                }
            }
        }
    }
        
        
        
        
        func fetchCoordinates(_ address: String) {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { placemarks, error in
                guard let placemark = placemarks?.first, let location = placemark.location
                else {
                    print("no location found")
                    return
                }
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                sampleTailgates.append(mapItem)
            }
        }
        func createCircleRenderer(for circle: MKCircle) -> MKCircleRenderer {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.lineWidth = 2
            renderer.strokeColor = .systemBlue
            renderer.fillColor = .systemTeal
            renderer.alpha = 0.5
            return renderer
        }
    }



extension MapView {
    
    func fetchScene(for coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
            do {
                if let mapSelection = mapSelection {
                    let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                    let lookAroundScene = try await request.scene
                    return lookAroundScene
                    // Now you have the look around scene, you can use it as needed
                }
            } catch {
                print("Error fetching scene: \(error)")
            }
        return nil
        }
        
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func searchSampleTailgate(_ address: String) async {
        let request = MKLocalSearch.Request()
        for address in sampleTailgateAddresses {
            fetchCoordinates(address)
            request.naturalLanguageQuery = address
        }
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
        return .init(latitude: 42.330810546875, longitude: -83.04602813720703)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
}


    

#Preview {
    MapView(favorites: .constant([]))
}
