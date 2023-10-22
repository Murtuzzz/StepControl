//
//  SettingsController.swift
//  StepControl
//
//  Created by Мурат Кудухов on 01.09.2023.
//

import UIKit

final class SettingsController: UIViewController {
    
    private let target: (String) -> ()
    
    private let steps = StepsController()
    
    private var isNotificationsOn: Bool = UserSettings.notifications ?? false
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "App theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.darkBlue
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let bigCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Dark","Light"])
        segment.selectedSegmentIndex = UserSettings.themeIndex ?? 0
        segment.clipsToBounds = true
        segment.layer.masksToBounds = true
        segment.layer.cornerRadius = 50
        //segment.layer.borderWidth = 1
        segment.layer.borderColor = R.Colors.darkBlue.cgColor
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .white
        segment.selectedSegmentTintColor = R.Colors.darkBlue
        segment.backgroundColor = R.Colors.orangeTwo.withAlphaComponent(0.5)
        return segment
    }()
    
    private let notificationsSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = UserSettings.notifications ?? false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = R.Colors.darkBlue
        return view
    }()
    
    private let notificationImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "bell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = R.Colors.darkBlue
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let targetTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.textAlignment = .left
        textField.text = UserSettings.target ?? "5000"
        textField.keyboardType = .numberPad
        textField.placeholder = ""
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 30
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 3
        textField.layer.borderColor = R.Colors.darkBlue.cgColor
        textField.font = R.Fonts.avenirBook(with: 40)
        return textField
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.gray
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "Target"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.darkBlue
        label.font = R.Fonts.avenirBook(with: 16)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    private let targetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBlue
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.systemGray6.cgColor
        view.layer.shadowRadius = 2
        return view
    }()
    
    private let saveTargetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.titleLabel?.font = R.Fonts.avenirBook(with: 18)
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = R.Colors.orangeTwo
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(bigCloseButton)
        view.addSubview(container)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(targetView)
        view.addSubview(notificationsSwitch)
        view.addSubview(notificationImage)
        view.addSubview(themeLabel)
        view.addSubview(segmentedControl)
        navigationController?.navigationBar.tintColor = .cyan
        
        view.addSubview(targetTextField)
        view.addSubview(targetLabel)
        view.addSubview(saveTargetButton)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        
        notificationsSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        saveTargetButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        bigCloseButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        constraints()
        keyboardApperance()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func changeTheme(to theme: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) { // Проверка доступности API
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = theme
            }
        }
    }
    
    func keyboardApperance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/4
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    @objc
    func segmentedControlAction() {
        showAlert(title: "Success!", message: "To change theme please reload the app")
        if segmentedControl.selectedSegmentIndex == 0 {
            UserSettings.themeIndex = 0
            changeTheme(to: .dark)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            UserSettings.themeIndex = 1
            changeTheme(to: .light)
        } else {
            UserSettings.themeIndex = 2
            changeTheme(to: .unspecified)
        }
    }
    
    @objc
    private func switchAction() {
        isNotificationsOn.toggle()
        UserSettings.notifications = isNotificationsOn
        if isNotificationsOn == true {
            showAlert(title: "Success", message: "Target notifications ON 🔔")
        } else {
            showAlert(title: "Succes", message: "Target notifications OFF 🔕")
        }
        steps.getSteps()
    }
    
    @objc
    private func closeButtonAction() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonAction() {
        showAlert(title: "Success!", message: "Target saved")
        UserSettings.target = targetTextField.text
        target(UserSettings.target ?? "9000")
        print("saveButtonPushed")
    }
    
    init(target: @escaping (String) -> ()) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            themeLabel.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            themeLabel.heightAnchor.constraint(equalToConstant: 32),
//            themeLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            
            segmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 16),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 72),
            segmentedControl.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            
            notificationImage.centerYAnchor.constraint(equalTo: notificationsSwitch.centerYAnchor),
            notificationImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant:48),
            notificationImage.heightAnchor.constraint(equalToConstant: notificationsSwitch.bounds.height),
            
            notificationsSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            notificationsSwitch.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 16),

            saveTargetButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            saveTargetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            saveTargetButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2 - 50),
            saveTargetButton.heightAnchor.constraint(equalToConstant: 64),
            
            targetView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            targetView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            targetView.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            targetView.heightAnchor.constraint(equalToConstant: 64),
            
            targetLabel.topAnchor.constraint(equalTo: targetTextField.topAnchor, constant: -13),
            targetLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 40),
            targetLabel.widthAnchor.constraint(equalToConstant: 56),
            
            targetTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            targetTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            targetTextField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            targetTextField.heightAnchor.constraint(equalToConstant: 64),
            
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            
//            container.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/3.2),
            container.heightAnchor.constraint(equalToConstant: view.bounds.height/2 + 24),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bigCloseButton.topAnchor.constraint(equalTo: view.topAnchor),
            bigCloseButton.bottomAnchor.constraint(equalTo: container.topAnchor),
            bigCloseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigCloseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
        ])
    }
}

