//
//  StreakView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 20.10.2023.
//

import UIKit

final class StreakView: UIView {
    
    private let streakView: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.contentMode = .scaleAspectFit
        view.tintColor = R.Colors.orangeThree
        view.image = UIImage(systemName: "flame")
        return view
    }()
    
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 20)
        label.textColor = .white
        return label
    }()
    
    init(value: Int) {
        super.init(frame: .zero)
        addSubview(streakView)
        addSubview(imageView)
        addSubview(streakLabel)
        
        streakLabel.text = "\(value)"
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        streakView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func buttonAction() {
        print("TAP")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            streakView.leadingAnchor.constraint(equalTo: leadingAnchor),
            streakView.trailingAnchor.constraint(equalTo: trailingAnchor),
            streakView.topAnchor.constraint(equalTo: topAnchor),
            streakView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: streakView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            streakLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -8),
            streakLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            streakLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
        
        ])
    }
    
}
