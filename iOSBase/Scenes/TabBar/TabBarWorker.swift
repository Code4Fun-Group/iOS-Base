//
//  TabBarWorker.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import Foundation

public extension Notification.Name {
	static let updateBadge = Notification.Name("Notification.updateBadge")
}

protocol ITabBarWorker {
	var selectedIndex: Int { get }
	var isTabBarLoaded: Bool { get }
	var itemsCountBadgeNumber: String? { get }
	
	func saveSelected(at index: Int)
	func getAvailablePageViews(complete:  @escaping ([ITabBarPageModel]) -> Void)
}

struct TabBarWorker {
	let homeAssembly: IHomeAssembly
	let inMemoryStore: TabBarInMemoryStore
}

extension TabBarWorker: ITabBarWorker {
	var selectedIndex: Int {
		inMemoryStore.selectedIndex
	}
	
	var isTabBarLoaded: Bool {
		inMemoryStore.isTabBarLoaded
	}
	
	func saveSelected(at index: Int) {
		inMemoryStore.selectedIndex = index
	}
	
	var itemsCountBadgeNumber: String? {
		""
	}
	
	func getAvailablePageViews(complete: @escaping ([ITabBarPageModel]) -> Void) {
		inMemoryStore.pages.removeAll()
		if let homeViewController = try? homeAssembly.build(with: nil) {
			let page = TabBarPageModel(title: "Home.Title".localized, iconName: "tab-home", badge: nil, viewController: homeViewController)
			inMemoryStore.pages.append(page)
		}
		
		inMemoryStore.isTabBarLoaded = true
		complete(inMemoryStore.pages)
	}
}
