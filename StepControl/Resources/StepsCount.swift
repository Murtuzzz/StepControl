//import UIKit
//import HealthKit
//
//class Steps: UIViewController {
//
//    static let shared = Steps()
//
//    let healthStore = HKHealthStore()
//    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//    var stepsAmount = ""
//
//    func getAuthorization() {
//        let readTypes: Set<HKObjectType> = [stepsCount]
//
//        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
//            if let error = error {
//                print(error)
//            } else if success {
//                self.getSteps(completion: { steps,error in
//                    print("Steps: \(steps)")
//                })
//            }
//        }
//    }
//
//    func getSteps(completion: @escaping ([Double], Error?) -> ()) {
//        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        var dailySteps: [Double] = []
//        let calendar = Calendar.current
//        let now = Date()
//        let desiredStartDate = calendar.date(byAdding: .day, value: -7, to: now)
//        let startOfDay = Calendar.current.startOfDay(for: desiredStartDate ?? now)
//        var interval = DateComponents()
//        interval.day = 1
//
//        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
//                                                quantitySamplePredicate: nil,
//                                                options: [.cumulativeSum],
//                                                anchorDate: startOfDay,
//                                                intervalComponents: interval)
//
//        query.initialResultsHandler = { query, results, error in
//            if let error = error {
//                completion([], error)
//                return
//            }
//
//            results?.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
//                if let quantity = statistics.sumQuantity() {
//                    let steps = quantity.doubleValue(for: HKUnit.count())
//                    dailySteps.append(steps)
//                    print("dailySteps = \(dailySteps)")
//                }
//            }
//
//            completion(dailySteps.reversed(), nil)
//        }
//
//        HKHealthStore().execute(query)
//    }
//
//}

import UIKit
import HealthKit

class Steps: UIViewController {

    static let shared = Steps()

    let healthStore = HKHealthStore()
    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var stepsAmount = ""

    func getAuthorization() {
        let readTypes: Set<HKObjectType> = [stepsCount]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.getSteps(completion: { steps,error in
                    print("Steps: \(steps)")
                })
            }
        }
    }

    func getSteps(completion: @escaping ([Date : Double], Error?) -> ()) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion([:], error)
                return
            }
            
            var data = [Date : Double]()
            
            results?.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let steps = quantity.doubleValue(for: HKUnit.count())
                    
                    data[date] = steps
                }
            }
            
            completion(data, nil)
        }
        
        HKHealthStore().execute(query)
    }
}
