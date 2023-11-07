
import UIKit
import HealthKit

class Steps: UIViewController {

    static let shared = Steps()

    let healthStore = HKHealthStore()
    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let flightsCount = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
    var stepsAmount = ""

    func getAuthorization() {
        let readTypes: Set<HKObjectType> = [stepsCount, flightsCount]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.getSteps(completion: { steps, error in
                    
//                    print("Steps -> \(steps)")
                })
            }
        }
        
//        let typesToRead: Set<HKObjectType> = [flightsCount]
        
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//            if let error = error {
//                print(error)
//            }
//            else if success {
//                //self.getFloors(completion: { (flights, error) in
//                    // Handle flights and errors here
//            }
//        }
    }

    func getSteps(completion: @escaping ([Date: Double], Error?) -> ()) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        var dailySteps: [Date: Double] = [:]
        let calendar = Calendar.current
        let now = Date()
        let desiredStartDate = calendar.date(byAdding: .day, value: -7, to: now)
        let startOfDay = Calendar.current.startOfDay(for: desiredStartDate ?? now)
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

            results?.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = quantity.doubleValue(for: HKUnit.count())
                    dailySteps[statistics.startDate] = steps
                } else {
                    dailySteps[statistics.startDate] = 0
                }
            }

            completion(dailySteps, nil)
        }

        HKHealthStore().execute(query)
    }

}

