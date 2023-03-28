//
//  ApodViewController.swift
//  NasaApod
//
//  Created by Timur Dzamikh on 28.03.2023.
//

import UIKit

class ApodViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var information: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        fetchAPOD()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
    }
    
    // MARK: - Private Methods
    private func showAlert() {
        let alert = UIAlertController(title: "Failed", message: "Invalid data type! It is recommended to select another date to proceed.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)}
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc private func imageTapped() {
        let fullScreenVC = ImageViewController()
        fullScreenVC.view.backgroundColor = .black
        fullScreenVC.modalPresentationStyle = .pageSheet
        
        let fullScreenImageView = UIImageView(image: image.image)
        fullScreenImageView.contentMode = .scaleAspectFit
        fullScreenImageView.frame = fullScreenVC.view.bounds
        fullScreenImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fullScreenVC.view.addSubview(fullScreenImageView)
        
        let rectangleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 15))
        rectangleView.backgroundColor = UIColor.opaqueSeparator
        rectangleView.center = CGPoint(x: view.bounds.width/2, y: 0)
        rectangleView.layer.cornerRadius = 6
        fullScreenVC.view.addSubview(rectangleView)
        
        let closeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 20))
        closeLabel.text = "Swipe down to close"
        closeLabel.textColor = .opaqueSeparator
        closeLabel.center = CGPoint(x: view.bounds.width/2, y: 24)
        fullScreenVC.view.addSubview(closeLabel)
        
        self.present(fullScreenVC, animated: true, completion: nil)
    }
}

// MARK: - Networking
extension ApodViewController {
    private func fetchAPOD() {
        guard let choseDate = selectedDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: choseDate)
        
        let apiKey = "EPmm6HHRPRWwefy3Ni18TvTe4UTzYscQ19eI9hts"
        let apodURL = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(dateString)"
        
        guard let url = URL(string: apodURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let apod = try decoder.decode(APOD.self, from: data)
                print(apod)
                
                guard let imageURL = URL(string: apod.url) else { return }
                let imageData = try Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    self?.titleLabel.text = apod.title
                    self?.information.text = apod.explanation
                    self?.activityIndicator.stopAnimating()
                    if apod.media_type == "image" {
                        self?.image.image = UIImage(data: imageData)
                    } else if apod.media_type == "video" {
                        self?.image.image = UIImage(named: "no-image-icon")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.showAlert()
                }
            }
        }.resume()
    }
}

