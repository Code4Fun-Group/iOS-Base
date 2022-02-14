//
//  SplashInteractor.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Foundation

protocol ISplashInteractor {
	func checkAuthen(request: CheckAuthenticationUseCase.Request)
}

public struct SplashInteractor {
	var worker: ISplashWorker
	var presenter: ISplashPresenter
}

extension SplashInteractor: ISplashInteractor {
	func checkAuthen(request: CheckAuthenticationUseCase.Request) {
		let response = CheckAuthenticationUseCase.Response(accessToken: worker.accessToken)
		presenter.presentAuthen(response: response)
	}
}
