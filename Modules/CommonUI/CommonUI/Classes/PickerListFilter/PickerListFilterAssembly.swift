//
//  PickerListFilterAssembly.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Common

private enum Constants {
	static let moduleName = "PickerListFilter"
	static let storyboardName = "PickerListFilter"
	static let identifier = "PickerListFilterViewController"
}

public protocol IPickerListFilterAssembly: IAssembly {
}

public struct PickerListFilterAssembly: IPickerListFilterAssembly {
	public let module = Module(name: Constants.moduleName)
	
	public init() {}
}

public extension PickerListFilterAssembly {
	func build(with parameters: [String: Any]?) throws -> UIViewController {
		let bundle = Bundle.commonUIBundle(for: PickerListFilterViewController.self)
		let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: bundle)
		guard let viewController = storyboard.instantiateViewController(withIdentifier: Constants.identifier) as? PickerListFilterViewController else {
			throw AssemblyError.moduleNotFound
		}
		
		guard let title = parameters?["title"] as? String else {
			throw AssemblyError.parameterNotFound
		}
		
		guard let items = parameters?["items"] as? [IPickerListItem] else {
			throw AssemblyError.parameterNotFound
		}
		
		let cellTypeValue = parameters?["cellType"] as? String
		guard let cellType = PickerListCellType(rawValue: cellTypeValue ?? "") else {
			throw AssemblyError.parameterNotFound
		}
		
		let delegate = parameters?["delegate"] as? PickerListFilterDelegate
		
		let inMemoryStore = PickerListFilterInMemoryStore(title: title, items: items, cellType: cellType)
		let worker = PickerListFilterWorker(inMemoryStore: inMemoryStore)
		let presenter = PickerListFilterPresenter(viewController: viewController)
		let interactor = PickerListFilterInteractor(worker: worker, presenter: presenter)
		viewController.interactor = interactor
		viewController.delegate = delegate
		viewController.items = items
		
		return viewController
	}
}
