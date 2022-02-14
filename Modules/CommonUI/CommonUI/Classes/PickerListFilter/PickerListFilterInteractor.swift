//
//  PickerListFilterInteractor.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Foundation

protocol IPickerListFilterInteractor {
	func filter(request: FilterPickerListUseCase.Request)
}

struct PickerListFilterInteractor {
	var worker: IPickerListFilterWorker
	var presenter: IPickerListFilterPresenter
}

extension PickerListFilterInteractor: IPickerListFilterInteractor {
	func filter(request: FilterPickerListUseCase.Request) {
		guard let keyword = request.keyword, !keyword.isEmpty else {
			let response = FilterPickerListUseCase.Response(title: worker.title, items: worker.items, cellType: worker.cellType)
			presenter.presentFilter(response: response)
			return
		}
		
		let response = FilterPickerListUseCase.Response(title: worker.title, items: worker.items.filter({ $0.title.lowercased().contains(keyword.lowercased()) }), cellType: worker.cellType)
		presenter.presentFilter(response: response)
	}
}
