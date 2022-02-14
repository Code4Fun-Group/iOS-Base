//
//  PickerListFilterPresenter.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Foundation

protocol IPickerListFilterPresenter {
	func presentFilter(response: FilterPickerListUseCase.Response)
}

protocol IPickerListFilterViewController: AnyObject {
	func showFilter(viewModel: FilterPickerListUseCase.ViewModel)
}

struct PickerListFilterPresenter {
	weak var viewController: IPickerListFilterViewController?
}

extension PickerListFilterPresenter: IPickerListFilterPresenter {
	func presentFilter(response: FilterPickerListUseCase.Response) {
		let viewModel = FilterPickerListUseCase.ViewModel(title: response.title,
														  items: response.items,
														  cellType: response.cellType)
		viewController?.showFilter(viewModel: viewModel)
	}
}
