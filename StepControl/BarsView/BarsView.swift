//
//  BarsView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 02.09.2023.
//

import UIKit

final class BarsView: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(stackView)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(with data: [BarView.Data]) {
        data.forEach {
            let barView = BarView(data: $0)
            
            stackView.addArrangedSubview(barView)
        }
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}
