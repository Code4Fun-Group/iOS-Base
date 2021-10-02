//
//  UIViewExtension.swift
//  CommonUI
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

// swiftlint:disable force_unwrapping
protocol IView {
	static var name: String { get }
}

extension IView where Self: UIView {
	static var name: String {
		return String(describing: self).components(separatedBy: ".").last!
	}
}

extension UIView: IView { }

public extension UIView {
	class func fromNib<T: UIView>(bundle: Bundle) -> T {
		return bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as! T
	}
	
	func fitInView(_ container: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(self)
		
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: container.topAnchor, constant: .zero),
			bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: .zero),
			leftAnchor.constraint(equalTo: container.leftAnchor, constant: .zero),
			rightAnchor.constraint(equalTo: container.rightAnchor, constant: .zero)
		])
	}
	
	func centerInView(_ container: UIView, size: CGSize) {
		translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(self)
		
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: container.centerXAnchor),
			centerYAnchor.constraint(equalTo: container.centerYAnchor),
			widthAnchor.constraint(equalToConstant: size.width),
			heightAnchor.constraint(equalToConstant: size.height)
		])
	}
	
	func centerInView(_ container: UIView, marginVertical: CGFloat, marginHorizontal: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(self)
		
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: container.centerXAnchor),
			centerYAnchor.constraint(equalTo: container.centerYAnchor),
			topAnchor.constraint(equalTo: container.topAnchor, constant: marginVertical),
			leftAnchor.constraint(equalTo: container.leftAnchor, constant: marginHorizontal)
		])
	}
}
