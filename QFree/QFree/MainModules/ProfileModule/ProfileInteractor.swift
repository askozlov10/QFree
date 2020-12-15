//
//  ProfileInteractor.swift
//  QFree
//
//  Created by Саид Дагалаев on 28.10.2020.
//

import Foundation
import UIKit
import FirebaseAuth

protocol ProfileInteractorProtocol {
    func changeEmail(email: String, completion: @escaping ()->())
    func changePassword(completion: @escaping ()->())
    func logOut(completion: @escaping ()->())
}

class ProfileInteractor : ProfileInteractorProtocol {
    func changeEmail(email: String, completion: @escaping () -> ()) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let e = error{
                print(e.localizedDescription)
            } else{
                completion()
            }
        })
    }
    
    func logOut(completion: @escaping () -> ()) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func changePassword(completion: @escaping ()->()) {
        Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else{
                completion()
            }
        }
    }
}
