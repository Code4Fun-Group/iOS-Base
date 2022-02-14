//
//  SplashPresenter.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Foundation

protocol ISplashPresenter {
	func presentAuthen(response: CheckAuthenticationUseCase.Response)
}

protocol ISplashViewController: AnyObject {
	func showAuthen(viewModel: CheckAuthenticationUseCase.ViewModel)
}

public struct SplashPresenter {
	weak var viewController: ISplashViewController?
}

extension SplashPresenter: ISplashPresenter {
	func presentAuthen(response: CheckAuthenticationUseCase.Response) {
		let viewModel = CheckAuthenticationUseCase.ViewModel(accessToken: response.accessToken)
		viewController?.showAuthen(viewModel: viewModel)
	}
}
