//
//  Views.swift
//  StepControl
//
//  Created by Мурат Кудухов on 09.09.2023.
//

import UIKit

struct AchievementData {
    struct Data {
        let image: String
        var isActive: Bool
        let title: String
        let subtitle: String
    }
    let title: String
    var items: [Data]
}

final class AchievementController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var achCondArray:[Bool] = []
    private var imageArray:[String] = []
    
    private var achivCount = 0
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"StepsBg")
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        return view
    }()
    
    private let achievementsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "starPurp")
        view.tintColor = R.Colors.orange
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Achievements"
        label.font = R.Fonts.avenirBook(with: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "0 out of 6"
        label.font = R.Fonts.avenirBook(with: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView?
    
    private var dataSource: [AchievementData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(backgroundImage)
        
        view.backgroundColor = R.Colors.darkGray
        
        view.addSubview(container)
        view.addSubview(achievementsImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        //scrollView.delegate = self
        
        constraints()
        collectionViewApperance()
        themeChange()
        //navigationController?.navigationBar.tintColor = R.Colors.darkBlue
        //view.backgroundColor = R.Colors.darkBlue
    }
    
    func collectionViewApperance() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        
        
        dataSource = [.init(title: "Day Achievements", items: [.init(image: "thumbUp", isActive: false, title: "First Steps", subtitle: "Walk 10.000 steps in one day"),
                                                               .init(image: "fire", isActive: false,title: "We get started", subtitle: "Walk 15.000 in one day"),
                                                               .init(image: "rocket", isActive: false,title: "Step-addicted", subtitle: "Walk 20.000 in one day")]),
//                      .init(title: "Week Achievements", items: [.init(image: "cup", isActive: false, title: "First Steps", subtitle: "Walk 35.000 steps in one month"),
//                                                                 .init(image: "cupGold", isActive: false,title: "We get started", subtitle: "Walk 50.000 steps in one week"),
//                                                                 .init(image: "cupColor", isActive: false,title: "Step-addicted", subtitle: "Walk 70.000 steps in one week")]),
                      .init(title: "Month Achievements", items: [.init(image: "starRed", isActive: false, title: "First Steps", subtitle: "Walk 135.000 steps in one month"),
                                                                 .init(image: "starGold", isActive: false,title: "We get started", subtitle: "Walk 235.000 steps in one month"),
                                                                 .init(image: "starColor", isActive: false,title: "Step-addicted", subtitle: "Walk 300.000 steps in one month")]),]
        
        //collectionView?.reloadData()
        
        Steps.shared.getSteps { [weak self] steps,error  in
            DispatchQueue.main.async {
                
                var stepsArray: [Double] = []
                var dateArray: [String] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM"
                let sorted_dict = steps.sorted { $0.key < $1.key }
                
                for (date, steps) in sorted_dict {
                    stepsArray.append(steps)
                    dateArray.append(dateFormatter.string(from:date))
                }
                
                for i in stepsArray {
                    if i >= 10000 {
                        self!.dataSource[0].items[0].isActive = true
                        self!.collectionView?.reloadData()
                        if i >= 15000 {
                            self!.dataSource[0].items[1].isActive = true
                            self!.collectionView?.reloadData()
                            if i >= 20000 {
                                self!.dataSource[0].items[2].isActive = true
                                self!.collectionView?.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        AllStepsCount.shared.getSteps { [weak self] steps in
            DispatchQueue.main.async {
                
                var stepsArray = steps[1]
                stepsArray.reverse()
                
                for i in stepsArray {
                    if Int(i)! >= 135000 {
                        self!.dataSource[1].items[0].isActive = true
                        self!.collectionView?.reloadData()
                        if Int(i)! >= 235000 {
                            self!.dataSource[1].items[1].isActive = true
                            self!.collectionView?.reloadData()
                            if Int(i)! >= 300000 {
                                self!.dataSource[1].items[2].isActive = true
                                self!.collectionView?.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(AchievementCell.self, forCellWithReuseIdentifier: AchievementCell.id)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8),
                   collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                   collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24),
                   collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                   
               ])
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            //MARK: - ScrollViewConstraints
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: 832),//1128
//
//            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
            //MARK: - OtherConstraints
            
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            
            achievementsImageView.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 8),
            achievementsImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            achievementsImageView.widthAnchor.constraint(equalToConstant: 56),
            achievementsImageView.heightAnchor.constraint(equalTo: achievementsImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: achievementsImageView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        
        ])
    }
}

extension AchievementController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        view.configure(with: dataSource[indexPath.section].title)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCell.id, for: indexPath) as! AchievementCell
        
        let items = dataSource[indexPath.section].items[indexPath.row]
        
        achCondArray.append(items.isActive)
        imageArray.append(items.image)
        
        cell.configure(with: items.image, isActive: items.isActive)
        
        if items.isActive == true {
            achivCount += 1
            subtitleLabel.text = "\(achivCount) out of 6"
        }
        
        if achivCount >= 3 && achivCount < 6 {
            achievementsImageView.image = UIImage(named: "trophy1")
        } else if achivCount >= 6 {
            achievementsImageView.image = UIImage(named: "trophy2")
        } else if achivCount == 9 {
            achievementsImageView.image = UIImage(named: "trophy3")
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = dataSource[indexPath.section].items[indexPath.row]

        let vc = AchievementDescription(image: items.image, title: items.title, description: items.subtitle, isActive: items.isActive)

        present(vc,animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width/3 - 8
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 56)
    }
    
    func themeChange() {
        if UserSettings.themeIndex == 1 {
            titleLabel.textColor = .white
            subtitleLabel.textColor = .white
            //container.backgroundColor = R.Colors.blue
            navigationItem.leftBarButtonItem?.tintColor = R.Colors.darkBlue
            navigationItem.rightBarButtonItem?.tintColor = R.Colors.darkBlue
            navigationController?.navigationBar.tintColor = .white
            if let navigationBar = self.navigationController?.navigationBar {
                // Изменение цвета заголовка
                let attributes = [NSAttributedString.Key.foregroundColor: R.Colors.darkBlue]
                navigationBar.titleTextAttributes = attributes
                view.backgroundColor = R.Colors.inactive
                backgroundImage.image = nil
            } else if UserSettings.themeIndex == 0 {
                titleLabel.textColor = R.Colors.darkBlue
                subtitleLabel.textColor = R.Colors.darkBlue
                navigationItem.leftBarButtonItem?.tintColor = .white
                navigationItem.rightBarButtonItem?.tintColor = .white
                navigationController?.navigationBar.tintColor = .white
                //view.backgroundColor = .white
                if let navigationBar = self.navigationController?.navigationBar {
                    // Изменение цвета заголовка
                    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                    navigationBar.titleTextAttributes = attributes
                    
                    backgroundImage.image = UIImage(named:"StepsBg")
                } else {
                    
                }
            }
        }
    }
}
