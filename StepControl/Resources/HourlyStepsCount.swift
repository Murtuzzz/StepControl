//
//  HourlyStepsCount.swift
//  StepControl
//
//  Created by Мурат Кудухов on 18.09.2023.
//


import UIKit
import HealthKit

class HourlyStepsCount: UIViewController {
    
    static let shared = HourlyStepsCount()
    
    let healthStore = HKHealthStore()
    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    func getAuthorization() {
        let readTypes: Set<HKObjectType> = [stepsCount]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.getSteps(completion: { steps in
                    //print("HourlySteps: \(steps)")
                })
            }
        }
    }
    
    func getSteps(completion: @escaping ([String: Int]) -> ()) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Тип данных о шагах недоступен")
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startDate,
                                                intervalComponents: DateComponents(hour: 1))
        
        var stepsPerHour: [String: Int] = [:]
        
        query.initialResultsHandler = { query, results, error in
            guard let result = results else {
                print("Не удалось получить данные о шагах: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            
            result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let hour = calendar.component(.hour, from: statistics.startDate)
                
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: .count()))
                    stepsPerHour["\(hour):00"] = steps
                } else {
                    stepsPerHour["\(hour):00"] = 0
                }
            }
            
            completion(stepsPerHour)
        }
        
        healthStore.execute(query)
    }
}
