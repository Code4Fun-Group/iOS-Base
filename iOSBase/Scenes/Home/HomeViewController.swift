//
//  HomeViewController.swift
//  iOSBase
//
//  Created by NamNH on 21/09/2021.
//

import UIKit

class HomeViewController: UIViewController {
	// MARK: - Variables
	var interactor: IHomeInteractor!
	var router: IHomeRouter!
	
	// MARK: - Life cycles
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}

extension HomeViewController: IHomeViewController {
	
}
