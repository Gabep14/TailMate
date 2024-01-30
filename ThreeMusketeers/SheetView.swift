//
//  SheetView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/26/24.
//

import SwiftUI
import MapKit


struct SheetView: View {

    @State private var locationService = LocationService(completer: .init())
    @State private var search = ""
    @Binding var searchResults: [SearchResult]
    
    var body: some View {
       
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $search)
                    .autocorrectionDisabled()
                
                    .onSubmit {
                        Task {
                            searchResults = (try? await locationService.search(with: search)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGray())
            
            Spacer()
            
            List {
                ForEach(locationService.completions) { completion in
                    Button(action: { didTapOnCompletion(completion) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            Text(completion.subTitle)
                            
                            if let url = completion.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    .listRowBackground(Color.clear)
                }
            }
            
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        
        .onChange(of: search) {
            locationService.update(queryFragment: search)
        }
        
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    struct TextFieldGray: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(10)
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.primary)
        }
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = [singleLocation]
            }
        }
    }
}




//#Preview {
    struct SheetView_Previews: PreviewProvider {
        @State static var searchResults: [SearchResult] = [] 
        
        static var previews: some View {
            SheetView(searchResults: $searchResults)
                .previewDisplayName("SheetView Preview")
        }
    }

//}
