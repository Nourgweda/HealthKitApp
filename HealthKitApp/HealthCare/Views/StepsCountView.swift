//
//  StepsCountView.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 25/07/2023.
//

import SwiftUI

struct StepsCountView: View {

    @StateObject internal var viewHandler = StepsCountHandler()

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Step Counter")
                .foregroundColor(.white)
                .font(.largeTitle)

            // if not authorized
            Group {
                Text("Please authorize step counter !")
                    .foregroundColor(.red)

                Button {
                    viewHandler.healthRequest()
                } label: {
                    Text("Authorize")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.red))
                .cornerRadius(10)

            }.isHidden(viewHandler.isAuthorized, remove: true)

            
            // if authorized
            Group {
                Text("Today's steps 👟")
                    .foregroundColor(.orange)
                    .font(.largeTitle)

                Text("\(viewHandler.userStepCount)")
                    .foregroundColor(.orange)
                    .font(.largeTitle)

            }.isHidden(!viewHandler.isAuthorized, remove: true)
        }
    }
}
