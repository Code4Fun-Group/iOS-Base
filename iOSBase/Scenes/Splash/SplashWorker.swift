//
//  SplashWorker.swift
//  epic_medical_ios
//
//  Created by NamNH on 02/11/2021.
//

import Foundation

protocol ISplashWorker {
	var accessToken: String? { get }
}

public struct SplashWorker {
	let remoteStore: ISplashRemoteStore
	let tokenService: IAppTokenService
}

extension SplashWorker: ISplashWorker {
	var accessToken: String? {
		tokenService.accessToken
	}
}
