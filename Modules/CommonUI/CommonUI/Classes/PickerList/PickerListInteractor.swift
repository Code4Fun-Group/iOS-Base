import Foundation

protocol IPickerListInteractor {
	func getContent(request: GetContentPickerListUseCase.Request)
}

struct PickerListInteractor {
	
	let presenter: IPickerListPresenter
	let worker: IPickerListWorker
	
	init(presenter: IPickerListPresenter, worker: IPickerListWorker) {
		self.presenter = presenter
		self.worker = worker
	}
}

// MARK: - IPickerListInteractor

extension PickerListInteractor: IPickerListInteractor {
	
	func getContent(request: GetContentPickerListUseCase.Request) {
		let response = GetContentPickerListUseCase.Response(title: worker.title,
															items: worker.items,
															cellType: worker.cellType)
		presenter.presentContent(response: response)
	}
}
