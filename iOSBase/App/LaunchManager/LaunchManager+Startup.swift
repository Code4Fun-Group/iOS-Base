//
//  LaunchManager+Startup.swift
//  iOSBase
//
//  Created by NamNH on 01/11/2021.
//

import Common

extension LaunchManager {
	func getSplashScreen() -> UIViewController {
		do {
			let viewController = try AssemblyContainer.shared.resolve(Transition(name: "Splash"))
			return viewController
		} catch {
			assertionFailure("AssemblyNotFound")
		}
		return UIViewController()
	}

	func startup() -> UIViewController {
		do {
			let viewController = try AssemblyContainer.shared.resolve(Transition(name: "TabBar"))
			return viewController
		} catch {
			assertionFailure("AssemblyNotFound")
		}
		return UIViewController()
	}
}
