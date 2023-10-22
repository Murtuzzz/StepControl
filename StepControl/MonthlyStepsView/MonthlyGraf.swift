//
//  MonthlyGraf.swift
//  StepControl
//
//  Created by Мурат Кудухов on 12.09.2023.
//

import UIKit

final class MonthlyGraf: UIView {
    
    private let chartsView = ChartsView()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.darkBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"StepsBg")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let separatorOne: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorTwo: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorThree: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init(cornerRadius: Int) {
        contentView.layer.cornerRadius = CGFloat(cornerRadius)
        backgroundImage.layer.cornerRadius = CGFloat(cornerRadius)
        super.init(frame: .zero)
        
        //contentView.addSubview(backgroundImage)
        addSubview(contentView)
        addSubview(chartsView)
        
        backgroundColor = .clear
        
        
        constraints()
        //themeChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(with items: [ChartsView.Data]!, topChartsOffset: Int = 10) {
        chartsView.configurate(with: items ?? [.init(value: 00 , title: "02/03")], topChartOffset: topChartsOffset)
    }
    
    func constraints() {
        chartsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
//            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
//            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
//            
            chartsView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 24),
            chartsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            chartsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            chartsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
//    func themeChange() {
//        if traitCollection.userInterfaceStyle == .light {
//            contentView.backgroundColor = R.Colors.inactive
//            contentView.layer.borderColor = R.Colors.bl.cgColor
//        } else {
//            contentView.backgroundColor = R.Colors.darkBlue
//            contentView.layer.borderColor = UIColor.clear.cgColor
//        }
//    }
}

