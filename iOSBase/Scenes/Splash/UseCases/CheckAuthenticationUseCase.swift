//
//  CheckAuthenticationUseCase.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import UIKit

enum CheckAuthenticationUseCase {
	struct Request {}
	
	struct Response {
		var accessToken: String?
	}
	
	struct ViewModel {
		var accessToken: String?
	}
}
