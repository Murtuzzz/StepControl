//
//  SegmentCollectionCell.swift
//  StepControl
//
//  Created by Мурат Кудухов on 29.09.2023.
//

import UIKit

final class SegmentedCollectionCell: UICollectionViewCell {
    
    static let id = "SegmentedCollectionCell"
    
    private var view: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var border1: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var border2: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(view)
        addSubview(border1)
        addSubview(border2)
        //backgroundColor = .red.withAlphaComponent(0.5)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(data: [BarData]) {
        self.view.removeFromSuperview()
        self.view = HourlyStepsCollection(data: data)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.view)
        
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        self.view.updateConstraints()
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            border1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            border1.topAnchor.constraint(equalTo: topAnchor),
            //border1.heightAnchor.constraint(equalToConstant: bounds.height),
            border1.widthAnchor.constraint(equalToConstant: 1),
            border1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            border2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            border2.topAnchor.constraint(equalTo: topAnchor),
            //border1.heightAnchor.constraint(equalToConstant: bounds.height),
            border2.widthAnchor.constraint(equalToConstant: 1),
            border2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
