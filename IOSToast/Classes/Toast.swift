//
//  Toast.swift
//  Toast
//
//  Created by Nguyễn Ngọc Linh on 10/18/22.
//

import UIKit

extension UIView {
    func showToast(message: String, toast: Toast = Toast(frame: CGRect(x: 0, y: 0, width: 0, height: 0)), toastType: ToastType = .error, position: PositionToast = .center, time: CGFloat = 3, padding: CGFloat = 0) {
        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        self.addSubview(toast)
        toast.translatesAutoresizingMaskIntoConstraints = false
        
        switch position {
        case .top:
            NSLayoutConstraint.activate([toast.topAnchor.constraint(equalTo: self.topAnchor, constant: -15 - padding)])
        case .center:
            NSLayoutConstraint.activate([toast.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15 - padding)])
        case .bottom:
            NSLayoutConstraint.activate([toast.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25 - padding)])
        }
        
        toast.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toast.applyToastType(message: message, toastType: toastType)
        
        toast.layoutIfNeeded()
        if toast.frame.width > frame.width - 20 {
            toast.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        }
        
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
            toast.removeFromSuperview()
            timer.invalidate()
        }
    }
}

class Toast: UIView {
    private var customBackgroundColor: UIColor = .purple.withAlphaComponent(0.75)
    private var cornerRadius: CGFloat = 10
    private var isMasksToBounds: Bool = true
    private var toastImage: ToastImage = ToastImage(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var toastLabel: ToastLabel = ToastLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    func customBackgroundColor(_ color: UIColor) -> Toast {
        customBackgroundColor = color
        return self
    }
    
    func cornerRadius(_ radius: CGFloat) -> Toast {
        cornerRadius = radius
        return self
    }
    
    func masksToBounds(_ isBound: Bool) -> Toast {
        isMasksToBounds = isBound
        return self
    }
    
    func toastImage(_ image: ToastImage) -> Toast {
        toastImage = image
        return self
    }
    
    func toastLabel(_ label: ToastLabel) -> Toast {
        toastLabel = label
        return self
    }
    
    func applyToastType(message: String, toastType: ToastType) {
        switch toastType {
        case .warning:
            self.backgroundColor = .systemYellow.withAlphaComponent(0.85)
        case .success:
            self.backgroundColor = .systemGreen.withAlphaComponent(0.85)
        case .error:
            self.backgroundColor = .systemRed.withAlphaComponent(0.85)
        case .notify:
            self.backgroundColor = .black.withAlphaComponent(0.75)
        case .custom:
            self.backgroundColor = customBackgroundColor
        }
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = isMasksToBounds
        
        toastImage.image = UIImage(named: "toast_warning_icon")
        
        toastLabel.text = message

        
        toastImage.applyToastType(toastType: toastType)
        toastLabel.applyToastType(toastType: toastType)

        self.addSubview(toastImage)
        self.addSubview(toastLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        toastImage.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toastImage.sizeToFit()
        toastLabel.sizeToFit()
        
        NSLayoutConstraint.activate([self.heightAnchor.constraint(equalTo: toastLabel.heightAnchor, constant: 20),
                                     toastImage.widthAnchor.constraint(equalToConstant: toastImage.frame.width),
                                     toastImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     toastImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     toastLabel.leadingAnchor.constraint(equalTo: toastImage.trailingAnchor, constant: 5),
                                     toastLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     toastLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)])
    }
}

class ToastLabel: UILabel {
    private var customLabelColor: UIColor = .white
    private var labelBackgroundColor: UIColor = .clear
    private var fontStyle: UIFont = .boldSystemFont(ofSize: 20)
    private var labelNumberOfLines: Int = 0
    private var labelTextAlignment: NSTextAlignment = .center
    private var labelLineBreakMode: NSLineBreakMode = .byWordWrapping
    
    func customLabelColor(_ color: UIColor) -> ToastLabel {
        customLabelColor = color
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> ToastLabel {
        labelBackgroundColor = color
        return self
    }
    
    func fontStyle(_ font: UIFont) -> ToastLabel {
        fontStyle = font
        return self
    }
    
    func numberOfLines(_ number: Int) -> ToastLabel {
        numberOfLines = number
        return self
    }
    
    func textAlignment(_ alignment: NSTextAlignment) -> ToastLabel {
        textAlignment = alignment
        return self
    }
    
    func lineBreakMode(_ breakMode: NSLineBreakMode) -> ToastLabel {
        lineBreakMode = breakMode
        return self
    }
    
    func applyToastType(toastType: ToastType) {
        self.backgroundColor = labelBackgroundColor
        self.font = fontStyle
        self.numberOfLines = labelNumberOfLines
        self.textAlignment = labelTextAlignment
        self.lineBreakMode = labelLineBreakMode
        
        switch toastType {
        case .warning, .success, .error:
            self.textColor = UIColor(cgColor: CGColor(red: 36/255, green: 71/255, blue: 161/255, alpha: 1))
        case .notify:
            self.textColor = .white
        case .custom:
            self.textColor = customLabelColor
        }
    }
}

class ToastImage: UIImageView {
    private var customImage: UIImage = UIImage()
    private var imageBackgroundColor: UIColor = .clear
    private var imageSize: CGSize = CGSize(width: 40, height: 40)
    private var imageTintColor: UIColor = .white
    
    func customImage(_ image: UIImage) -> ToastImage {
        customImage = image
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> ToastImage {
        imageBackgroundColor = color
        return self
    }
    
    func size(_ size: CGSize) -> ToastImage {
        imageSize = size
        return self
    }
    
    func tintColor(_ color: UIColor) -> ToastImage {
        imageTintColor = color
        return self
    }
    
    func applyToastType(toastType: ToastType) {
        var image: UIImage? = UIImage()
        
        switch toastType {
        case .warning:
            image = UIImage(systemName: "exclamationmark.circle.fill")
        case .success:
            image = UIImage(systemName: "checkmark.circle.fill")
        case .error:
            image = UIImage(systemName: "exclamationmark.triangle.fill")
        case .notify:
            break
        case .custom:
            image = customImage
        }
        
        self.backgroundColor = imageBackgroundColor
        self.image = image?.resize(size: imageSize).withTintColor(imageTintColor)
    }
}

extension UIImage {
    func resize(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
