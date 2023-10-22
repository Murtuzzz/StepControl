//
//  StatisticsController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 09.10.2023.
//

import UIKit
import SwiftUI

class StatisticsController: UIViewController {
    
    private let screen = UIScreen.main.bounds.height
    
    private var monthlyGraf : UIHostingController<MonthlyChart>? = nil
    private var dailyGraf: UIHostingController<DailyHystogram>? = nil
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Week","Year"])
        segment.selectedSegmentIndex = 0
        segment.clipsToBounds = true
        segment.layer.masksToBounds = true
        segment.tintColor = .white
        segment.layer.cornerRadius = 50
        segment.layer.borderColor = R.Colors.darkBlue.cgColor
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = R.Colors.darkBlue
        segment.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(attributes, for: .normal)
        return segment
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.gray
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.inactive
        view.addSubview(scrollView)
        
        //middleView.addSubview(dailyGraf)
        middleView.addSubview(titleLabel)
        middleView.addSubview(segmentedControl)
        // middleView.addSubview(monthlyGraf)
        dailyGrafApperance()
        
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        
        FloorsCount.shared.getAuthorization()
       
        constraints()
        statsViewsApperance()
    }
    
    @objc
    func segmentedControlAction() {
        if segmentedControl.selectedSegmentIndex == 0 {
            dailyGrafApperance()
        } else {
            monthlyGrafApperance()
        }
    }
    
    func getNumberOfDaysInCurrentMonth() -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Определение диапазона дней текущего месяца
        guard let dateInterval = calendar.dateInterval(of: .month, for: currentDate),
              let numberOfDays = calendar.dateComponents([.day], from: dateInterval.start, to: currentDate).day else {
            return nil
        }
        
        return numberOfDays
    }
    
    func statsViewsApperance() {
        AllStepsCount.shared.getSteps { [weak self] steps in
            DispatchQueue.main.sync {
                guard let self = self else {return}
                
                var stepsArray = steps[1]
                stepsArray.reverse()
                
                let numberOfDays = self.getNumberOfDaysInCurrentMonth()
                
                let avgStepsView = AverageStepsView(icon: UIImage.person, title: "Average steps per month", value: Int(stepsArray[0])!/(numberOfDays ?? 0))
                
                print(stepsArray)
                
                self.middleView.addSubview(avgStepsView)
                
                avgStepsView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    avgStepsView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 382),
                    avgStepsView.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                    avgStepsView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                    avgStepsView.heightAnchor.constraint(equalToConstant: 124),
                    
                ])
                
                FloorsCount.shared.getMonthlyFloors { [weak self] steps,err  in
                    DispatchQueue.main.sync {
                        guard let self = self else {return}
                        
                        let floorsView = AverageStepsView(icon: UIImage.stairs, title: "Floors passed in a month", value: Int(steps[5]))
                        
                        self.middleView.addSubview(floorsView)
                        floorsView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            
                            floorsView.topAnchor.constraint(equalTo: avgStepsView.bottomAnchor, constant: 16),
                            floorsView.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                            floorsView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                            floorsView.heightAnchor.constraint(equalToConstant: 124)
                        ])
                    }
                }
            }
        }
    }
    
    func monthlyGrafApperance() {
        AllStepsCount.shared.getSteps { [weak self] steps in
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                var array: [LineData] = []
                var stepsArray = steps[1]
                var dateArray = steps[0]
                
                dateArray.reverse()
                stepsArray.reverse()
                
                for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                    array.append(.init(type: dateArray[i], count: Int(stepsArray[i]) ?? 0))
                }
                
                self.dailyGraf?.view.removeFromSuperview()
                self.monthlyGraf?.view.removeFromSuperview()
                
                self.monthlyGraf = UIHostingController(rootView: MonthlyChart(array: array))
                self.addChild(self.monthlyGraf!)
                self.monthlyGraf!.view.backgroundColor = .black
                
                self.monthlyGraf!.view.translatesAutoresizingMaskIntoConstraints = false
                self.monthlyGraf!.view.layer.cornerRadius = 15
                self.monthlyGraf!.view.backgroundColor = R.Colors.darkGray
                self.middleView.addSubview(self.monthlyGraf!.view)
                
                NSLayoutConstraint.activate([
                    self.monthlyGraf!.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 16),
                    self.monthlyGraf!.view.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                    self.monthlyGraf!.view.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                    self.monthlyGraf!.view.heightAnchor.constraint(equalToConstant: 350),
                ])
                
            }
        }
    }
    
    func dailyGrafApperance() {
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                var stepsArray: [Double] = []
                var dateArray: [String] = []
                var array: [ChartData] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                let sorted_dict = steps.sorted { $0.key < $1.key }
                
                for (date, steps) in sorted_dict {
                    stepsArray.append(steps)
                    dateArray.append(dateFormatter.string(from:date))
                    
                }
                
                stepsArray.reverse()
                dateArray.reverse()
                
                if array.count < 7 {
                    for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                        array.append(.init(type: dateArray[i], count: Int(stepsArray[i])))
                    }
                } else {
                    for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                        array.append(.init(type: dateArray[i], count: Int(stepsArray[i])))
                    }
                }
                
                self.dailyGraf?.view.removeFromSuperview()
                self.monthlyGraf?.view.removeFromSuperview()
                
                self.dailyGraf = UIHostingController(rootView: DailyHystogram(array: array))
                self.addChild(self.dailyGraf!)
                self.dailyGraf!.view.backgroundColor = .black
                
                self.dailyGraf!.view.translatesAutoresizingMaskIntoConstraints = false
                self.dailyGraf!.view.layer.cornerRadius = 15
                self.dailyGraf!.view.backgroundColor = R.Colors.darkGray
                self.middleView.addSubview(self.dailyGraf!.view)
                
                
                NSLayoutConstraint.activate([
                    self.dailyGraf!.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 16),
                    self.dailyGraf!.view.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                    self.dailyGraf!.view.trailingAnchor.constraint(equalTo: self.middleView.trailingAnchor, constant: -24),
                    self.dailyGraf!.view.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor, constant: 24),
                    self.dailyGraf!.view.heightAnchor.constraint(equalToConstant: 350),
                ])
                
                
            }
        }
    }
    
    func constraints() {
        
        if view.bounds.height == 667 {
            contentView.removeConstraint(contentView.heightAnchor.constraint(equalToConstant: view.bounds.height + 1))
            
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: view.bounds.height + 128)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: view.bounds.height + 1)
            ])
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            segmentedControl.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -24),
            segmentedControl.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            
        ])
    }
}

