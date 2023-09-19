//
//  AllStepsCount.swift
//  StepControl
//
//  Created by Мурат Кудухов on 11.09.2023.
//

import UIKit
import HealthKit

class AllStepsCount: UIViewController {
    
    static let shared = AllStepsCount()
    
    let healthStore = HKHealthStore()
    let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var stepsAmount = ""
    
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
    
//    func getSteps(completion: @escaping ([[String]]) -> ()) {
//
//            guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
//                fatalError("Тип данных о шагах недоступен")
//            }
//
//            let calendar = Calendar.current
//            let now = Date()
//            let startOfYear = calendar.date(from: Calendar.current.dateComponents([.year], from: now))!
//            print("Start of Year = \(startOfYear)")
//
//            let predicate = HKQuery.predicateForSamples(withStart: startOfYear, end: now, options: .strictStartDate)
//
//            // Создайте запрос на данные о шагах
//            let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
//                                                    quantitySamplePredicate: predicate,
//                                                    options: .cumulativeSum,
//                                                    anchorDate: startOfYear,
//                                                    intervalComponents: DateComponents(month: 1)) // Изменил интервал на ежемесячный
//
//            // Получите результаты запроса
//            query.initialResultsHandler = { _, results, error in
//                guard let result = results else {
//                    print("Не удалось получить данные о шагах: \(error?.localizedDescription ?? "Неизвестная ошибка")")
//                    return
//                }
//
//                var stepsArray: [String] = []
//                var dateArray: [String] = []
//
//                result.enumerateStatistics(from: startOfYear, to: now) { statistics, _ in
//                    if let quantity = statistics.sumQuantity() {
//                        let steps = Int(quantity.doubleValue(for: .count()))
//                        let date = statistics.startDate
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "MMM"
//
//                        // Делайте что-то с полученными данными, например, сохраните в массив или отобразите на экране
//                        print("Месяц: \(dateFormatter.string(from: date)), Шаги: \(steps)")
//                        dateArray.append(dateFormatter.string(from: date))
//                        stepsArray.append(String(steps))
//                    }
//                }
//                completion([dateArray, stepsArray])
//            }
//
//            healthStore.execute(query)
//        }
    
    func getSteps(completion: @escaping ([[String]]) -> ()) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Тип данных о шагах недоступен")
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        print("Start of Year = \(startOfYear)")
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfYear, end: now, options: .strictStartDate)
        
        // Создайте запрос на данные о шагах
        let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startOfYear,
                                                intervalComponents: DateComponents(month: 1)) // Изменил интервал на ежемесячный
        
        // Получите результаты запроса
        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                print("Не удалось получить данные о шагах: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            
            var stepsArray: [String] = []
            var dateArray: [String] = []
            
            result.enumerateStatistics(from: startOfYear, to: now) { statistics, _ in
                let date = statistics.startDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: .count()))
                    
                    // Делайте что-то с полученными данными, например, сохраните в массив или отобразите на экране
                    print("Месяц: \(dateFormatter.string(from: date)), Шаги: \(steps)")
                    dateArray.append(dateFormatter.string(from: date))
                    stepsArray.append(String(steps))
                } else {
                    // Если шаги не найдены, добавьте 0 в массив шагов
                    print("Месяц: \(dateFormatter.string(from: date)), Шаги: 0")
                    dateArray.append(dateFormatter.string(from: date))
                    stepsArray.append("0")
                }
            }
            completion([dateArray, stepsArray])
        }
        
        healthStore.execute(query)
    }


    
}
