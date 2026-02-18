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
        private var store = HKHealthStore()
        private var healthKitManager = HealthKitManager()
        @Published var displayedCalorieCount = ""
        @Published var isAuthorized = false

        init() {
            refreshAuthState()
        }

        func requestHealthAccess() {
            healthKitManager.setUpHealthRequest(healthStore: store) {
                self.refreshAuthState()
                self.loadYesterdaySteps()
            }
        }

        func loadYesterdaySteps() {
            healthKitManager.fetchStepTotal(forDate: Date(), healthStore: store) { step in
                if step != 0.0 {
                    DispatchQueue.main.async {
                        self.displayedCalorieCount = String(format: "%.0f", step)
                    }
                }
            }
        }

        func refreshAuthState() {
            guard let heartRateType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
            let status = self.store.authorizationStatus(for: heartRateType)
            
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
