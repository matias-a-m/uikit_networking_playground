import UIKit
import PlaygroundSupport

// MARK: - Variables de control de error

/// Indica si la carga de la imagen de X-Wing debería fallar
let shouldFailXWing = true

/// Indica si la carga de la imagen de TIE Fighter debería fallar
let shouldFailTieFighter = false

// MARK: - Models

/// Modelo que representa un vehículo de Star Wars
struct StarWarsVehicle {
    let name: String
    let imageURL: URL?
    let shouldFail: Bool
}

// MARK: - ViewModels

/// ViewModel que maneja los datos de los vehículos de Star Wars
class StarWarsVehiclesViewModel {
    private let vehicles: [StarWarsVehicle] = [
        StarWarsVehicle(name: "X-Wing Starfighter",
                        imageURL: StarWarsVehicles.generateVehicleURL(path: StarWarsVehicles.pathXWings, region: .xWingStarfighterRegion).url,
                        shouldFail: shouldFailXWing),
        StarWarsVehicle(name: "Darth Vader's TIE Fighter",
                        imageURL: StarWarsVehicles.generateVehicleURL(path: StarWarsVehicles.pathTieFighter, region: .darthVaderTieFighterRegion).url,
                        shouldFail: shouldFailTieFighter)
    ]
    
    /// Obtiene la lista de vehículos de Star Wars
    func getVehicles() -> [StarWarsVehicle] {
        return vehicles
    }
}

// MARK: - Custom Views

/// Vista personalizada que muestra una imagen con esquinas redondeadas y un indicador de actividad
class RoundedImageView: UIView {
    
    private let imageView: UIImageView
    private let activityIndicator: UIActivityIndicatorView
    private let errorLabel: UILabel
    
    /// Inicializa la vista con un vehículo de Star Wars
    init(vehicle: StarWarsVehicle) {
        self.imageView = UIImageView()
        self.activityIndicator = UIActivityIndicatorView(style: .gray)
        self.errorLabel = UILabel()
        super.init(frame: .zero)
        
        setupSubviews()
        setupConstraints()
        loadImage(for: vehicle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura las subviews de la vista
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(errorLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        errorLabel.text = "Error en la carga de la imagen"
        
        imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
    }
    
    /// Configura las constraints de la vista
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    /// Carga la imagen del vehículo de Star Wars
    private func loadImage(for vehicle: StarWarsVehicle) {
        if let imageURL = vehicle.imageURL, !vehicle.shouldFail {
            activityIndicator.startAnimating()
            imageView.load(url: imageURL) { [weak self] success in
                if success {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self?.imageView.transform = .identity
                    }
                } else {
                    self?.showErrorLabel()
                }
            }
        } else {
            showErrorLabel()
        }
    }
    
    /// Muestra el label de error
    private func showErrorLabel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.stopAnimating()
            self.errorLabel.isHidden = false
        }
    }
}

// MARK: - Views

/// Vista principal que muestra los vehículos de Star Wars
class StarWarsVehiclesView: UIView {
    
    private let viewModel: StarWarsVehiclesViewModel
    
    /// Inicializa la vista con un ViewModel
    init(viewModel: StarWarsVehiclesViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura la vista principal
    private func setupView() {
        let vehicles = viewModel.getVehicles()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for vehicle in vehicles {
            let titleLabel = UILabel()
            titleLabel.text = vehicle.name
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            stackView.addArrangedSubview(titleLabel)
            
            let roundedImageView = RoundedImageView(vehicle: vehicle)
            stackView.addArrangedSubview(roundedImageView)
            roundedImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Application Setup

let viewModel = StarWarsVehiclesViewModel()
let vehiclesView = StarWarsVehiclesView(viewModel: viewModel)
vehiclesView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.liveView = vehiclesView

// MARK: - Supporting Structures

/// Estructura de soporte para generar URLs de imágenes de vehículos de Star Wars
struct StarWarsVehicles {
    
    static let scheme = "https"
    static let host = "lumiere-a.akamaihd.net"
    static let pathTieFighter = "/v1/images/vaders-tie-fighter_8bcb92e1.jpeg"
    static let pathXWings = "/v1/images/X-Wing-Fighter_47c7c342.jpeg"
    
    enum ParameterKey: String {
        case region = "region"
    }
    
    enum MediaType: String {
        case xWingStarfighterRegion = "0%2C1%2C1536%2C864"
        case darthVaderTieFighterRegion = "0%2C147%2C1560%2C878&width=1536"
    }
    
    /// Genera una URL para un vehículo de Star Wars
    static func generateVehicleURL(path: String, region: MediaType) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem(name: ParameterKey.region.rawValue, value: region.rawValue)]
        return urlComponents
    }
}

// MARK: - Extension for UIImageView load image from URL

extension UIImageView {
    /// Carga una imagen desde una URL
    func load(url: URL, completion: ((Bool) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.image = nil
                    completion?(false)
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion?(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }.resume()
    }
}
