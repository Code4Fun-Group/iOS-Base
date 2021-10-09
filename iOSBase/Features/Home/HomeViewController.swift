//
//  HomeViewController.swift
//  iOSBase
//
//  Created by NamNH on 21/09/2021.
//

import UIKit

class HomeViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		DependencyResolver.shared.apiService.getSamples { result in
			switch result {
			case .success(let datas):
				print(datas)
			case .failure(let error):
				print(error)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}
