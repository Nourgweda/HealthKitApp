//
//  ContentView.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 25/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            StepsCountView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
