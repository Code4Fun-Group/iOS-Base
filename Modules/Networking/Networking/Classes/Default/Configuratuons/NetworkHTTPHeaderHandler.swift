//
//  NetworkHTTPHeaderHandler.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public struct NetworkHTTPHeaderHandler {
	let config: INetworkConfigurations
	
	public init(config: INetworkConfigurations) {
		self.config = config
	}
}

extension NetworkHTTPHeaderHandler: INetworkHTTPHeaderHandler {
	public func construct(from request: URLRequest, configurations: INetworkConfigurations) -> [String: String]? {
		let customFields = request.allHTTPHeaderFields ?? [:]
		
		let headerFields = configurations.defaultHTTPHeaderFields.merging(customFields) { (_, new) -> String in
			return new
		}
		
		return headerFields
	}
}
