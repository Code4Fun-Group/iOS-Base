//
//  TabBarPresenter.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import Common

protocol ITabBarPresenter {
	func presentViewControllers(response: GetChildViewControllerUseCase.Response)
	func presentCurrentViewController(response: SelectTabBarUseCase.Response)
	func presentTabBarBadgeView(response: PresentTabBarBadgeViewUseCase.Response)
}

protocol ITabBarViewController: AnyObject {
	func showViewControllers(viewModel: GetChildViewControllerUseCase.ViewModel)
	func showCurrentViewController(viewModel: SelectTabBarUseCase.ViewModel)
	func showTabBarBadgeView(viewModel: PresentTabBarBadgeViewUseCase.ViewModel)
}

struct TabBarPresenter {
	weak var viewController: ITabBarViewController?
}

extension TabBarPresenter: ITabBarPresenter {
	func presentViewControllers(response: GetChildViewControllerUseCase.Response) {
		let viewControllers = response.pages.map { page -> UIViewController in
			let viewController = page.viewController
			viewController.tabBarItem = UITabBarItem(title: page.title, image: UIImage(named: page.iconName), selectedImage: UIImage(named: page.iconActiveName))
			return viewController
		}
		
		let viewModel = GetChildViewControllerUseCase.ViewModel(viewControllers: viewControllers)
		viewController?.showViewControllers(viewModel: viewModel)
	}
	
	func presentCurrentViewController(response: SelectTabBarUseCase.Response) {
		let viewModel = SelectTabBarUseCase.ViewModel(index: response.index)
		viewController?.showCurrentViewController(viewModel: viewModel)
	}
	
	func presentTabBarBadgeView(response: PresentTabBarBadgeViewUseCase.Response) {
		if let tabBarController = viewController as? TabBarViewController {
			var homeTabItemIndex: Int?
			
			// Getting tabItem index
			for (tabItemIndex, viewController) in (tabBarController.viewControllers ?? []).enumerated() {
				if viewController.isKind(of: HomeViewController.self) {
					homeTabItemIndex = tabItemIndex
					break
				}
			}
			
			// Getting tabItem
			if let homeTabItemIndex = homeTabItemIndex,
			   let tabItems = tabBarController.tabBar.items,
			   let tabItem = tabItems[safe: homeTabItemIndex] {
				tabItem.badgeValue = response.badgeNumber
			}
		}
		
		let viewModel = PresentTabBarBadgeViewUseCase.ViewModel()
		viewController?.showTabBarBadgeView(viewModel: viewModel)
	}
}
