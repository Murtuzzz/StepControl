//
//  WeekdayView.swift
//  WorkoutApp
//
//  Created by Viktor Prikolota on 28.05.2022.
//

import UIKit

extension WeekCell {
    final class WeekdayView: UIView {
        
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
            layer.cornerRadius = 10
            layer.masksToBounds = true
            addSubview(stackView)
            
            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(dateLabel)
            
            
            constraints()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func constraints() {
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
            ])
        }
        
        func configure(with dayNum: String, and name: String, index: Int) {
            let startOfWeek = Date().startOfWeek
            _ = startOfWeek.agoForward(to: 7)
            let day = Date.calendar.component(.day, from: Date())
            let dateFormatter = DateFormatter()
            let isToday = String(day) == dayNum
            
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
                        
                        if dateArray.contains(dayNum) {
                            if index < stepsArray.count-1 {
                                if stepsDict[dayNum]! >= Double(UserSettings.target ?? "10000") ?? 99999 {
                                    self!.backgroundColor = .systemTeal
                                } else {

                                }
                            }
                        }
                    }
                }
            }
            
            backgroundColor = isToday ? R.Colors.orangeTwo : R.Colors.darkBlue
            
            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : R.Colors.inactive
            
            dateLabel.text = dayNum
            dateLabel.textColor = isToday ? .white : R.Colors.inactive
        }
    }
}


