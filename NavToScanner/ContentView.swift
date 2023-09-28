//
//  ContentView.swift
//  NavToScanner
//
//  Created by Warren Hansen on 9/28/23.
//

import SwiftUI
struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
enum AppState: Hashable, Codable {
    case newDevice(String)
    case scanner(String)
    
}

struct Dashboard: View {
    @State private var path = NavigationPath()
    var body: some View {
        VStack {
            NavigationStack(path: $path) {
                List {
                    NavigationLink("Add A New Device", value: AppState.newDevice("New Device"))
                }
                .navigationDestination(for: AppState.self) { state in
                    switch state {
                    case .newDevice(let textValue):
                        NewDeviceView(text: textValue, path: $path)
                    case .scanner(let textValue):
                        ScannerView(text: textValue, path: $path)
                    }
                }
                .navigationTitle("Root view")
            }
            VStack {
                HStack {
                    Text("Path: \(path.count)")
                    Spacer()
                    Button {
                        path = NavigationPath()
                    } label: {
                        Text("Home")
                    }
                }
                .padding(.all)
            }
        }
    }
}

struct NewDeviceView: View {
    let text: String
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            Text("\(text) view showing")
            Text("Enter Serial Number or use...")
            Divider()
            NavigationLink("Barcode Scanner", value: "Scanner")
        }
        .navigationDestination(for: String.self) { textValue in
            ScannerView(text: textValue, path: $path)
        }
        .navigationTitle(text)
    }
}

struct ScannerView: View {
    @State var text: String
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.blue)
                Text("Scanning...")
                    .font(.headline)
            }
        }
        .navigationTitle(text)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                path = NavigationPath()
            }
        }
    }
}
