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
        let isActive: Bool
    }
    let title: String
    let items: [Data]
}

final class AchievementController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        view.image = UIImage(systemName: "trophy.fill")
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
        label.text = "4 out of 12"
        label.font = R.Fonts.avenirBook(with: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView?
    
    private var dataSource: [AchievementData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        middleView.addSubview(container)
        middleView.addSubview(achievementsImageView)
        middleView.addSubview(titleLabel)
        middleView.addSubview(subtitleLabel)
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self
        
        constraints()
        collectionViewApperance()
        //view.backgroundColor = R.Colors.darkBlue
    }
    
    func collectionViewApperance() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        dataSource = [.init(title: "Daily Achievements", items: [.init(image: "trophy1", isActive: true),
                                                                 .init(image: "trophy2", isActive: true),
                                                                 .init(image: "trophy3", isActive: true),
                                                                 .init(image: "trophy1", isActive: false),
                                                                 .init(image: "trophy2", isActive: false),
                                                                 .init(image: "trophy3", isActive: false)]),
                      .init(title: "Monthly Achievements", items: [.init(image: "trophy1", isActive: true),
                                                                               .init(image: "trophy2", isActive: true),
                                                                               .init(image: "trophy3", isActive: true),
                                                                               .init(image: "trophy1", isActive: false),
                                                                               .init(image: "trophy2", isActive: false),
                                                                               .init(image: "trophy3", isActive: false)])
        ]
        
        //collectionView?.reloadData()
        
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
        
        middleView.addSubview(collectionView)
        
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 832),//1128
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //MARK: - OtherConstraints
            
            container.topAnchor.constraint(equalTo: middleView.topAnchor),
            container.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            
            achievementsImageView.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 8),
            achievementsImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            achievementsImageView.widthAnchor.constraint(equalToConstant: 88),
            achievementsImageView.heightAnchor.constraint(equalTo: achievementsImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: achievementsImageView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
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
        
        cell.configure(with: items.image, isActive: items.isActive)
        
        
        return cell
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
}
