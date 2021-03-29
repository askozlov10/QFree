//
//  RestaurantMenuTableViewController.swift
//  QFree
//
//  Created by Дмитрий on 09.11.2020.
//

import UIKit

class RestaurantMenuTableViewController: BaseTableViewController {
    var restaurntName = "ГРУША"
    var restaurantID: String = "1"
    var products: [Product] = []
    var basket: [Product : Int] = [Product : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = .clear
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBasket()
        getProductsByIdRestaurants()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("basket before  post", basket)
        postBasket()
    }

    private func postBasket() {
        FirebaseHandler.shared.postBasket(products: self.basket) { (error) in
            if error != nil {
                self.showNoInternetAlert(self.postBasket)
            }
        }
    }

    private func getProductsByIdRestaurants() {
        FirebaseHandler.shared.getProductsByIDRestaurant(id: self.restaurantID) { result in
            print("restaurantID", self.restaurantID)
            switch result {
            case .success(let products):
                self.products = products
                self.tableView.reloadData()
            case .failure(let error):
                if error == .noInternetConnection {
                    self.showNoInternetAlert(self.getProductsByIdRestaurants)
                }
            }
        }
    }

    private func getBasket() {
        FirebaseHandler.shared.getBasket { result in
            switch result {
            case .success(let basket):
                self.basket = basket
                self.tableView.reloadData()
            case .failure(let error):
                if error == .noInternetConnection {
                    self.showNoInternetAlert(self.getBasket)
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        let product = products[indexPath.row]
        
        if self.basket[self.products[indexPath.row]] != nil {
            cell.amountLabel.text = String(self.basket[self.products[indexPath.row]]!)
        } else {
            cell.amountLabel.text = "0"
        }
        
        cell.buttonAddCallback = {
            if self.checkRestaurantId() {
                if self.basket[self.products[indexPath.row]] == nil {
                    self.basket[self.products[indexPath.row]] = 0
                }
                self.basket[self.products[indexPath.row]]! += 1
                cell.amountLabel.text = String(self.basket[self.products[indexPath.row]]!)
            } else {
                self.showAlertDifferentId()
                
            }
            
        }
        
        cell.buttonMinusCallback = {
            if self.basket[self.products[indexPath.row]] != nil && self.basket[self.products[indexPath.row]] != 0 {
                self.basket[self.products[indexPath.row]]! -= 1
            
                cell.amountLabel.text = String(self.basket[self.products[indexPath.row]]!)
            }
            cell.amountLabel.text = String(self.basket[self.products[indexPath.row]]!)
            
        }
        
        cell.configure(with: product)
    
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped cell number \(indexPath.row).")
//        if basket[products[indexPath.row]] == nil {
//            basket[products[indexPath.row]] = 0
//        }
//        basket[products[indexPath.row]]! += 1
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func checkRestaurantId() -> Bool {
        for p in basket.keys {
            if p.restaurantID != self.restaurantID {
                return false
            }
        }
        return true
    }
    func showAlertDifferentId() {
        let alert = UIAlertController(title: "Очистить корзину?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.basket = [Product : Int]()
        }))
        self.present(alert, animated: true)
    }
}
