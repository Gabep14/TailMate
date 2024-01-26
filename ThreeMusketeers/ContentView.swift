//
//  ContentView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/24/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
      //  Text("Tailgates Near You")
        Map {
            Annotation("Ford Field", coordinate: .fordField) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                    Text("🏈")
                        .padding(5)
                    Text("Hi")
                }
            }
        }
    }
}
    


#Preview {
    ContentView()
}

extension CLLocationCoordinate2D {
    static let fordField = CLLocationCoordinate2D(latitude: 42.34000, longitude: -83.0456)
}
