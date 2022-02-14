//
//  GetChildViewControllerUseCase.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import UIKit

class GetChildViewControllerUseCase: NSObject {
	struct Request {
		var isForceReload: Bool
	}
	
	struct Response {
		var pages: [ITabBarPageModel]
	}
	
	struct ViewModel {
		var viewControllers: [UIViewController]
	}
}
