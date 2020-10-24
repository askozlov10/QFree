//
//  RegistrationViewController.swift
//  QFree
//
//  Created by Maxim Sidorov on 24.10.2020.
//

import UIKit

protocol RegistrationViewProtocol: class {

}

class RegistrationViewController: BaseViewController {
    public var presenter: RegistrationPresenterProtocol?
    
    private var stackView: FormStackView!
    private var nameTextField: BaseTextField!
    private var emailTextField: BaseTextField!
    private var passwordTextField: BaseTextField!
    private var createAccountButton: BaseButton!
    
    private var stackViewCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupEnterForm()
    }
    
    private func setupTitle() {
        title = "Новый аккаунт"
    }
    
    private func setupEnterForm() {
        let elementHeight: CGFloat = 48
        
        nameTextField = BaseTextField()
        nameTextField.placeholder = "Имя"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.heightAnchor.constraint(equalToConstant: elementHeight).isActive = true
        
        emailTextField = BaseTextField()
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "Почта"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: elementHeight).isActive = true
        
        passwordTextField = BaseTextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Пароль"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: elementHeight).isActive = true
        
        createAccountButton = BaseButton()
        createAccountButton.addTarget(self, action: #selector(createAccountButtonAction(_:)), for: .touchUpInside)
        createAccountButton.setTitle("Создать аккаунт", for: .normal)
        createAccountButton.filled = true
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.heightAnchor.constraint(equalToConstant: elementHeight).isActive = true
        
        stackView = FormStackView()
        stackView.spacing = 16
        stackView.addArrangedSubviews(
            nameTextField,
            emailTextField,
            passwordTextField,
            createAccountButton
        )
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewCenterYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewCenterYConstraint,
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
}

extension RegistrationViewController {
    @objc func createAccountButtonAction(_ sender: BaseButton) {
        presenter?.checkInfoAndCreateAccount(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
}

extension RegistrationViewController {
    override func keyboardWillAppear() {
        stackViewCenterYConstraint.isActive = false
        self.stackViewCenterYConstraint = self.stackView.centerYAnchor.constraint(greaterThanOrEqualTo: self.view.centerYAnchor, constant: -75)
        updateStackViewCenterYConstraint()
    }
    
    override func keyboardWillDisappear() {
        stackViewCenterYConstraint.isActive = false
        self.stackViewCenterYConstraint = self.stackView.centerYAnchor.constraint(greaterThanOrEqualTo: self.view.centerYAnchor)
        updateStackViewCenterYConstraint()
        
    }
    
    private func updateStackViewCenterYConstraint() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.stackViewCenterYConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
    
}
