//
//  HomePresenter.swift
//  iOSBase
//
//  Created by NamNH on 12/02/2022.
//

import Foundation

protocol IHomePresenter {
}

protocol IHomeViewController: AnyObject {
}

struct HomePresenter {
	weak var viewController: IHomeViewController?
}

extension HomePresenter: IHomePresenter {
	
}
