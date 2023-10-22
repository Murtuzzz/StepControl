//
//  ViewController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 30.08.2023.
//

import UIKit
import UserNotifications
import SwiftUI

class StepsController: UIViewController, UIScrollViewDelegate, WeekDayDelegate {
    
    
    static var shared = StepsController()
    
    var index = 6 {
        didSet {
            print(index)
            stepsHystogramApperance(cellIndex: index)
        }
    }
    
    func getWeekDay(_ index: Int) {
        self.index = index
    }
    
    private var sumOfStepsToday = 0
    
    private var dataToSend: [[Double]] = []
    
    private var theme = ["dark","light","system"]
    
    private var todaySteps: [Double] = []
    
    private var histogramView: HourlyStepsCollection? = nil
    
    private var segmentedView: SegmentedCollection? = nil
    
    private let notificationsCenter = AppDelegate()
    
    private let hourlySteps = HourlyStepsCount()
    
    private var hourlyChart: UIHostingController<HourlyHystogram>? = nil
    
    private var grafData: [BarData] = []
    
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
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
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var dateComponents = DateComponents()
    
    private var dailySteps: [Double] = []
    
    private var weekDays: [String] = []
    
    var target = Int(UserSettings.target ?? "10000")
    var steps = 0
    
    private let stepsCount = Steps()
    private let floors = FloorsCount()
    
    private let weekView = WeekCollection()
    
    private let progressView = ProgressView()
    
    private let distandAndKcalView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 30
        return view
    }()
    
    private let caloriesCountView = CountView()
    private let distantCountView = CountView()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.orangeTwo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stepsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "steps")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = R.Colors.inactive
        return view
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 48)
        label.textColor = R.Colors.inactive
        label.text = "0000"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let stepsTargetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 24)
        label.textColor = R.Colors.orangeTwo
        label.text = "/\(UserSettings.target ?? "10000")"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"StepsBg")
        return view
    }()
    
    private let stepsButton: UIButton =  {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 140
        return button
    }()
    
    private let grafButton: UIButton =  {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        themeChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Steps"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        middleView.addSubview(progressView)
        middleView.addSubview(stepsImageView)
        middleView.addSubview(stepsLabel)
        middleView.addSubview(stepsTargetLabel)
        middleView.addSubview(distandAndKcalView)
        middleView.addSubview(stepsButton)
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self
        weekView.delegate = self
        
        //weekDaysApperance()
        middleView.addSubview(weekView)
        
        
        
        self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
        
        stepsCount.getAuthorization()
        //floors.getAuthorization()
        
        
        stepsHystogramApperance(cellIndex: 6)
        getHourlySteps()
        getSteps()
        
        streakViewApperance()
        
        caloriesCountView.configure(with: "calories".uppercased(),
                                    andValue: "000 kcal")
        distantCountView.configure(with: "distant".uppercased(),
                                   andValue: "0 km")
        [
            caloriesCountView,
            bottomSeparatorView,
            distantCountView
        ].forEach(distandAndKcalView.addArrangedSubview)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trophy"), style: .plain, target: self, action: #selector(rightButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.bar"), style: .plain, target: self, action: #selector(leftButtonAction))
        
        
        stepsButton.addTarget(self, action: #selector(stepsButtonAction), for: .touchUpInside)
        grafButton.addTarget(self, action: #selector(grafButtonAction), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = R.Colors.inactive
        
        constraints()
        themeChange()
        
        print("Theme = \(traitCollection.userInterfaceStyle)")
        
        //animatedImage()
        view.backgroundColor = R.Colors.darkGray
        
        
    }
    
    func streakViewApperance() {
        
        var result = 0
        var isWorking = true
        let todaySteps = UserSettings.weekSteps ?? [0,0,0,0,0,0,0]
        
        //        let currentTime = formatter.string(from: date)
        //        let timeList = currentTime.split(separator: ":")
        //        let hour = Int(timeList[0])!
        
        if todaySteps.count != 0 {
            if todaySteps[0] == 0 {
                isWorking = true
            }
            
            if Int(todaySteps[0]) == target {
                result += 1
                isWorking = false
            }
            
            if isWorking {
                
                if Int(todaySteps[0]) >= target! {
                    result += 1
                    isWorking = false
                }
                
                if Int(todaySteps[1]) < target! && Int(todaySteps[0]) < target! {
                    result = 0
                }
            }
        }
        
        let streakView = StreakView(value: result)
        
        navigationItem.titleView = UIView()
        navigationItem.titleView?.addSubview(streakView)
        
        
        NSLayoutConstraint.activate([
            streakView.centerXAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerXAnchor)!),
            streakView.centerYAnchor.constraint(equalTo: (self.navigationItem.titleView?.centerYAnchor)!),
            streakView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc
    func stepsButtonAction() {
        print("stepsButtonTapped")
        let vc = SettingsController { [self] target in
            self.stepsTargetLabel.text = "/\(target)"
            self.target = Int(target) ?? 0
            self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
        }
        present(vc, animated: true)
    }
    
    @objc
    func grafButtonAction() {
        print("leftButtonTapped")
        //let vc = GrafficsController()
        let dateArray = self.getLastWeekdays()
        let vc = DayStepsController(cellIndex: self.index, dateName: dateArray[1], dateNum: dateArray[0])
        present(vc, animated: true)
    }
    
    @objc
    func rightButtonAction() {
        print("leftButtonTapped")
        let vc = AchievementController()
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
    }
    
    @objc
    func leftButtonAction() {
        print("rightButtonTapped")
        let vc = StatisticsController()
        present(vc, animated: true)
    }
    
//    func weekDaysApperance() {
//        dateComponents.day = -1
//        for _ in 0...6 {
//            if let date = calendar.date(byAdding: dateComponents, to: Date()) {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd/MM"
//                let formattedDate = dateFormatter.string(from: date)
//                weekDays.append(formattedDate)
//                dateComponents.day! -= 1
//            }
//        }
//        print(weekDays)
//    }
    
    func notifications() {
        print("Notifications = \(UserSettings.notifications!)")
        if self.target ?? 10000 > self.steps {
            
            self.notificationsCenter.createNotification(title: "Поднажмите", body: "Шагов до цели: \((self.target ?? 10000) - self.steps)")
        }
    }
    
    func configurate(with duration: Double, progress: Double) {
        
        let percent = Double(progress)/Double(target ?? 10000)/1.25
        
        progressView.drawProgress(with: CGFloat(percent))
    }
    
    func constraints() {
        weekView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        print("Height - \(view.bounds.height)")
        
        if view.bounds.height == 667 {
            
            distandAndKcalView.removeConstraint(distandAndKcalView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: view.bounds.height/15))
            progressView.removeConstraint(progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 26))
            
            NSLayoutConstraint.activate([
                distandAndKcalView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 32),
                progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: 8)
            ])
        }
        
        //MARK: - Constraints
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
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stepsButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            stepsButton.widthAnchor.constraint(equalTo: progressView.widthAnchor),
            stepsButton.heightAnchor.constraint(equalTo: progressView.heightAnchor),
            
            progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 26),
            progressView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 55),
            progressView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -55),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            
            distandAndKcalView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: view.bounds.height/15),
            distandAndKcalView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            distandAndKcalView.heightAnchor.constraint(equalToConstant: 35),
            distandAndKcalView.widthAnchor.constraint(equalToConstant: 240),
            
            bottomSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            bottomSeparatorView.centerXAnchor.constraint(equalTo: distandAndKcalView.centerXAnchor),
            
            stepsImageView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -56),
            stepsImageView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsImageView.heightAnchor.constraint(equalToConstant: 48),
            stepsImageView.widthAnchor.constraint(equalTo: stepsImageView.heightAnchor),
            
            stepsLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsLabel.topAnchor.constraint(equalTo: stepsImageView.bottomAnchor, constant: 8),
            
            stepsTargetLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsTargetLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: -8),
            
            weekView.topAnchor.constraint(equalTo: distandAndKcalView.bottomAnchor, constant: 32),
            weekView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            weekView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -24),
            weekView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
}


//MARK: - Extension
extension StepsController {
    
    func getHourlySteps() {
        HourlyStepsCount.shared.getSteps { [weak self] steps  in
            DispatchQueue.main.sync {
                
                var dateArray: [String] = []
                
                for i in 0...24 {
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
    
    //MARK: - SwuftUIChart
    func stepsHystogramApperance(cellIndex: Int) {
        DailyHourSteps.shared.getSteps { [weak self] stepsPerHourPerDay in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                let dateArray = self.getLastWeekdays()
                let dayNumArray = dateArray[0]
                //let dayNameArray = dateArray[1]
                
                var hourArray: [String] = []
                var ruHourArray: [String] = []
                var usHourArray: [String] = []
                
                for i in 0...23 {
                    ruHourArray.append("\(i)")
                }
                
                let currentTimeZone = TimeZone.current
                let tz = TimeZone.abbreviationDictionary
                print("allTZ = \(tz)")
                print("timeZone ID = \(currentTimeZone.identifier)")
                
                let dateFormatter = DateFormatter()
                let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
                print("date format = \(dateFormat ?? "Unknown")")

                if dateFormat == "h a" {
                    print("12")
                    
                } else {
                    print("24")
                    
                }
                
                for i in 0...11 {
                    usHourArray.append("\(i) am")
                }
                
                for i in 0...11 {
                    usHourArray.append("\(i) pm")
                }
                
                print("US hours = \(usHourArray)")
                
                
                var stepsHourly: [[Double]] = []
                
                //print("daily steps Array = \(self!.todaySteps)")
                
                for i in 0...6 {
                    stepsHourly.append(stepsPerHourPerDay[dayNumArray[i]]!)
                }
                
                stepsHourly.removeLast()
                stepsHourly.append(self.todaySteps)
               
                var array: [HourData] = []
                
                var summOfSteps = 0.0
                
                print("StepsHourly = \(stepsHourly[cellIndex])")
                
                for steps in stepsHourly[cellIndex] {
                    summOfSteps += steps
                }
                
                print("summ of steps = \(summOfSteps)")
                
                var distant = (0.7 * Double(summOfSteps))/1000
                var calories = summOfSteps/20
                
                if cellIndex == 6 {
                    self.stepsLabel.text = "\(self.sumOfStepsToday)"
                    distant = (0.7 * Double(self.sumOfStepsToday))/1000
                    calories = Double(self.sumOfStepsToday/20)
                    self.configurate(with: Double(self.target ?? 10000), progress: Double(self.sumOfStepsToday))
                    
                } else {
                    self.stepsLabel.text = "\(Int(summOfSteps))"
                }
                
                self.configurate(with: Double(self.target ?? 10000), progress: Double(summOfSteps))
                self.distantCountView.configure(with: "distant".uppercased(), andValue: "\((round(distant * 100) / 100)) km")
                self.caloriesCountView.configure(with: "calories".uppercased(),
                                                  andValue: "\(Int(calories)) kcal")
                
                let date = Date()
                let formatter = DateFormatter()

                formatter.timeStyle = .short

                let currentTime = formatter.string(from: date)
                let timeList = currentTime.split(separator: ":")
                let hour = Int(timeList[0])!
                
                print("hour = \(hour)")
                
                if dateFormat == "h a" {
                    if hour-8 >= 0 {
                        for i in hour-8...hour {
                            array.append(.init(type:usHourArray[i], count: Int(stepsHourly[cellIndex][i])))
                        }
                    } else {
                        for i in 0...7 {
                            array.append(.init(type: usHourArray[i], count: Int(stepsHourly[cellIndex][i])))
                        }
                    }
                } else {
                    if hour-8 >= 0 {
                        for i in hour-8...hour {
                            array.append(.init(type: ruHourArray[i], count: Int(stepsHourly[cellIndex][i])))
                        }
                    } else {
                        for i in 0...7 {
                            array.append(.init(type: ruHourArray[i], count: Int(stepsHourly[cellIndex][i])))
                        }
                    }
                }
                
                self.hourlyChart?.view.removeFromSuperview()
                self.grafButton.removeFromSuperview()
                self.hourlyChart = UIHostingController(rootView: HourlyHystogram(getArray: array))
                self.addChild(self.hourlyChart!)
                self.hourlyChart!.view.backgroundColor = .black
                
                self.hourlyChart!.view.translatesAutoresizingMaskIntoConstraints = false
                self.hourlyChart!.view.layer.cornerRadius = 15
                self.hourlyChart!.view.backgroundColor = R.Colors.darkGray
                self.middleView.addSubview(self.hourlyChart!.view)
                self.middleView.addSubview(self.grafButton)
                
                NSLayoutConstraint.activate([
                    self.hourlyChart!.view.topAnchor.constraint(equalTo: self.weekView.bottomAnchor, constant: 8),
                    self.hourlyChart!.view.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor, constant: 24),
                    self.hourlyChart!.view.trailingAnchor.constraint(equalTo: self.middleView.trailingAnchor, constant: -24),
                    self.hourlyChart!.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 4),
                    
                    self.grafButton.topAnchor.constraint(equalTo: self.weekView.bottomAnchor, constant: 8),
                    self.grafButton.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                    self.grafButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                    self.grafButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 4),
                ])
            }
        }
    }
    
    func getSteps() {
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                var stepsArray: [Double] = []
                var dateArray: [String] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                let sorted_dict = steps.sorted { $0.key < $1.key }
                
                for (date, steps) in sorted_dict {
                    stepsArray.append(steps)
                    dateArray.append(dateFormatter.string(from:date))
                    
                }
                
                stepsArray.reverse()
                
                UserSettings.weekSteps = stepsArray
                
                dateArray.reverse()
                
                print("GETSTEPS \(stepsArray) GETDATA \(dateArray)")
                
                if stepsArray.count > 0 {
                    self!.steps = Int(stepsArray[0] )
                    print(self!.steps)
                    self!.dailySteps = stepsArray
                    self!.stepsLabel.text = "\(Int(stepsArray[0]))"
                    self!.sumOfStepsToday = Int(stepsArray[0])
                    let distant = (0.7 * stepsArray[0])/1000
                    let calories = Double(self!.sumOfStepsToday/20) //calories = stepsArray[0]/20
                    self!.distantCountView.configure(with: "distant".uppercased(), andValue: "\((round(distant * 100) / 100)) km")
                    self!.caloriesCountView.configure(with: "calories".uppercased(),
                                                      andValue: "\(Int(calories)) kcal")
                    self!.configurate(with: Double(self!.target ?? 10000), progress: stepsArray[0])
                    
                }
                if self!.target ?? 10000 > self!.steps {
                    
                    self!.notificationsCenter.createNotification(title: "Поднажмите", body: "Шагов до цели: \((self!.target ?? 10000) - self!.steps)")
                }
            }
        }
    }
    
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
    
    func themeChange() {
        if theme[UserSettings.themeIndex] == "light" {
            stepsLabel.textColor = R.Colors.darkBlue
            stepsImageView.tintColor = R.Colors.darkBlue
            navigationItem.leftBarButtonItem?.tintColor = R.Colors.darkBlue
            navigationItem.rightBarButtonItem?.tintColor = R.Colors.darkBlue
            navigationController?.navigationBar.tintColor = R.Colors.darkBlue
            if let navigationBar = self.navigationController?.navigationBar {
                // Изменение цвета заголовка
                let attributes = [NSAttributedString.Key.foregroundColor: R.Colors.darkBlue] // Здесь вы можете указать требуемый цвет
                navigationBar.titleTextAttributes = attributes
                view.backgroundColor = R.Colors.inactive
                backgroundImage.image = nil
            } else if theme[UserSettings.themeIndex] == "dark" {
                stepsLabel.textColor = .white
                stepsImageView.tintColor = R.Colors.inactive
                navigationItem.leftBarButtonItem?.tintColor = .white
                navigationItem.rightBarButtonItem?.tintColor = .white
                navigationController?.navigationBar.tintColor = .white
                //view.backgroundColor = .white
                if let navigationBar = self.navigationController?.navigationBar {
                    // Изменение цвета заголовка
                    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Здесь вы можете указать требуемый цвет
                    navigationBar.titleTextAttributes = attributes
                    
                    backgroundImage.image = UIImage(named:"StepsBg")
                }
            } else {
                
            }
        }
    }
}
