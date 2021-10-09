//
//  DependencyResolver.swift
//  iOSBase
//
//  Created by NamNH on 04/10/2021.
//

import Networking

class DependencyResolver {
	// MARK: - Singleton
	static let shared = DependencyResolver()
	
	// MARK: - API Service
	var apiService: IAPIService
	
	// MARK: - Init
	private init() {
		let networkingService = NetworkingService(configurations: NetworkConfigurations(),
												  httpHeaderHandler: NetworkHTTPHeaderHandler(),
												  responseHandler: NetworkHTTPResponseHandler(),
												  networkConnectionHandler: NetworkConnectionHandler())
		
		let apiConfig = APIConfigurations()
		let queryAdapter = APIResourceQueryAdapter(config: apiConfig)
		let responseAdapter = APIResourceResponseAdapter(jsonHandler: JSONDataHandler())
		
		apiService = APIService(client: networkingService,
								query: queryAdapter,
								resourceHandler: responseAdapter)
	}
}
