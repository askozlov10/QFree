//
//  OrderIsProcessedViewController.swift.swift
//  QFree
//
//  Created by Maxim V. Sidorov on 1/10/21.
//

import UIKit

class OrderIsProcessedViewController: UIViewController {

    var okButtonAction: (() -> ())?
    private let okButton = BaseButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "Заказ оформлен!"
        titleLabel.textColor = Brandbook.defaultColor
        titleLabel.textAlignment = .center
        titleLabel.font = Brandbook.font(size: 35, weight: .bold)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Номер вашего заказа: B30"
        subtitleLabel.textColor = Brandbook.defaultColor
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = Brandbook.font(size: 20, weight: .bold)
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 50),
            subtitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])

        let imageView = UIImageView(image: UIImage(named: "order-is-processed")!)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])

        okButton.filled = true
        okButton.setTitle("Отлично", for: .normal)
        okButton.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.heightAnchor.constraint(equalToConstant: Brandbook.defaultButtonHeight),
            okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }

    @objc private func okButtonPressed() {
        okButtonAction?()
    }
}
