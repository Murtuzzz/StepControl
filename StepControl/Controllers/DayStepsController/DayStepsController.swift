//
//  DailyStepsController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 13.10.2023.
//

import UIKit
import SwiftUI

class DayStepsController: UIViewController {
    
    private let screen = UIScreen.main.bounds.height
    
    private var todaySteps: [Double] = []
    
    private var cellIndex = 6 {
        didSet {
            dailyGrafApperance(cellIndex: cellIndex)
        }
    }
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.gray
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let dailyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Perfomance"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.darkBlue
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let bigCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(container)
        view.addSubview(bigCloseButton)
        container.addSubview(titleLabel)
        container.addSubview(dailyTitleLabel)
        
        bigCloseButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        dailyGrafApperance(cellIndex: 6)
        
//        dailyGrafApperance(cellIndex: self.cellIndex)
        getHourlySteps()
        
        constraints()
        statsApperance()
        
    }
    
    init(cellIndex: Int, dateName: [String], dateNum: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.cellIndex = cellIndex
        if cellIndex != 6 {
            self.titleLabel.text = "\(dateName[cellIndex]), \(dateNum[cellIndex])"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func closeButtonAction() {
        dismiss(animated: true)
    }
    
    func dailyGrafApperance(cellIndex: Int) {
        DailyHourSteps.shared.getSteps { [weak self] stepsPerHourPerDay in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                let dateArray = self.getLastWeekdays()
                let dayNumArray = dateArray[0]
                //let dayNameArray = dateArray[1]
                
                var ruHourArray: [String] = []
                var usHourArray: [String] = []
                
                for i in 0...23 {
                    ruHourArray.append("\(i)")
                }
                
                //let dict = ["12 AM":0, "1 AM":1, "2 AM":2, "3 AM":3, "4 AM":4, "5 AM":5, "6 AM":6, "7 AM":7, "8 AM":8, "9 AM":9, "10 AM":10, "11 AM":11, "12 PM":12, "1 PM":13, "2 PM":14, "3 PM":15, "4 PM":16, "5 PM":17, "6 PM":18, "7 PM":19, "8 PM":20, "9 PM":21, "10 PM":22, "11 PM":23]
                
                usHourArray.append("12 am")
                for i in 1...11 {
                    usHourArray.append("\(i) am")
                }
                usHourArray.append("12 pm")
                for i in 1...11 {
                    usHourArray.append("\(i) pm")
                }
                
                var stepsHourly: [[Double]] = []
                
                for i in 0...6 {
                    stepsHourly.append(stepsPerHourPerDay[dayNumArray[i]]!)
                }
                
                stepsHourly.removeLast()
                stepsHourly.append(self.todaySteps)
               
                var array: [DayData] = []
                
                let date = Date()
                let formatter = DateFormatter()

                formatter.timeStyle = .short

                let currentTime = formatter.string(from: date)
                let timeList = currentTime.split(separator: ":")
                let hour = Int(timeList[0])!
                
                //0-8 9 10 11 12 13 14 15 16 17 18 19 20-23
                
                print("hour = \(hour)")
                let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
                print("date format = \(dateFormat ?? "Unknown")")
                
                //stepsApperance
                if dateFormat == "h a" {
                    for i in 0...23 {
                        array.append(.init(type: usHourArray[i], count: Int(stepsHourly[self.cellIndex][i])))
                    }
                } else {
                    for i in 0...23 {
                        array.append(.init(type: ruHourArray[i], count: Int(stepsHourly[self.cellIndex][i])))
                    }
                }
                
                let dayChart = UIHostingController(rootView: DayStepsHystogram(array: array))
                self.addChild(dayChart)
                dayChart.view.backgroundColor = .black
                
                dayChart.view.translatesAutoresizingMaskIntoConstraints = false
                dayChart.view.layer.cornerRadius = 15
                dayChart.view.backgroundColor = R.Colors.darkGray
                self.view.addSubview(dayChart.view)
                
                NSLayoutConstraint.activate([
                    dayChart.view.topAnchor.constraint(equalTo: self.dailyTitleLabel.bottomAnchor, constant: 8),
                    dayChart.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    dayChart.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                    dayChart.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                    dayChart.view.heightAnchor.constraint(equalToConstant: 208),
                ])
            }
        }
    }
    
    func getHourlySteps() {
        HourlyStepsCount.shared.getSteps { [weak self] steps  in
            DispatchQueue.main.sync {
                
                var dateArray: [String] = []
                
                for i in 0...23 {
                    dateArray.append("\(i):00")
                }
                
                for i in 0...23 {
                    if steps[dateArray[i]] == 0 {
                        self!.todaySteps.append(0)
                    } else {
                        self!.todaySteps.append(Double(steps[dateArray[i]]!))
                    }
                }
            }
        }
    }

    
    func statsApperance() {
        FloorsCount.shared.getFloors { [weak self] floors,err  in
            DispatchQueue.main.sync {
                guard let self = self else {return}
                
                let floorsView = StatsView(icon: "figure.stairs", title: "Floors",value: Int(floors[self.cellIndex+1])) //Int(floors[self.cellIndex])
                
                floorsView.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(floorsView)
                
                NSLayoutConstraint.activate([
                    floorsView.topAnchor.constraint(equalTo: self.dailyTitleLabel.bottomAnchor, constant: 240),
                    floorsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                    floorsView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                    floorsView.heightAnchor.constraint(equalToConstant: 100),
                    
                ])
            }
        }
            
        
    }
    
    func constraints() {
        
        if view.bounds.height == 667 {
            container.removeConstraint(container.heightAnchor.constraint(equalToConstant: view.bounds.height/2 + 120))
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: view.bounds.height/2 + 176)
            ])
        } else {
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: view.bounds.height/2 + 120)
            ])
        }
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            
            dailyTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            dailyTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bigCloseButton.topAnchor.constraint(equalTo: view.topAnchor),
            bigCloseButton.bottomAnchor.constraint(equalTo: container.topAnchor),
            bigCloseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigCloseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
}

extension DayStepsController {
    func getLastWeekdays() -> [[String]] {
        var dateArray: [[Substring]] = []
        var dayNumArray: [String] = []
        var dayNameArray: [String] = []
        var dayAndDateArray: [[String]] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE,d"
        
        for i in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let formattedDate = dateFormatter.string(from: date)
                let dayAndDate = formattedDate.split(separator: ",")
                dateArray.append(dayAndDate)
            }
        }
        dateArray.reverse()
        
        for i in 0...6 {
            let dayNum = (String(dateArray[i][1]))
            dayNumArray.append(dayNum)
            let dayName = (String(dateArray[i][0]))
            dayNameArray.append(dayName)
        }
        
        dayAndDateArray.append(dayNumArray)
        dayAndDateArray.append(dayNameArray)
        
        return dayAndDateArray
    }
    
    
    
}

