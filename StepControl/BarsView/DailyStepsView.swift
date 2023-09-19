//
//  DailyStepsView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 02.09.2023.
//

import UIKit

final class DailyStepsView: UIView {
    
    private let barsView = BarsView()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.darkBlue
        view.layer.borderColor = R.Colors.darkBlue.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorOne: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorTwo: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorThree: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init(cornerRadius: Int) {
        contentView.layer.cornerRadius = CGFloat(cornerRadius)
        super.init(frame: .zero)
        
        
        addSubview(contentView)
        
        
        addSubview(separatorOne)
        addSubview(separatorTwo)
        addSubview(separatorThree)
        addSubview(barsView)
        
        constraints()
        //themeChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(with items: [BarView.Data]?) {
        barsView.configurate(with: items ?? [.init(value: "0k", heightMultiplier: 0.0, title: "0")])
    }
    
    func constraints() {
        barsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            separatorOne.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 32),
            separatorOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            separatorOne.heightAnchor.constraint(equalToConstant: 1),
            separatorOne.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 16),
            
            separatorTwo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorTwo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorTwo.heightAnchor.constraint(equalToConstant: 1),
            separatorTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            separatorThree.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -32),
            separatorThree.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            separatorThree.heightAnchor.constraint(equalToConstant: 1),
            
            barsView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 24),
            barsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            barsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            barsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            
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
