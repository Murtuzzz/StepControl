//
//  DailyHourSteps.swift
//  StepControl
//
//  Created by Мурат Кудухов on 24.09.2023.
//

import UIKit
import HealthKit


final class DailyHourSteps: UIViewController {
    
    static let shared = DailyHourSteps()
    
    let healthStore = HKHealthStore()
    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var stepsArray : [[Double]] = []
    
    func getAuthorization() {
        let readTypes: Set<HKObjectType> = [stepsCount]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.getSteps(completion: { steps in
                    print("Steps: \(steps)")
                })
            }
        }
    }
    
    
    
    func getSteps(completion: @escaping ([String: [Double]]) -> ()) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Тип данных о шагах недоступен")
        }
        
        let calendar = Calendar.current
        let now = Date()
        let endDate = calendar.startOfDay(for: now)
        let startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startDate,
                                                intervalComponents: DateComponents(hour: 1))
        
        var stepsPerHourPerDay: [String: [Double]] = [:]
        
        query.initialResultsHandler = { query, results, error in
            guard let result = results else {
                print("Не удалось получить данные о шагах: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            
            result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let date = calendar.startOfDay(for: statistics.startDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d"
                let dateKey = dateFormatter.string(from: date)
                
                let hour = calendar.component(.hour, from: statistics.startDate)
                
                var stepsPerHour: [Double] = stepsPerHourPerDay[dateKey] ?? Array(repeating: 0, count: 24)
                
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: .count()))
                    stepsPerHour[hour] = Double(steps)
                    self.stepsArray.append(stepsPerHour)
//                    self.stepsArray.append(stepsPerHour)
//                    print(stepsPerHour)
                }
                
                stepsPerHourPerDay[dateKey] = stepsPerHour
            }
           
            completion(stepsPerHourPerDay)
            //print(self.stepsArray)
        }
        
        healthStore.execute(query)
    }
}
