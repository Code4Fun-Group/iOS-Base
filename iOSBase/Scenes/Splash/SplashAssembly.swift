//
//  SplashAssembly.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Common

private enum Constants {
	static let moduleName = "Splash"
	static let storyboardName = "Splash"
	static let identifier = "SplashViewController"
}

public protocol ISplashAssembly: IAssembly {
}

public struct SplashAssembly: ISplashAssembly {
	public let module = Module(name: Constants.moduleName)
	
	let tokenService: IAppTokenService
	
	init(tokenService: IAppTokenService) {
		self.tokenService = tokenService
	}
}

public extension SplashAssembly {
	func build(with parameters: [String: Any]?) throws -> UIViewController {
		let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: Constants.identifier) as? SplashViewController else {
			throw AssemblyError.moduleNotFound
		}
		
		let remoteStore = SplashRemoteStore()
		let worker = SplashWorker(remoteStore: remoteStore, tokenService: tokenService)
		let presenter = SplashPresenter(viewController: viewController)
		let interactor = SplashInteractor(worker: worker, presenter: presenter)
		let router = SplashRouter()
		viewController.interactor = interactor
		viewController.router = router
		
		return viewController
	}
}
