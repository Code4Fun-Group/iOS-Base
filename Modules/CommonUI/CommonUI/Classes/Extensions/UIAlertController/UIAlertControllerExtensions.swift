//
//  UIAlertControllerExtensions.swift
//  Pods
//
//  Created by NamNH on 24/11/2021.
//

import UIKit

public typealias SystemAlertButtonData = (title: String, style: UIAlertAction.Style, handler: (() -> Void)?)

public extension UIAlertController {
	static func showSystemAlert(target: UIViewController? = UIViewController.top(),
								title: String? = nil,
								message: String? = nil,
								buttons: [String],
								handler: ((_ index: Int, _ title: String) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		buttons.enumerated().forEach { button in
			let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
				handler?(button.offset, button.element)
			})
			alert.addAction(action)
		}
		target?.present(alert, animated: true)
	}
	
	static func showSystemActionSheet(target: UIViewController? = UIViewController.top(),
									  title: String? = nil,
									  message: String? = nil,
									  optionButtons: [SystemAlertButtonData],
									  cancelButton: SystemAlertButtonData) {
		let viewBG = UIView(frame: UIScreen.main.bounds)
		let backgroundColor = UIColor.black.withAlphaComponent(0.6)
		let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		optionButtons.forEach { (button) in
			alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (_) in
				viewBG.removeFromSuperview()
				button.handler?()
			}))
		}
		let cancelAction = UIAlertAction(title: cancelButton.title, style: UIAlertAction.Style.cancel, handler: { (_) in
			viewBG.removeFromSuperview()
			cancelButton.handler?()
		})
		alert.addAction(cancelAction)
		viewBG.backgroundColor = backgroundColor
		target?.view.addSubview(viewBG)
		target?.present(alert, animated: true)
	}
}

public extension UIViewController {
	class func top(controller: UIViewController? = nil) -> UIViewController? {
		var rootViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
		if let controller = controller {
			rootViewController = controller
		}
		if let navigationController = rootViewController as? UINavigationController {
			return top(controller: navigationController.visibleViewController)
		}
		if let tabController = rootViewController as? UITabBarController {
			if let selected = tabController.selectedViewController {
				return top(controller: selected)
			}
		}
		if let presented = rootViewController?.presentedViewController {
			return top(controller: presented)
		}
		return controller
	}
}
