//
//  SectionHeaderView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 10.09.2023.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static let id = "SectionHeaderView"
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 18)
        label.textColor = R.Colors.inactive
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        addSubview(title)
        constraints()
    }
    
    func configure(with title: String) {
        
        self.title.text = title
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

