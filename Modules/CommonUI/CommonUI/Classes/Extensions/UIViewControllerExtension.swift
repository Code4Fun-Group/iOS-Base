//
//  UIViewControllerExtension.swift
//  CommonUI
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

// swiftlint:disable force_unwrapping
public extension UIViewController {
	static var name: String {
		return String(describing: self).components(separatedBy: ".").last!
	}
	
	static func createFromXib(bundle: Bundle = .main) -> UIViewController {
		return self.init(nibName: Self.name, bundle: bundle)
	}
	
	static func createFromStoryBoard(storyboard: String, bundle: Bundle = .main) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
		return storyboard.instantiateViewController(withIdentifier: name)
	}
}
