//
//  StepsCountView.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 25/07/2023.
//

import SwiftUI

struct StepsCountView: View {

    @StateObject internal var countHandler = StepsCountHandler()

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Step Counter")
                .foregroundColor(.white)
                .font(.largeTitle)

            // Show when user has already authorized
            Group {
                Text("Please authorize step counter !")
                    .foregroundColor(.red)

                Button {
                    countHandler.requestHealthAccess()
                } label: {
                    Text("Authorize")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.red))
                .cornerRadius(10)

            }.isHidden(countHandler.isAuthorized, removeFromView: true)

            
            // Not authorized yet
            Group {
                Text("Today's steps 👟")
                    .foregroundColor(.orange)
                    .font(.largeTitle)

                Text("\(countHandler.displayedCalorieCount)")
                    .foregroundColor(.orange)
                    .font(.largeTitle)

            }.isHidden(!countHandler.isAuthorized, removeFromView: true)
        }
    }
}
