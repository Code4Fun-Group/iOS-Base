import Common

private enum Constants {
	static let moduleName = "pickerList"
	static let storyboardName = "PickerList"
	static let identifier = "PickerListViewController"
}

protocol IPickerListAssembly: IAssembly {
	
}

public struct PickerListAssembly {
	public let module = Module(name: Constants.moduleName)
	
	public init() { }
}

extension PickerListAssembly: IPickerListAssembly {
	public func build(with parameters: [String: Any]?) throws -> UIViewController {
		let bundle = Bundle.commonUIBundle(for: PickerListViewController.self)
		let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: bundle)

		guard let viewController = storyboard.instantiateViewController(withIdentifier: Constants.identifier) as? PickerListViewController else {
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
		
		let delegate = parameters?["delegate"] as? PickerListDelegate
			
		let inMemoryStore = PickerListInMemoryStore(title: title, items: items, cellType: cellType)
		let worker = PickerListWorker(inMemoryStore: inMemoryStore)
		
		let presenter = PickerListPresenter(viewController: viewController)
		let interactor = PickerListInteractor(presenter: presenter, worker: worker)

		viewController.interactor = interactor
		viewController.delegate = delegate

		return viewController
	}
}
