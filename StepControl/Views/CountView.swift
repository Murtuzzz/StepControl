//
//  DistantCountView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 31.08.2023.
//

import UIKit

extension StepsController {
    final class CountView: UIView {
        
        private var theme = ["dark","light","system"]
        
        private let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.translatesAutoresizingMaskIntoConstraints = false
            view.spacing = 5
            return view
        }()
        
        private let percentLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.avenirBook(with: 23)
            label.textColor = R.Colors.inactive
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
            //            label.adjustsFontSizeToFitWidth = true
            //            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.avenirBook(with: 10)
            label.textColor = R.Colors.orangeTwo
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            //            label.adjustsFontForContentSizeCategory = true
            //            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            addSubview(stackView)
            stackView.addArrangedSubview(percentLabel)
            stackView.addArrangedSubview(subtitleLabel)
            themeChange()
            constraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func constraints() {
            NSLayoutConstraint.activate([
                
                //percentLabel.widthAnchor.constraint(equalToConstant: 100),
                
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        func configure(with title: String, andValue value: String) {
            subtitleLabel.text = title
            percentLabel.text = value
        }
        
        func themeChange() {
            if theme[UserSettings.themeIndex] == "light" {
                percentLabel.textColor = R.Colors.darkBlue
                subtitleLabel.textColor = R.Colors.orangeTwo
            } else if theme[UserSettings.themeIndex] == "dark" {
                percentLabel.textColor = R.Colors.inactive
                subtitleLabel.textColor = R.Colors.orangeTwo
            } else {
                
            }
        }
    }
    
    
}

