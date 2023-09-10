//
//  ViewController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 30.08.2023.
//

import UIKit
import UserNotifications

class StepsController: UIViewController, UIScrollViewDelegate {
    
    let notificationsCenter = AppDelegate()
    
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
    
    private let histogramView = DailyStepsView()
    
    var target = Int(UserSettings.target ?? "10000")
    var steps = 0
    
    private let stepsCount = Steps()
    
    private let weekView = WeekView()
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
        label.text = "9345"
        return label
    }()
    
    private let stepsTargetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 24)
        label.textColor = R.Colors.blue
        label.text = "/\(UserSettings.target ?? "10000")"
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
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Steps"
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        middleView.addSubview(progressView)
        middleView.addSubview(stepsImageView)
        middleView.addSubview(stepsLabel)
        middleView.addSubview(stepsTargetLabel)
        middleView.addSubview(bottomStackView)
        middleView.addSubview(histogramView)
        middleView.addSubview(stepsButton)
        middleView.addSubview(grafButton)
        
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self
        
        weekDaysApperance()
        print("Target = \(target)")
//        UserSettings.target = "\(self.target)"
//        print(UserSettings.target)

        middleView.addSubview(weekView)
        
        
        self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
        
        stepsCount.getAuthorization()
        getSteps()
        
        caloriesCountView.configure(with: "calories".uppercased(),
                                               andValue: "345 kcal")
        distantCountView.configure(with: "distant".uppercased(),
                                              andValue: "12 km")
        [
            caloriesCountView,
            bottomSeparatorView,
            distantCountView
        ].forEach(bottomStackView.addArrangedSubview)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trophy"), style: .plain, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(rightButtonAction))
        
        
        stepsButton.addTarget(self, action: #selector(stepsButtonAction), for: .touchUpInside)
        grafButton.addTarget(self, action: #selector(grafButtonAction), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = R.Colors.inactive
        
        constraints()
        themeChange()
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
//        vc.modalPresentationStyle = .pageSheet
//        vc.modalTransitionStyle = .partialCurl
        present(vc, animated: true)
    }
    
    @objc
    func leftButtonAction() {
        print("leftButtonTapped")
        let vc = AchievementController()
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .coverVertical
       navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
    }
    
    @objc
    func rightButtonAction() {
        print("rightButtonTapped")
        let vc = SettingsController { [self] target in
            self.target = Int(UserSettings.target ?? "10000")!
            UserSettings.target = "\(target)"
            self.stepsTargetLabel.text = "/\(UserSettings.target!)"
            //UserSettings.target = target
            //self.target = Int(target) ?? 0
            self.configurate(with: Double(self.target ?? 10000), progress: Double(steps))
        }
        
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .coverVertical
        
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
    
    func getSteps() {
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                print("GETSTEPS \(steps)")
                var stepsString = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                let stepsMultiplier = steps.map{$0 / 10000}
                stepsString = steps.map {$0/1000}
                
                var grafData: [BarView.Data] = []
                
                if steps.count == 7 {
                    for i in stride(from: steps.count-2, through: 0, by: -1) {
                        //print("weekDays = \(self!.weekDays)")
                        grafData.append(.init(value: "\(Int(stepsString[i+1]))k", heightMultiplier: stepsMultiplier[i+1], title: self!.weekDays[i]))
                    }
                } else {
                    for i in stride(from: steps.count-3, through: 0, by: -1) {
                        //print("weekDays = \(self!.weekDays)")
                        grafData.append(.init(value: "\(Int(stepsString[i+1]))k", heightMultiplier: stepsMultiplier[i+1], title: self!.weekDays[i]))
                    }
                }
                
                self!.histogramView.configurate(with: grafData)
                
                self!.steps = Int(steps[0])
                self!.dailySteps = steps
                self!.stepsLabel.text = "\(Int(steps[0]))"
                let distant = (0.7 * steps[0])/1000
                let calories = steps[0]/20
                self!.distantCountView.configure(with: "distant".uppercased(), andValue: "\(Int(distant)) km")
                self!.caloriesCountView.configure(with: "calories".uppercased(),
                                                  andValue: "\(Int(calories)) kcal")
                self!.configurate(with: Double(self!.target ?? 10000), progress: steps[0])
                
                self!.notificationsCenter.center.removePendingNotificationRequests(withIdentifiers: ["targetNotification"])
                
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
        histogramView.translatesAutoresizingMaskIntoConstraints = false
        
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
            contentView.heightAnchor.constraint(equalToConstant: 832),//1128
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            grafButton.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 8),
            grafButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            grafButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            grafButton.heightAnchor.constraint(equalToConstant: 200),
            
            histogramView.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 8),
            histogramView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            histogramView.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            histogramView.heightAnchor.constraint(equalToConstant: 200),
            
            stepsButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            stepsButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            stepsButton.widthAnchor.constraint(equalTo: progressView.widthAnchor),
            stepsButton.heightAnchor.constraint(equalTo: progressView.heightAnchor),
            
            progressView.topAnchor.constraint(equalTo: middleView.safeAreaLayoutGuide.topAnchor, constant: 32),
            progressView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 55),
            progressView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -55),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 56),
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
            weekView.heightAnchor.constraint(equalToConstant: 47)

        ])
    }
}

extension StepsController {
    func themeChange() {
        if traitCollection.userInterfaceStyle == .light {
            stepsLabel.textColor = R.Colors.darkBlue
            stepsImageView.tintColor = R.Colors.darkBlue
            navigationItem.leftBarButtonItem?.tintColor = R.Colors.darkBlue
            navigationItem.rightBarButtonItem?.tintColor = R.Colors.darkBlue
            if let navigationBar = self.navigationController?.navigationBar {
                // Изменение цвета заголовка
                let attributes = [NSAttributedString.Key.foregroundColor: R.Colors.darkBlue] // Здесь вы можете указать требуемый цвет
                navigationBar.titleTextAttributes = attributes
                view.backgroundColor = R.Colors.inactive
                backgroundImage.image = nil
            } else {
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
            }
        }
    }
}