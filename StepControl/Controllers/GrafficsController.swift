import UIKit

class GrafficsController: UIViewController {
    
    private let screen = UIScreen.main.bounds.height
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
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
    
    private let monthlyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Perfomance"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.darkBlue
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let dailyGraf = DailyStepsView(cornerRadius: 10)
    private let monthlyGraf = MonthlyGraf(cornerRadius: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.inactive
        view.addSubview(scrollView)
        
        middleView.addSubview(dailyGraf)
        middleView.addSubview(titleLabel)
        middleView.addSubview(dailyTitleLabel)
        middleView.addSubview(monthlyTitleLabel)
        middleView.addSubview(monthlyGraf)
        dailyGrafApperance()
        monthlyGrafApperance()
        
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        constraints()
        
        print("screen = \(monthlyGraf.bounds.height)")
    }
    
    func monthlyGrafApperance() {
        AllStepsCount.shared.getSteps { [weak self] steps in
            DispatchQueue.main.async {
                
                var monthlyGrafData: [ChartsView.Data] = []
                var stepsArray = steps[1]
                var dateArray = steps[0]
                
                dateArray.reverse()
                stepsArray.reverse()
                
                for i in stride(from: steps[1].count - 1, through: 0, by: -1) {
                    print(Int(Int(stepsArray[i])! / 1000))
                    monthlyGrafData.append(.init(value: (Int(Int(stepsArray[i])! / 1000)) / 2, title: dateArray[i]))
                 }

                
                self!.monthlyGraf.configurate(with: monthlyGrafData,topChartsOffset: 10)
//                self!.monthlyGraf.configurate(with: [.init(value: "25", title: "jan"),
//                                                     .init(value: "50", title: "feb"),
//                                                     .init(value: "25", title: "mar"),
//                                                     .init(value: "100", title: "apr"),
//                                                     .init(value: "25", title: "may"),
//                                                     .init(value: "50", title: "jun"),])
                
            }
        }
    }
    
    func dailyGrafApperance() {
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                
                print("DailySteps = \(steps)")
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
                var stepsString = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                let stepsMultiplier = stepsArray.map{$0 / 10000}
                stepsString = stepsArray.map{round(($0 / 1000) * 10)/10}
                
                var grafData: [BarView.Data] = []
                
                if stepsArray.count < 7 {
                    for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                        grafData.append(.init(value: "\(stepsString[i])k", heightMultiplier: Double(stepsMultiplier[i]), title: dateArray[i]))
                    }
                } else {
                    for i in stride(from: stepsArray.count-2, through: 0, by: -1) {
                        grafData.append(.init(value: "\(stepsString[i])k", heightMultiplier: Double(stepsMultiplier[i]), title: dateArray[i]))
                    }
                }
                
                self!.dailyGraf.configurate(with: grafData)
            }
        }
    }
    
    func constraints() {
        
        dailyGraf.translatesAutoresizingMaskIntoConstraints = false
        monthlyGraf.translatesAutoresizingMaskIntoConstraints = false
        
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
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height + 88),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            
            dailyTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            dailyTitleLabel.leadingAnchor.constraint(equalTo: dailyGraf.leadingAnchor),
            
            dailyGraf.topAnchor.constraint(equalTo: dailyTitleLabel.bottomAnchor, constant: 8),
            dailyGraf.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            dailyGraf.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            dailyGraf.heightAnchor.constraint(equalToConstant: 250),
            
            monthlyTitleLabel.topAnchor.constraint(equalTo: dailyGraf.bottomAnchor, constant: 32),
            monthlyTitleLabel.leadingAnchor.constraint(equalTo: monthlyGraf.leadingAnchor),
            
            monthlyGraf.topAnchor.constraint(equalTo: monthlyTitleLabel.bottomAnchor, constant: 8),
            monthlyGraf.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            monthlyGraf.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            monthlyGraf.heightAnchor.constraint(equalToConstant: 280),
        
        ])
    }
    
}
