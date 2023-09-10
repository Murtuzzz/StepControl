//
//  WeekdayView.swift
//  WorkoutApp
//
//  Created by Viktor Prikolota on 28.05.2022.
//

import UIKit

extension WeekView {
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
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.frame = bounds
//
//            let startColor = UIColor.red.cgColor
//            let endColor = UIColor.blue.cgColor
//            gradientLayer.colors = [startColor, endColor]
//
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//
//            layer.insertSublayer(gradientLayer, at: 0)


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
            //print("Day = \(day)")

            let isToday = String(day) == dayNum
            
            Steps.shared.getSteps { [weak self] steps,error  in
                DispatchQueue.main.async {
                    
                    var stepsArray: [Double] = []
                    
                    for (date, steps) in steps {
                        print("Date: \(date), steps: \(steps)")
                        stepsArray.append(steps)
                        //print("GETSTEPS week")
                        //var stepsArray = steps
                        stepsArray.reverse()
                        
                        if index < stepsArray.count {
                            if stepsArray[index] >= Double(UserSettings.target ?? "10000") ?? 99999 {
                                self!.backgroundColor = .systemTeal
                            } else {
                                
                                //self!.backgroundColor = .systemRed
                            }
                        }
                    }
                }
            }

            backgroundColor = isToday ? R.Colors.blue : R.Colors.darkBlue

            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : R.Colors.inactive

            dateLabel.text = dayNum
            dateLabel.textColor = isToday ? .white : R.Colors.inactive
        }
    }
}


