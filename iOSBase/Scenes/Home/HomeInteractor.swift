//
//  HomeInteractor.swift
//  iOSBase
//
//  Created by NamNH on 12/02/2022.
//

import Foundation

protocol IHomeInteractor {
}

struct HomeInteractor {
	var worker: IHomeWorker
	var presenter: IHomePresenter
}

extension HomeInteractor: IHomeInteractor {
	
}
