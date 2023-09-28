//
//  WeekCell.swift
//  StepControl
//
//  Created by Мурат Кудухов on 21.09.2023.
//

import UIKit

final class WeekCell: UICollectionViewCell {
    
    static let id = "WeekCell"
    
    private var condition = false
    
    private let container: UIView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nameLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 9)
        lable.textAlignment = .center
        return lable
    }()
    
    private let dateLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textAlignment = .center
        return lable
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 3
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        //layer.cornerRadius = 10
        //layer.masksToBounds = true
        addSubview(container)
        addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeCondition() {
        if condition == false {
            container.backgroundColor = R.Colors.blue
            condition = true
        } else {
            container.backgroundColor = R.Colors.darkBlue
            condition = false
        }
    }
    
    public func reset() {
        condition = false
        container.backgroundColor = R.Colors.darkBlue
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    func configure(weekDay: String, date: String, index: Int) {
        let startOfWeek = Date().startOfWeek
        _ = startOfWeek.agoForward(to: 7)
        //let day = Date.calendar.component(.day, from: Date())
        let dateFormatter = DateFormatter()
        let isToday = index == 6
        
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                
                
                //print(steps)
                var stepsArray: [Double] = []
                var dateArray: [String] = []
                let sorted_dict = steps.sorted { $0.key < $1.key }
                var stepsDict: [String:Double] = [:]
                
                for (date, steps) in sorted_dict {
                    dateFormatter.dateFormat = "d"
                    dateFormatter.string(from:date)
                    
                    stepsArray.append(steps)
                    dateArray.append(dateFormatter.string(from:date))
                    stepsDict[(dateFormatter.string(from:date))] = steps
                    //print(stepsDict)
                    
                    if dateArray.contains(weekDay) {
                        if index < stepsArray.count-1 {
                            if stepsDict[weekDay]! >= Double(UserSettings.target ?? "10000") ?? 99999 {
                                self!.backgroundColor = .systemTeal
                            } else {

                            }
                        }
                    }
                }
            }
        }
        
        container.backgroundColor = isToday ? R.Colors.blue : R.Colors.darkBlue
        
        nameLabel.text = weekDay.uppercased()
        nameLabel.textColor = isToday ? .white : R.Colors.inactive
        
        dateLabel.text = date
        dateLabel.textColor = isToday ? .white : R.Colors.inactive
    }
}
