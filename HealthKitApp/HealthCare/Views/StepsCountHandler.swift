//
//  StepsCountHandler.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 25/07/2023.
//

import Foundation
import HealthKit

extension StepsCountView {

    @MainActor
    class StepsCountHandler: ObservableObject {
        private var healthStore = HKHealthStore()
        private var healthKitManager = HealthKitManager()
        @Published var userStepCount = ""
        @Published var isAuthorized = false

        init() {
            changeAuthorizationStatus()
        }

        func healthRequest() {
            healthKitManager.setUpHealthRequest(healthStore: healthStore) {
                self.changeAuthorizationStatus()
                self.readStepsTakenToday()
            }
        }

        func readStepsTakenToday() {
            healthKitManager.readStepCount(forToday: Date(), healthStore: healthStore) { step in
                if step != 0.0 {
                    DispatchQueue.main.async {
                        self.userStepCount = String(format: "%.0f", step)
                    }
                }
            }
        }

        func changeAuthorizationStatus() {
            guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
            let status = self.healthStore.authorizationStatus(for: stepQtyType)
            
            switch status {
            case .notDetermined:
                isAuthorized = false
            case .sharingDenied:
                isAuthorized = false
            case .sharingAuthorized:
                isAuthorized = true
            @unknown default:
                isAuthorized = false
            }
        }
    }
}
