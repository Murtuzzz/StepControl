//
//  AverageView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 15.10.2023.
//

import UIKit

final class AverageStepsView: UIView {
    
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
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = R.Colors.orangeTwo
        label.font = R.Fonts.avenirBook(with: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        //view.image = UIImage(systemName: "figure.stairs")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "32"
        label.textColor = .white
        label.backgroundColor = R.Colors.darkBlue
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.font = R.Fonts.avenirBook(with: 52)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(icon: UIImage?, title: String, value: Int) {
        super.init(frame: .zero)
        
        addSubview(container)
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(countLabel)
        
        titleLabel.text = title
        //imageView.image = UIImage(systemName: icon)
        countLabel.text = "\(value)"
        
        backgroundColor = .clear
        
        if let gif = icon {
            let imageView = UIImageView(image: gif)
            addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                imageView.heightAnchor.constraint(equalToConstant: 32),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        }
        
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
            
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -88),
            countLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 8),
            countLabel.heightAnchor.constraint(equalToConstant: 64),
            countLabel.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -64),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            
        ])
    }
}
