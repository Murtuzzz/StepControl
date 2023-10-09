//
//  AchievementCell.swift
//  StepControl
//
//  Created by Мурат Кудухов on 10.09.2023.
//

import UIKit

final class AchievementCell: UICollectionViewCell {
    
    static let id = "AchievementCell"
    
    private let achievementsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "trophy1")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.layer.cornerRadius = 53
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(container)
        addSubview(achievementsImageView)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: String, isActive: Bool) {
        achievementsImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        if isActive == true {
            achievementsImageView.image = UIImage(named: image)
        } else {
            achievementsImageView.tintColor = R.Colors.darkGray
            achievementsImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            achievementsImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            achievementsImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            achievementsImageView.heightAnchor.constraint(equalToConstant: 72),
            achievementsImageView.widthAnchor.constraint(equalTo: achievementsImageView.heightAnchor)
            
        
        ])
    }
}
