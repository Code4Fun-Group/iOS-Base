//
//  SplashViewController.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import UIKit

class SplashViewController: UIViewController {
	// MARK: - Outlets
	
	// MARK: - Variables
	var interactor: ISplashInteractor!
	var router: ISplashRouter!
	
	// MARK: Lifecycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		checkAuthen()
	}
}

// MARK: - Setup UI
private extension SplashViewController {
	func setupUI() {
		
	}
}

// MARK: - Interactor
private extension SplashViewController {
	func checkAuthen() {
		let request = CheckAuthenticationUseCase.Request()
		interactor.checkAuthen(request: request)
	}
}

// MARK: - ISplashViewController
extension SplashViewController: ISplashViewController {
	func showAuthen(viewModel: CheckAuthenticationUseCase.ViewModel) {
		if viewModel.accessToken == nil {
			router.goToLogin()
		} else {
			router.goToHomePage()
		}
	}
}
