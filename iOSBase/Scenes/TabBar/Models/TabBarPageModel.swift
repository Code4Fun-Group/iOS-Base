//
//  TabBarPageModel.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import UIKit

protocol ITabBarPageModel {
	var title: String { get }
	var iconName: String { get }
	var iconActiveName: String { get }
	var badge: String? { get }
	var viewController: UIViewController { get }
}

struct TabBarPageModel: ITabBarPageModel {
	var title: String
	var iconName: String
	var badge: String?
	var viewController: UIViewController
}

extension TabBarPageModel {
	var iconActiveName: String {
		iconName + "-active"
	}
}
