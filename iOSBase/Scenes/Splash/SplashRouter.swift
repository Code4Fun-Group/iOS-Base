//
//  SplashRouter.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Common

public protocol ISplashRouter: IRouter {
	func goToLogin()
	func goToHomePage()
}

public struct SplashRouter {
}

extension SplashRouter: ISplashRouter {
	public func goToLogin() {
		resetRootView(moduleName: "Login")
	}
	
	public func goToHomePage() {
		resetRootView(moduleName: "TabBar")
	}
}
