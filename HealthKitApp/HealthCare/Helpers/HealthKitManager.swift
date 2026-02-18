//
//  HealthKitManager.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 26/07/2023.
//

import Foundation
import HealthKit

struct HealthKitManager {

    // 1- check if health care is available on device
    // 2- determine which service you want in this case, we want steps count
    // 3- after getting permission, pop up lets user grant access to write the data

    func setUpHealthRequest(healthStore: HKHealthStore, onSuccess: @escaping () -> Void) {
        if HKHealthStore.isHealthDataAvailable(), let distanceType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) {
            healthStore.requestAuthorization(toShare: [distanceType], read: [distanceType]) { success, error in
                if success {
                    onSuccess()
                } else if error != nil {
                    debugPrint(error ?? "", "🐞")
                }
            }
        }
    }

    // 1- determine the step count type
    // 2- add specific date to start counting steps
    // 3- cumulativeSum -> average of samples in range

    func fetchStepTotal(forDate: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let dayStart = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: dayStart, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        
        }
        
        healthStore.execute(query)
        
    }
}
