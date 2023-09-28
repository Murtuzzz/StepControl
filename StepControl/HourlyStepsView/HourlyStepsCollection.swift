//
//  HourlyStepsCollection.swift
//  StepControl
//
//  Created by Мурат Кудухов on 19.09.2023.
//

import UIKit

struct BarData {
    let heightMultiplier: Double
    let value: String
    let title: String
}

final class HourlyStepsCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
    
    private var stepsController = StepsController()
    
    private var dataSource: [BarData] = []
    
//    private let barsView = HourlyStepsCell()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.darkBlue
        view.layer.borderColor = R.Colors.darkBlue.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
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
    
    
    init(data: [BarData]) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        addSubview(separatorOne)
        addSubview(separatorTwo)
        addSubview(separatorThree)
        
        //addSubview(barsView)
        
        //barsView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints()
        collectionViewApperance(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionViewApperance(data: [BarData]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        dataSource = data
        //print("Count - - \(dataSource)")
       
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(HourlyStepsCell.self, forCellWithReuseIdentifier: HourlyStepsCell.id)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
                   
               ])
        collectionView.reloadData()
        
    }
    
    public func updateCollection() {
        print("reload")
        collectionView!.reloadData()
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            separatorOne.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 32),
            separatorOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            separatorOne.heightAnchor.constraint(equalToConstant: 1),
            //separatorOne.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 16),
            
            separatorTwo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorTwo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorTwo.heightAnchor.constraint(equalToConstant: 1),
            separatorTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            separatorThree.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -32),
            separatorThree.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            separatorThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            separatorThree.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                   
               ])
    }
    
}

extension HourlyStepsCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyStepsCell.id, for: indexPath) as! HourlyStepsCell
        
        let items = dataSource[indexPath.row]
       
        cell.configurate(with: .init(heightMultiplier: items.heightMultiplier, value: items.value, title: items.title))
        //collectionView.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = 20
        let height: CGFloat = collectionView.bounds.height - 24
        
        return CGSize(width: width, height: height)
    }
}
