//
//  TabBarAssembly.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import Common

private enum Constants {
	static let moduleName = "TabBar"
	static let storyboardName = "TabBar"
	static let identifier = "TabBarViewController"
}

public protocol ITabBarAssembly: IAssembly {
}

public struct TabBarAssembly: ITabBarAssembly {
	public let module = Module(name: Constants.moduleName)
	
	let homeAssembly: IHomeAssembly
	
	public init(homeAssembly: IHomeAssembly) {
		self.homeAssembly = homeAssembly
	}
}

public extension TabBarAssembly {
	func build(with parameters: [String: Any]?) throws -> UIViewController {
		let viewController = TabBarViewController()
		let indexItem = parameters?["tabbarItem"] as? Int
		let inMemoryStore = TabBarInMemoryStore(selectedIndex: indexItem ?? 0)
		
		let worker = TabBarWorker(homeAssembly: homeAssembly, inMemoryStore: inMemoryStore)
		
		let presenter = TabBarPresenter(viewController: viewController)
		let interactor = TabBarInteractor(worker: worker, presenter: presenter)
		let router = TabBarRouter()
		viewController.interactor = interactor
		viewController.router = router
		
		return UINavigationController(rootViewController: viewController)
	}
}
