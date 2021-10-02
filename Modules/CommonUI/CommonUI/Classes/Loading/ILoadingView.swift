//
//  ILoadingView.swift
//  CommonUI
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

private enum Constants {
	static let restorationIdenfier: String = "reuseLoadingIdenfier"
	static let roundedContainerAlphaBackground: CGFloat = 0.70
	static let animationDuration: TimeInterval = 0.25
}

public protocol IViewControllerLoading {
	var loadingView: UIView? { get }
	func showLoading()
	func hideLoading()
}

public extension IViewControllerLoading where Self: UIViewController {
	var loadingView: UIView? {
		let loading = LoadingView(frame: UIScreen.main.bounds)
		loading.appearance = .containerRounded
		loading.restorationIdentifier = Constants.restorationIdenfier
		loading.show()
		return loading
	}
	
	func showLoading() {
		guard let keyWindow = UIApplication.shared.windows.first,
			  let loadingView = self.loadingView,
			  keyWindow.subviews.filter({ $0.restorationIdentifier == Constants.restorationIdenfier }).first == nil else { return }
		
		UIView.transition(
			with: keyWindow,
			duration: Constants.animationDuration,
			options: [.transitionCrossDissolve],
			animations: {
				keyWindow.addSubview(loadingView)
				NSLayoutConstraint.activate([
					NSLayoutConstraint(item: keyWindow, attribute: .leading, relatedBy: .equal, toItem: loadingView, attribute: .leading, multiplier: 1, constant: .zero),
					NSLayoutConstraint(item: keyWindow, attribute: .trailing, relatedBy: .equal, toItem: loadingView, attribute: .trailing, multiplier: 1, constant: .zero),
					NSLayoutConstraint(item: keyWindow, attribute: .top, relatedBy: .equal, toItem: loadingView, attribute: .top, multiplier: 1, constant: .zero),
					NSLayoutConstraint(item: keyWindow, attribute: .bottom, relatedBy: .equal, toItem: loadingView, attribute: .bottom, multiplier: 1, constant: .zero)
				])
		}, completion: nil)
	}
	
	func hideLoading() {
		guard let window = UIApplication.shared.windows.first else { return }

		for item in window.subviews where item.restorationIdentifier == Constants.restorationIdenfier {
			UIView.transition(
				with: window,
				duration: Constants.animationDuration,
				options: [.transitionCrossDissolve],
				animations: {
					item.removeFromSuperview()
			}, completion: nil)
		}
	}
}
