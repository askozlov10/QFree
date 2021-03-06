//
//  OrderPresenter.swift
//  QFree
//
//  Created by Maxim V. Sidorov on 12/8/20.
//

protocol OrderPresenterProtocol {
    func viewDidLoad()
}

class OrderPresenter {
    weak var view: OrderViewProtocol?
    var interactor: OrderInteractorProtocol
    var router: OrderRouterProtocol
    
    init(view: OrderViewProtocol, interactor: OrderInteractorProtocol, router: OrderRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension OrderPresenter: OrderPresenterProtocol {
    func viewDidLoad() {
        fetchCurrentOrderInfo()
        fetchBasket()
    }

    private func fetchCurrentOrderInfo() {
        interactor.fetchCurrentOrderInfo { result in
            switch result {
            case .success(let orderInfo):
                self.view?.update(orderInfo)
            case .failure(let error):
                if error == .noInternetConnection {
                    self.view?.showNoInternetAlert(self.fetchCurrentOrderInfo)
                }
            }
        }
    }

    private func fetchBasket() {
        interactor.fetchBasket { result in
            switch result {
            case .success(let products):
                self.view?.update(products)
            case .failure(let error):
                if error == .noInternetConnection {
                    self.view?.showNoInternetAlert(self.fetchBasket)
                }
            }
        }
    }
}
