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
    // 3- after getting permission, it will show pop up to have the user permission, to write the data

    func setUpHealthRequest(healthStore: HKHealthStore, readSteps: @escaping () -> Void) {
        if HKHealthStore.isHealthDataAvailable(), let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) {
            healthStore.requestAuthorization(toShare: [stepCount], read: [stepCount]) { success, error in
                if success {
                    readSteps()
                } else if error != nil {
                    debugPrint(error ?? "", "🐞")
                }
            }
        }
    }

    // 1- determine the step count type
    // 2- add specific date to start counting steps
    // 3- cumulativeSum -> is to calculate the sum of all steps

    func readStepCount(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        
        }
        
        healthStore.execute(query)
        
    }
}
