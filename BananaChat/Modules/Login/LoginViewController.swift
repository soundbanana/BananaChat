//
//  LoginViewController.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Log In"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = TextField(imageName: "envelope", placeholder: "Email address")
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = TextField(imageName: "lock", placeholder: "Password")
        textField.isSecureTextEntry = true
        textField.enablePasswordToggle()
        return textField
    }()

    lazy var loginButton: UIButton = {
        let button = Button(title: "Log in")
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I don't have an account", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    private var bottomConstraint: NSLayoutConstraint?

    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert("Enter all fields")
            return
        }
    }

    @objc func signUpButtonTapped() {
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unregisterForKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraints()
        registerForKeyboardNotifications()
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    private func setConstraints() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])

        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 16
        stackview.translatesAutoresizingMaskIntoConstraints = false

        stackview.addArrangedSubview(emailTextField)
        stackview.addArrangedSubview(passwordTextField)

        view.addSubview(stackview)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            stackview.bottomAnchor.constraint(lessThanOrEqualTo: loginButton.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loginButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8),
//            loginButton.topAnchor.constraint(: stackview.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])

        bottomConstraint = signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        bottomConstraint?.isActive = true
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let safeAreaBottomInset = view.safeAreaInsets.bottom

        let constant = -(keyboardHeight - safeAreaBottomInset)

        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = constant
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = -20
            self.view.layoutIfNeeded()
        }
    }
}
