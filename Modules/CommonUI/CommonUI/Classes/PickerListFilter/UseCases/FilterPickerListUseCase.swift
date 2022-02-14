//
//  FilterPickerListUseCase.swift
//  CommonUI
//
//  Created by NamNH on 29/11/2021.
//

import UIKit

enum FilterPickerListUseCase {
	struct Request {
		var keyword: String?
	}
	
	struct Response {
		var title: String
		var items: [IPickerListItem]
		var cellType: PickerListCellType
	}
	
	struct ViewModel {
		var title: String
		var items: [IPickerListItem]
		var cellType: PickerListCellType
	}
}
