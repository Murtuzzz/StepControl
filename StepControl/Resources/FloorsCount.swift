//
//  FloorsCount.swift
//  StepControl
//
//  Created by Мурат Кудухов on 15.10.2023.
//

//import UIKit
//import HealthKit
//
//class FloorsCount: UIViewController {
//
//    static let shared = FloorsCount()
//
//    let healthStore = HKHealthStore()
//    let flightsCount = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
//    var flightsArray: [Double] = []
//
//    func getAuthorization() {
//
//        let typesToRead: Set<HKObjectType> = [flightsCount]
//
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//            if let error = error {
//                print(error)
//            }
//            else if success {
//                self.getFloors(completion: { (flights, error) in
//                    // Handle flights and errors here
//                })
//            }
//        }
//    }
//
//    func getFloors(completion: @escaping ([Double], Error?) -> ()) {
//        var dailyFlights: [Double] = []
//
//        let calendar = Calendar.current
//        let now = Date()
//        let desiredStartDate = calendar.date(byAdding: .day, value: -7, to: now)
//        let startOfDay = Calendar.current.startOfDay(for: desiredStartDate ?? now)
//        var interval = DateComponents()
//        interval.day = 1
//
//        let query = HKStatisticsCollectionQuery(quantityType: flightsCount,
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
//                    let flights = quantity.doubleValue(for: HKUnit.count())
//                    dailyFlights.append(flights)
//                } else {
//                    dailyFlights.append(0)
//                }
//            }
//
//            completion(dailyFlights, nil)
//
//        }
//
//        HKHealthStore().execute(query)
//    }
//
//}


import UIKit
import HealthKit

class FloorsCount: UIViewController {
    
    static let shared = FloorsCount()
    
    let healthStore = HKHealthStore()
    let flightsCount = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
    var flightsArray: [Double] = []
    
    func getAuthorization() {
        
        let typesToRead: Set<HKObjectType> = [flightsCount]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if let error = error {
                print(error)
            }
            else if success {
                self.getFloors(completion: { (flights, error) in
                    // Handle flights and errors here
                })
            }
        }
    }
    
    func getMonthlyFloors(completion: @escaping ([Double], Error?) -> ()) {
        var monthlyFlights: [Double] = []
        
        let calendar = Calendar.current
        let now = Date()
        let desiredStartDate = calendar.date(byAdding: .month, value: -6, to: now) // Установка желаемой даты начала (например, за последние 6 месяцев)
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: desiredStartDate ?? now)) ?? now
        var interval = DateComponents()
        interval.month = 1 // Установка интервала в один месяц
        
        let query = HKStatisticsCollectionQuery(quantityType: flightsCount,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfMonth,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion([], error)
                return
            }
            
            results?.enumerateStatistics(from: startOfMonth, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let flights = quantity.doubleValue(for: HKUnit.count())
                    monthlyFlights.append(flights)
                } else {
                    monthlyFlights.append(0)
                }
            }
            
            completion(monthlyFlights, nil)
        }
        
        healthStore.execute(query)
    }
    
    func getFloors(completion: @escaping ([Double], Error?) -> ()) {
        var dailyFlights: [Double] = []

        let calendar = Calendar.current
        let now = Date()
        let desiredStartDate = calendar.date(byAdding: .day, value: -7, to: now)
        let startOfDay = Calendar.current.startOfDay(for: desiredStartDate ?? now)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: flightsCount,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)

        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion([], error)
                return
            }

            results?.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let flights = quantity.doubleValue(for: HKUnit.count())
                    dailyFlights.append(flights)
                } else {
                    dailyFlights.append(0)
                }
            }

            completion(dailyFlights, nil)

        }

        HKHealthStore().execute(query)
    }
}
