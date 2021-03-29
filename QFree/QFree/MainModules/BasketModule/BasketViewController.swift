//
//  BasketVC.swift
//  QFree
//
//  Created by Саид Дагалаев on 27.10.2020.
//

import UIKit

protocol BasketViewProtocol: class {
    
}

class BasketViewController: BaseViewController {
    var presenter: BasketPresenterProtocol?
    
    private var basket: [Product : Int] = [Product : Int]()
    private var products: [Product] = [Product]()
    private var orderButton = BaseButton()
    private var tableView: UITableView = UITableView()
    private var emptyBasketLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setOrderButton()
        setTableView()
        setEmptyBasketLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBasket()
    }

    private func getBasket() {
        FirebaseHandler.shared.getBasket { result in
            switch result {
            case .success(let basket):
                self.basket = basket
                self.updateUI()
            case .failure(let error):
                if error == .noInternetConnection {
                    self.showNoInternetAlert(self.getBasket)
                }
            }
        }
    }

    private func updateUI() {
        self.tableView.isHidden = self.basket.isEmpty
        self.orderButton.isHidden = self.basket.isEmpty
        self.emptyBasketLabel.isHidden = !self.basket.isEmpty
        if !self.basket.isEmpty {
            print("basket updated")
            for (item, value) in basket{
                if value == 0{
                    basket.removeValue(forKey: item)
                }
            }
            self.products = basket.map { $0.key }
            self.tableView.reloadData()
        }
    }
    
    private func setupTitle() {
        self.title = "Корзина"
    }
    
    private func setOrderButton() {
        self.view.addSubview(orderButton)
        self.orderButton.setTitle("Заказать", for: .normal)
        self.orderButton.translatesAutoresizingMaskIntoConstraints = false
        self.orderButton.titleLabel?.text = "Заказать"
        self.orderButton.isHidden = true
        self.orderButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        self.orderButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        self.orderButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:  -12).isActive = true
        self.orderButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        self.orderButton.addTarget(self, action: #selector(orderButtonPressed), for: .touchUpInside)
    }

    private func setEmptyBasketLabel() {
        emptyBasketLabel.text = "Корзина пуста"
        emptyBasketLabel.textAlignment = .center
        emptyBasketLabel.font = Brandbook.font(size: 30, weight: .bold)
        emptyBasketLabel.textColor = .lightGray
        emptyBasketLabel.adjustsFontSizeToFitWidth = true
        emptyBasketLabel.minimumScaleFactor = 0.5
        emptyBasketLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyBasketLabel)
        NSLayoutConstraint.activate([
            emptyBasketLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyBasketLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyBasketLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            emptyBasketLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func orderButtonPressed() {
        
        presenter?.makeOrder(basket: basket, completion: { (error) in
            if let error = error {
                if error == .noInternetConnection {
                    self.showNoInternetAlert(self.orderButtonPressed)
                }
            } else {
                self.showOrderIsProcessed()
            }
        })
    }

    private func showOrderIsProcessed() {
        let orderIsProcessedViewController = OrderIsProcessedViewController()
        orderIsProcessedViewController.modalPresentationStyle = .fullScreen
        orderIsProcessedViewController.okButtonAction = {
            orderIsProcessedViewController.dismiss(animated: true)
            self.basket.removeAll()
            self.updateUI()
            self.tabBarController?.selectedIndex = 1
        }
        present(orderIsProcessedViewController, animated: true)
    }
    
    private func setTableView() {
        self.view.addSubview(tableView)
        self.tableView.separatorColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.orderButton.topAnchor, constant: -12).isActive = true
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProductTableViewCell()
        cell.nameLabel.text = String(products[indexPath.row].name)
        cell.priceLabel.text = String(products[indexPath.row].price) + "₽"
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.amountLabel.text = String(self.basket[self.products[indexPath.row]]!)
        cell.addButton.isHidden = true
        cell.minusButton.isHidden = true
        cell.configure(with: self.products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension BasketViewController: BasketViewProtocol {
    
}
