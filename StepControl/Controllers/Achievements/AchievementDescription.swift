//
//  AchievementDescription.swift
//  StepControl
//
//  Created by Мурат Кудухов on 10.09.2023.
//

import UIKit

final class AchievementDescription: UIViewController {
    
    private var icon: UIImage? = nil
    
    private let topViewRounded: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let bigCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = R.Colors.orange
        label.font = R.Fonts.avenirBook(with: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkGray
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let achievementsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "trophy1")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let imageViewBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.layer.cornerRadius = 65
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(bigCloseButton)
        view.addSubview(container)
        view.addSubview(imageViewBackground)
        view.addSubview(achievementsImageView)
        view.addSubview(topViewRounded)
        view.addSubview(titleLabel)
        view.addSubview(subtitle)
        
        bigCloseButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        constraints()
    }
    
    @objc
    private func closeAction() {
        dismiss(animated: true)
    }
    
    func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        var images = [CGImage]()
        
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
        }
        
        return UIImage.animatedImage(with: images.map { UIImage(cgImage: $0) }, duration: 2.0)
    }
    
    init(image: String, title: String, description: String, isActive: Bool) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        subtitle.text = description
        var imageList = image.split(separator: ".")
        print(imageList)
        if isActive == true {
            if imageList.contains("gif") {
                
                imageList.reverse()
                let img = String(imageList[0] + imageList[1])
                print(img)
                guard let asset = NSDataAsset(name: img) else {return}
                
                achievementsImageView.removeFromSuperview()
                achievementsImageView.image = nil
                if let gif = gif(data: asset.data) {
                    let imageView = UIImageView(image: gif)
                    view.addSubview(imageView)
                    
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        imageView.centerYAnchor.constraint(equalTo: imageViewBackground.centerYAnchor),
                        imageView.centerXAnchor.constraint(equalTo: imageViewBackground.centerXAnchor),
                        imageView.heightAnchor.constraint(equalToConstant: 104),
                        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                        
                        
                    ])
                }
                
            } else {
                achievementsImageView.image = UIImage(named: image)
            }
            
        } else {
            achievementsImageView.tintColor = R.Colors.darkGray
            titleLabel.textColor = R.Colors.orangeTwo
            achievementsImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageViewBackground.bottomAnchor, constant: 32),
            
            subtitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            achievementsImageView.centerYAnchor.constraint(equalTo: imageViewBackground.centerYAnchor),
            achievementsImageView.centerXAnchor.constraint(equalTo: imageViewBackground.centerXAnchor),
            achievementsImageView.heightAnchor.constraint(equalToConstant: 104),
            achievementsImageView.widthAnchor.constraint(equalTo: achievementsImageView.heightAnchor),
            
            imageViewBackground.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageViewBackground.topAnchor.constraint(equalTo: container.topAnchor, constant: 64),
            imageViewBackground.heightAnchor.constraint(equalToConstant: view.bounds.width / 3),//144
            imageViewBackground.widthAnchor.constraint(equalTo: imageViewBackground.heightAnchor),
            
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/2.1),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bigCloseButton.topAnchor.constraint(equalTo: view.topAnchor),
            bigCloseButton.bottomAnchor.constraint(equalTo: container.topAnchor),
            bigCloseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigCloseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topViewRounded.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            topViewRounded.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            topViewRounded.widthAnchor.constraint(equalToConstant: 88),
            topViewRounded.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
}
