//
//  ViewController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 30.08.2023.
//

import UIKit
import UserNotifications

class StepsController: UIViewController, UIScrollViewDelegate, MyViewDelegate {
    
    static var shared = StepsController()
    
    var index = 0 {
        didSet {
            setHourlySteps(arrayInd: index)
            print(index)
        }
    }
    
    private var theme = ["dark","light","system"]
    
    var ind2 = 0
    
    private var todaySteps: [Double] = []
    
    private var histogramView: HourlyStepsCollection? = nil
    
    private let notificationsCenter = AppDelegate()
    
    private let hourlySteps = HourlyStepsCount()
    
    private var grafData: [BarData] = []
    
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
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var dateComponents = DateComponents()
    
    private var dailySteps: [Double] = []
    
    private var weekDays: [String] = []
    
    //private let histogramView = DailyStepsView(cornerRadius: 20)
    
    //private let histogramView = DailyStepsView(cornerRadius: 10)
    
    var target = Int(UserSettings.target ?? "10000")
    var steps = 0
    
    private let stepsCount = Steps()
    
    //private let weekView = WeekView()
    
    private let weekView = WeekCollection()
    
    private let progressView = ProgressView()
    
    private let bottomStackView: UIStackView = {
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
        view.backgroundColor = R.Colors.blue
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
        label.textColor = R.Colors.blue
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
        button.backgroundColor = R.Colors.darkBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        themeChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Steps"
        print("1999 index \(index)")
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        middleView.addSubview(progressView)
        middleView.addSubview(stepsImageView)
        middleView.addSubview(stepsLabel)
        middleView.addSubview(stepsTargetLabel)
        middleView.addSubview(bottomStackView)
        //middleView.addSubview(histogramView)
        middleView.addSubview(stepsButton)
        middleView.addSubview(grafButton)
        
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self
        
        weekDaysApperance()
        middleView.addSubview(weekView)
        
        
        self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
        
        stepsCount.getAuthorization()
        getHourlySteps()
        getSteps()
        
        caloriesCountView.configure(with: "calories".uppercased(),
                                    andValue: "000 kcal")
        distantCountView.configure(with: "distant".uppercased(),
                                   andValue: "0 km")
        [
            caloriesCountView,
            bottomSeparatorView,
            distantCountView
        ].forEach(bottomStackView.addArrangedSubview)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trophy"), style: .plain, target: self, action: #selector(rightButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.bar"), style: .plain, target: self, action: #selector(leftButtonAction))
        
        
        stepsButton.addTarget(self, action: #selector(stepsButtonAction), for: .touchUpInside)
        grafButton.addTarget(self, action: #selector(grafButtonAction), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = R.Colors.inactive
        
        constraints()
        themeChange()
        weekView.delegate = self
    }
    
    func didUpdateData(_ data: Int) {
        index = data
        
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
        let vc = GrafficsController()
        present(vc, animated: true)
    }
    
    @objc
    func rightButtonAction() {
        print("leftButtonTapped")
        let vc = AchievementController()
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
    }
    
    func test(index: Int) {
        setHourlySteps(arrayInd: index)
    }
    
    @objc
    func leftButtonAction() {
        print("rightButtonTapped")
//        let vc = SettingsController { [self] target in
//            self.target = Int(UserSettings.target ?? "10000")!
//            UserSettings.target = "\(target)"
//            self.stepsTargetLabel.text = "/\(UserSettings.target!)"
//            //UserSettings.target = target
//            //self.target = Int(target) ?? 0
//            self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
//        }
        let vc = GrafficsController()
        present(vc, animated: true)
    }
    
    func weekDaysApperance() {
        dateComponents.day = -1
        for _ in 0...6 {
            if let date = calendar.date(byAdding: dateComponents, to: Date()) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                let formattedDate = dateFormatter.string(from: date)
                weekDays.append(formattedDate)
                
                dateComponents.day! -= 1
            }
        }
    }
    
    func getHourlySteps() {
        HourlyStepsCount.shared.getSteps { [weak self] steps  in
            DispatchQueue.main.sync {
               
                self!.grafData = []
                
                var dateArray: [String] = []
                
                for i in 0...24 {
                    dateArray.append("\(i):00")
                }
                
                for i in 0...23 {
                    self!.grafData.append(.init(heightMultiplier: Double(steps[dateArray[i]]!)/890, value: "\(steps[dateArray[i]] ?? 00)", title: "\(dateArray[i])"))
                    
                    print("Get - \(Double(steps[dateArray[i]]!)/890)")
                    
                    if steps[dateArray[i]] == 0 {
                        self!.todaySteps.append(0)
                    } else {
                        self!.todaySteps.append(Double(steps[dateArray[i]]!))
                    }
                }
                
                print("today steps = \(self!.todaySteps)")
                
                self!.histogramView = HourlyStepsCollection(data: self!.grafData)
                
                
                //histogramView.configurate(with: grafData)
                self!.histogramView!.translatesAutoresizingMaskIntoConstraints = false
                self!.middleView.addSubview(self!.histogramView!)
                
                NSLayoutConstraint.activate([
                    self!.histogramView!.topAnchor.constraint(equalTo: self!.weekView.bottomAnchor, constant: 8),
                    self!.histogramView!.centerXAnchor.constraint(equalTo: self!.middleView.centerXAnchor),
                    self!.histogramView!.widthAnchor.constraint(equalToConstant: self!.view.bounds.width - 48),
                    self!.histogramView!.heightAnchor.constraint(equalToConstant: self!.view.bounds.height / 4),
                ])
            }
        }
    }
    
    func setHourlySteps(arrayInd: Int) {
        DailyHourSteps.shared.getSteps { [weak self] stepsPerHourPerDay in
            DispatchQueue.main.async {
                
                
                print("daily steps Array = \(self!.todaySteps)")
                
                guard let self = self else {return}
                print("arrayInd = \(arrayInd)")
                
                let stepsHourly = stepsPerHourPerDay.sorted { $0.key < $1.key }
                var weekStepsArray: [[Double]] = []
                
                for (_, stepsPerHour) in stepsHourly {
                    var stepsArray: [Double] = []
                    for hour in 0..<24 {
                        let hourSteps = stepsPerHour[hour]
                        stepsArray.append(Double(hourSteps))
                    }
                    weekStepsArray.append(stepsArray)
                }
                
                weekStepsArray.removeLast()
                weekStepsArray.append(self.todaySteps)
                
                print(weekStepsArray)
                let steps = weekStepsArray[arrayInd+1]
                print(steps)
                //print("CurrentSteps - \(steps)")
                
                self.grafData.removeAll()
               
                self.grafData = []
                var dateArray: [String] = []
                
                for i in 0...24 {
                    dateArray.append("\(i):00")
                }
                
                for i in 0...23 {
                    self.grafData.append(.init(heightMultiplier: Double(steps[i]/890), value: "\(Int(steps[i]))", title: "\(dateArray[i])"))
                    
                    print("Set - \(Double(steps[i]/890))")
                }
                
                //print("------GRAPH \(self!.grafData)")
                
                self.histogramView?.removeFromSuperview()
                let histogramView = HourlyStepsCollection(data: self.grafData)
                histogramView.updateCollection()
                
                //histogramView.configurate(with: grafData)
                histogramView.translatesAutoresizingMaskIntoConstraints = false
                self.middleView.addSubview(histogramView)
                
                NSLayoutConstraint.activate([
                    histogramView.topAnchor.constraint(equalTo: self.weekView.bottomAnchor, constant: 8),
                    histogramView.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
                    histogramView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 48),
                    histogramView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 4),
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
                dateArray.reverse()
                
                print("GETSTEPS \(stepsArray) GETDATA \(dateArray)")
                //var stepsString = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                //let stepsMultiplier = stepsArray.map{$0 / 10000}
                //stepsString = stepsArray.map {$0/1000}
                
                //                var grafData: [BarView.Data] = []
                //
                //
                //                for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                //                    grafData.append(.init(value: "\(Int(stepsString[i]))k", heightMultiplier: stepsMultiplier[i], title: dateArray[i]))
                //                }
                //
                //
                //                self!.histogramView.configurate(with: grafData)
                
                if stepsArray.count > 0 {
                    
                    self!.steps = Int(stepsArray[0] )
                    print(self!.steps)
                    self!.dailySteps = stepsArray
                    self!.stepsLabel.text = "\(Int(stepsArray[0]))"
                    let distant = (0.7 * stepsArray[0])/1000
                    let calories = stepsArray[0]/20
                    self!.distantCountView.configure(with: "distant".uppercased(), andValue: "\(Int(distant)) km")
                    self!.caloriesCountView.configure(with: "calories".uppercased(),
                                                      andValue: "\(Int(calories)) kcal")
                    self!.configurate(with: Double(self!.target ?? 10000), progress: stepsArray[0])
                    
                }
                if self!.target ?? 10000 > self!.steps {
                    
                    self!.notificationsCenter.createNotification(title: "Поднажмите", body: "Шагов до цели: \((self!.target ?? 10000) - self!.steps)")
                }
                
                //if UserSettings.notifications == true {
                //                } else {
                //                    self!.notificationsCenter.center.removeAllPendingNotificationRequests()
                //                }
            }
        }
    }
    
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
        // histogramView.translatesAutoresizingMaskIntoConstraints = false
        
        print("Height - \(view.bounds.height)")
        
        if view.bounds.height == 667 {
            
            bottomStackView.removeConstraint(bottomStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: view.bounds.height/15))
            progressView.removeConstraint(progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 26))
            
            NSLayoutConstraint.activate([
                bottomStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
                progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: 8)
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
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            grafButton.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 8),
            grafButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            grafButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            grafButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            
            //            histogramView.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 8),
            //            histogramView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            //            histogramView.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            //            histogramView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            
            stepsButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            stepsButton.widthAnchor.constraint(equalTo: progressView.widthAnchor),
            stepsButton.heightAnchor.constraint(equalTo: progressView.heightAnchor),
            
            progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 26),
            progressView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 55),
            progressView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -55),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: view.bounds.height/15),
            bottomStackView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 35),
            bottomStackView.widthAnchor.constraint(equalToConstant: 208),
            
            bottomSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            
            stepsImageView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -56),
            stepsImageView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsImageView.heightAnchor.constraint(equalToConstant: 48),
            stepsImageView.widthAnchor.constraint(equalTo: stepsImageView.heightAnchor),
            
            stepsLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsLabel.topAnchor.constraint(equalTo: stepsImageView.bottomAnchor, constant: 8),
            
            stepsTargetLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsTargetLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: -8),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            weekView.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 32),
            //calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weekView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            weekView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -24),
            weekView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}

extension StepsController {
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
