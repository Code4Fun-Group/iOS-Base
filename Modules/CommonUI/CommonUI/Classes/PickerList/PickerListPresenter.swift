import Foundation

protocol IPickerListPresenter {
	func presentContent(response: GetContentPickerListUseCase.Response)
}

struct PickerListPresenter {
	weak var viewController: IPickerListViewController?
	
	init(viewController: IPickerListViewController) {
		self.viewController = viewController
	}
}

// MARK: - IPickerListPresenter

extension PickerListPresenter: IPickerListPresenter {
	
	func presentContent(response: GetContentPickerListUseCase.Response) {
		let viewModel = GetContentPickerListUseCase.ViewModel(title: response.title,
															  items: response.items,
															  cellType: response.cellType)
		viewController?.showContent(viewModel: viewModel)
	}
}
