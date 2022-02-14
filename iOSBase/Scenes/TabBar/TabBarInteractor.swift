//
//  TabBarInteractor.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import Foundation

protocol ITabBarInteractor {
	func selectTabBarItem(request: SelectTabBarUseCase.Request)
	func getChildViewControllers(request: GetChildViewControllerUseCase.Request)
	func presentTabBarBadgeView(request: PresentTabBarBadgeViewUseCase.Request)
}

struct TabBarInteractor {
	var worker: ITabBarWorker
	var presenter: ITabBarPresenter
}

extension TabBarInteractor: ITabBarInteractor {
	func selectTabBarItem(request: SelectTabBarUseCase.Request) {
		worker.saveSelected(at: request.index)
		let tabBarSelectResponse = SelectTabBarUseCase.Response(index: worker.selectedIndex)
		presenter.presentCurrentViewController(response: tabBarSelectResponse)
	}
	
	func getChildViewControllers(request: GetChildViewControllerUseCase.Request) {
		if !request.isForceReload {
			guard !worker.isTabBarLoaded else {
				return
			}
		}
		let tabBarSelectResponse = SelectTabBarUseCase.Response(index: worker.selectedIndex)
		worker.getAvailablePageViews { pageViews in
			let pageViewsResponse = GetChildViewControllerUseCase.Response(pages: pageViews)
			presenter.presentViewControllers(response: pageViewsResponse)
			presenter.presentCurrentViewController(response: tabBarSelectResponse)
		}
	}
	
	func presentTabBarBadgeView(request: PresentTabBarBadgeViewUseCase.Request) {
		let response = PresentTabBarBadgeViewUseCase.Response(badgeNumber: worker.itemsCountBadgeNumber)
		presenter.presentTabBarBadgeView(response: response)
	}
}
