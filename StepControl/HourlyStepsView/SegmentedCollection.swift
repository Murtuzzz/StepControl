//
//  SegmentedCollection.swift
//  StepControl
//
//  Created by Мурат Кудухов on 29.09.2023.
//

import UIKit

struct CollectionData {
    let data: [BarData]
}

class SegmentedCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var cellIndex = 0 {
        didSet {
            print("YESS")
        }
    }

    private var shouldScrollToLastItem = true
    
    private var grafData: [BarData] = []
    
    private var collectionView: UICollectionView?
    
    private var stepsController = StepsController()
    
    private var dataSource: [CollectionData] = []
    
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
    
    var itemW: CGFloat {
        return 300
    }
    
    var itemH: CGFloat {
        return itemW * 1.45
    }
    
    init(data: [[Double]], cellIndex: Int) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        addSubview(separatorOne)
        addSubview(separatorTwo)
        addSubview(separatorThree)

        constraints()
        collectionViewApperance(data: data)
        
        self.cellIndex = cellIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSteps(index: Int, data: [[Double]]) -> [BarData] {
        
        grafData = []
        var dateArray: [String] = []
        
        let steps = data[index]
        
        for i in 0...24 {
            dateArray.append("\(i):00")
        }
        
        for i in 0...23 {
            self.grafData.append(.init(heightMultiplier: Double(steps[i]/890), value: "\(Int(steps[i]))", title: "\(dateArray[i])"))
            
            //print("Set - \(Double(steps[i]/890))")
        }
        return grafData
    }
    
    func collectionViewApperance(data: [[Double]]) {
        let layout = UICollectionViewFlowLayout()
        //collectionView?.collectionViewLayout = layout
        //layout.minimumLineSpacing = 5
        //layout.minimumInteritemSpacing = 100.0
        layout.scrollDirection = .horizontal
        //layout.itemSize.width = itemW
        
        dataSource = []
        
        for i in 0...6 {
            dataSource.append(.init(data: setSteps(index: i, data: data)))
        }
        

            
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(SegmentedCollectionCell.self, forCellWithReuseIdentifier: SegmentedCollectionCell.id)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        //collectionView.scrollToItem(at: IndexPath(item: dataSource.count - 1, section: 0), at: .right, animated: false)
        
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
            separatorOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorOne.heightAnchor.constraint(equalToConstant: 1),
            
            separatorTwo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorTwo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorTwo.heightAnchor.constraint(equalToConstant: 1),
            separatorTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separatorThree.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -32),
            separatorThree.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorThree.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                   
               ])
    }
}

extension SegmentedCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentedCollectionCell.id, for: indexPath) as! SegmentedCollectionCell
        

        let items = dataSource[indexPath.row]
        
        print(indexPath.row)
       
        cell.configurate(data: items.data)
        
        if shouldScrollToLastItem {
            shouldScrollToLastItem = false
            collectionView.scrollToItem(at: IndexPath(item: cellIndex, section: 0), at: .right, animated: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.bounds.width //20
        let height: CGFloat = collectionView.bounds.height //- 24
        
        return CGSize(width: width, height: height)
    }
}
