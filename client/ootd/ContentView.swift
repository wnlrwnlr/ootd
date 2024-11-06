//
//  ContentView.swift
//  ootd
//
//  Created by Gyuni on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "tshirt")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("OOTD")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
