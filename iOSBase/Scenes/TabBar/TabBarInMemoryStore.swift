//
//  TabBarInMemoryStore.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import Foundation

protocol ITabBarInMemoryStore {
	var pages: [ITabBarPageModel] { get set }
	var selectedIndex: Int { get set }
	var isTabBarLoaded: Bool { get set }
}

class TabBarInMemoryStore: ITabBarInMemoryStore {
	var pages: [ITabBarPageModel] = []
	var selectedIndex: Int = 0
	var isTabBarLoaded: Bool = false
	
	init(selectedIndex: Int) {
		self.selectedIndex = selectedIndex
	}
}
