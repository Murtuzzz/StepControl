import UIKit

class GrafficsController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = R.Colors.gray
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let gradientGraf = GraphGradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(gradientGraf)
        view.addSubview(titleLabel)
        
        constraints()
        
    }
    
    func constraints() {
        
        gradientGraf.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            gradientGraf.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            gradientGraf.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientGraf.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            gradientGraf.heightAnchor.constraint(equalToConstant: 200),
        
        ])
    }
    
}
