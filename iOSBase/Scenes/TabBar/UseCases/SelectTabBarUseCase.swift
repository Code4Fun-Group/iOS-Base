//
//  SelectTabBarUseCase.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//

import UIKit

enum SelectTabBarUseCase {
	struct Request {
		var index: Int
	}
	
	struct Response {
		var index: Int
	}
	
	struct ViewModel {
		var index: Int
	}
}
