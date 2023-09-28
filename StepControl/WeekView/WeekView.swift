//
//  WeekView.swift
//  WorkoutApp
//
//  Created by Viktor Prikolota on 28.05.2022.
//

import UIKit

final class WeekView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(stackView)
        constraints()
        settings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func settings() {
        var weekdays:[[Substring]] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE,d"

        
        for i in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let formattedDate = dateFormatter.string(from: date)
                let DayAndDate = formattedDate.split(separator: ",")
                weekdays.append(DayAndDate)
            }
        }
        
        weekdays.reverse()
        
        for i in 0...6 {
            let dayNum = (String(weekdays[i][1]))
            let dayName = (String(weekdays[i][0]))
            //let view = WeekdayView()
            //view.configure(with: dayNum, and: dayName, index: i)
            //stackView.addArrangedSubview(view)
        }
    }
}

