//
//  LaunchManager.swift
//  iOSBase
//
//  Created by NamNH on 01/11/2021.
//

import Common
import CommonUI

struct LaunchManager {
	func configureDependencies() {
		// MARK: - Home
		let homeAssembly = HomeAssembly()
		
		// MARK: - Default
		let splashAssembly = SplashAssembly(tokenService: DependencyResolver.shared.appTokenService)
		let tabBarAssembly = TabBarAssembly(homeAssembly: homeAssembly)
		
		// MARK: - Assembly
		AssemblyContainer.shared.transitionCoordinator = ApplicationTransitionCoordinator()
		AssemblyContainer.register(
			splashAssembly,
			tabBarAssembly
		)
	}
}
