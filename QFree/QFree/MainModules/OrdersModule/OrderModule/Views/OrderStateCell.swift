//
//  OrderStateCell.swift
//  QFree
//
//  Created by Maxim V. Sidorov on 12/7/20.
//

import Foundation
import UIKit

class OrderStateCell: UITableViewCell {
    
    override var reuseIdentifier: String? {
        return "OrderStateCell"
    }
    
    private let shadowView = UIView()
    let titleLabel = UILabel()
    let restaurantImageView = UIImageView()
    private let statusLabel = UILabel()
    let timeLabel = UILabel()
    let orderNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(shadowView)
        shadowView.addSubview(titleLabel)
        shadowView.addSubview(restaurantImageView)
        shadowView.addSubview(statusLabel)
        shadowView.addSubview(timeLabel)
        shadowView.addSubview(orderNumberLabel)
        
        let inset: CGFloat = 12.0
        
        shadowView.addShadow()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
        
        titleLabel.isHidden = true
        titleLabel.font = Brandbook.font(size: 20, weight: .bold)
        titleLabel.textColor = Brandbook.textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: inset),
            titleLabel.topAnchor.constraint(equalTo: shadowView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -inset),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        restaurantImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            restaurantImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            restaurantImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            restaurantImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            restaurantImageView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -inset),
            restaurantImageView.heightAnchor.constraint(equalTo: restaurantImageView.widthAnchor, multiplier: 0.6)
        ])
        
        statusLabel.isHidden = true
        statusLabel.text = "Статус заказа"
        statusLabel.textColor = Brandbook.textColor
        statusLabel.font = Brandbook.font(size: 20, weight: .bold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 8.0),
            statusLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            statusLabel.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        timeLabel.textColor = Brandbook.defaultColor
        timeLabel.font = Brandbook.font(size: 18, weight: .bold)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: inset),
            timeLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -inset),
            timeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        orderNumberLabel.textColor = Brandbook.defaultColor
        orderNumberLabel.font = Brandbook.font(size: 18, weight: .bold)
        orderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orderNumberLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: inset),
            orderNumberLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            orderNumberLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -inset),
            orderNumberLabel.heightAnchor.constraint(equalToConstant: 30),
            orderNumberLabel.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -inset)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOrderInfo(_ orderInfo: OrderInfo) {
        [titleLabel, statusLabel].forEach { $0.isHidden = false }
        titleLabel.text = orderInfo.restaurantName
        //timeLabel.text = "Будет готов к \(orderInfo.completionTime)"
        timeLabel.text = "Будет готов к 20:00"
        //orderNumberLabel.text = "Номер заказа: \(orderInfo.number)"
        orderNumberLabel.text = "Номер заказа: B30"
        URLSession.shared.dataTask(with: URL(string: orderInfo.restaurantImageUrl)!) { [weak self] (data, response, error) in
            guard error == nil, let data = data else {
                return
            }
            DispatchQueue.main.async {
                self?.restaurantImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
