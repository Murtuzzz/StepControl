//
//  XAxisView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 14.09.2023.
//

import UIKit

final class XAxisView: UIView {
    
    private var heightMultiplier: Double
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        self.heightMultiplier = 0.0
        super.init(frame: .zero)
        
   

        
        addSubview(stackView)
        
        //self.heightMultiplier = heightConstraints(data: data)
        backgroundColor = .clear

        
        
        constraints()
        //themeChange()
    }
    
    required init?(coder: NSCoder) {
        self.heightMultiplier = 0
        super.init(frame: .zero)
    }
    
    func configure(with data: [ChartsView.Data]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        
        data.forEach {
            let label = UILabel()
            label.font  = R.Fonts.avenirBook(with: 9)
            label.textColor = .white
            label.textAlignment = .center
            label.text = $0.title.uppercased()
            
            stackView.addArrangedSubview(label)
        }
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        ])
    }
    
//    func themeChange() {
//        if traitCollection.userInterfaceStyle == .light {
//            barView.backgroundColor = R.Colors.darkBlue
//            titleLabel.textColor = R.Colors.darkBlue
//            valueLabel.textColor = R.Colors.darkBlue
//        } else {
//
//        }
//    }
}
