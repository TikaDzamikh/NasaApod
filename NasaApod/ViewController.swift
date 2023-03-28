//
//  ViewController.swift
//  NasaApod
//
//  Created by Timur Dzamikh on 25.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizingVC()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showApod" {
            guard let apodVC = segue.destination as? ApodViewController else { return }
            apodVC.selectedDate = datePicker.date
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func customizingVC() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "space")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        navigationController?.navigationBar.tintColor = UIColor.opaqueSeparator
        
        startButton.backgroundColor = .opaqueSeparator
        startButton.alpha = 0.6
        startButton.layer.cornerRadius = 14
        datePicker.backgroundColor = UIColor.opaqueSeparator.withAlphaComponent(0.7)
        datePicker.tintColor = .black
    }
}

