//
//  APIResourceQueryAdapter.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import UIKit

protocol IAPIResourceQueryAdapter {
	func getSamples() -> URLRequest
}

struct APIResourceQueryAdapter {
	var config: APIConfigurations
}

// MARK: - IAPIResourceQueryAdapter
extension APIResourceQueryAdapter: IAPIResourceQueryAdapter {
	func getSamples() -> URLRequest {
		let url = config.endpoint.appendingPathComponent("/samples")
		
		let request = URLRequest(url: url)
		return request
	}
}
