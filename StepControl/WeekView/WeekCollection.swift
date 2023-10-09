//
//  WeekCollection.swift
//  StepControl
//
//  Created by Мурат Кудухов on 21.09.2023.
//

import UIKit

struct WeekData {
    let date: String
    let weekDay: String
    let index: Int
}

protocol WeekDayDelegate: AnyObject {
    func getWeekDay(_ index: Int)
}

final class WeekCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var delegate: WeekDayDelegate?
    
    var currentIndexPath: IndexPath?
    
    private var cellPath = 0
    
//    static var shared = WeekCollection()
    
    private var collectionView: UICollectionView?
    
    private var dataSource: [WeekData] = []
    
    var cellsList: [WeekCell] = []
    
    init() {
        super.init(frame: .zero)
        
        stepsCollectionApperance()
        settings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stepsCollectionApperance() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2.7
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.id)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
               ])
    }
    
    func settings() {
        var weekdays:[[Substring]] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE,d"

        
        for i in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let formattedDate = dateFormatter.string(from: date)
                let DayAndDate = formattedDate.split(separator: ",")
                weekdays.append(DayAndDate)
            }
        }
        
        weekdays.reverse()
        
        for i in 0...6 {
            let dayNum = (String(weekdays[i][1]))
            let dayName = (String(weekdays[i][0]))
            
            dataSource.append(.init(date: dayNum, weekDay: dayName, index: i))
            //print(dayName)
        }
    }
    
    func cellPath(completion: @escaping (Int) -> Void) {
        completion(self.cellPath)
        print("cell = \(cellPath)")
    }
}

extension WeekCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.id, for: indexPath) as! WeekCell
        
        let items = dataSource[indexPath.row]
        cellsList.append(cell)
        
        cell.configure(weekDay: items.weekDay, date: items.date, index: items.index)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellsList.forEach { item in
            item.reset()
            
        }
        
        delegate?.getWeekDay(indexPath.row)
        
        cellsList[indexPath.row].changeCondition()
//        self.cellPath = indexPath.row
        self.currentIndexPath = indexPath
        print(indexPath.row)
        cellsList[indexPath.row].getCellIndex(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = UIScreen.main.bounds.height / 18.2
        var height: CGFloat = 46.5
        
        if UIScreen.main.bounds.height == 667 {
            width = 44
            height = 44
        } 
//        else {
//            width = 46.5
//            height = 46.5
//        }
        
        return CGSize(width: width, height: height)
    }
}
