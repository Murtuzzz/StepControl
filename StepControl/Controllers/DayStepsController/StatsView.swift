//
//  StatsView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 14.10.2023.
//

import UIKit

final class StatsView: UIView {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Floors"
        //label.textColor = R.Colors.gray
        label.textAlignment = .center
        label.textColor = R.Colors.orangeTwo
        label.font = R.Fonts.avenirBook(with: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "figure.stairs")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "32"
        label.textColor = .white
        label.backgroundColor = R.Colors.darkBlue
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.font = R.Fonts.avenirBook(with: 54)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(icon: String, title: String, value: Int) {
        super.init(frame: .zero)
        
        addSubview(container)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(countLabel)
        
        titleLabel.text = title
        imageView.image = UIImage(systemName: icon)
        countLabel.text = "\(value)"
        
        backgroundColor = .clear
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            countLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 80),
            countLabel.widthAnchor.constraint(equalToConstant: 80),
            
//            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
//            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -16),
            titleLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -48),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
//            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            
        ])
    }
}
