//
//  TextFielf.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(imageName: String, placeholder: String) {
        super.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.backgroundColor = .systemBackground
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.label.cgColor
        self.placeholder = placeholder
        self.leftViewMode = .always

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        let image = UIImage(systemName: imageName)
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 4.0, width: 20.0, height: 20.0))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = .label
        view.addSubview(imageView)
        self.leftView = view
    }

    private func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }

    func enablePasswordToggle() {
        let button = UIButton()
        button.tintColor = .label
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry.toggle()
        setPasswordToggleImage(sender as? UIButton ?? UIButton())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

