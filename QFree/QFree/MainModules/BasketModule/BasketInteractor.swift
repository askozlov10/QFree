//
//  BasketInteractor.swift
//  QFree
//
//  Created by Maxim V. Sidorov on 12/8/20.
//

protocol BasketInteractorProtocol {
    func makeOrder(basket: [Product : Int], completion: @escaping (NetworkingError?) -> ())
}

class BasketInteractor {
    
}

extension BasketInteractor: BasketInteractorProtocol {
    func makeOrder(basket: [Product : Int], completion: @escaping (NetworkingError?) -> ()) {
//        FirebaseHandler.shared.makeOrder(basket: basket) { (error) in
//            completion(error)
//        }
        ServerHandler.submitAction(data: basket, id: 1234, time: "17:20")
        //completion(nil)
    }
}
