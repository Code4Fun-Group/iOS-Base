//
//  HomeWorker.swift
//  iOSBase
//
//  Created by NamNH on 12/02/2022.
//

import Foundation

protocol IHomeWorker {
	
}

struct HomeWorker {
	let remoteStore: IHomeRemoteStore
}

extension HomeWorker: IHomeWorker {
	
}
