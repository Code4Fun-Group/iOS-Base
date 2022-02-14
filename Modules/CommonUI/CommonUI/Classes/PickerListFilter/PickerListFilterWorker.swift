//
//  PickerListFilterWorker.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Foundation

protocol IPickerListFilterWorker {
	var title: String { get }
	var items: [IPickerListItem] { get }
	var cellType: PickerListCellType { get }
}

struct PickerListFilterWorker {
	let inMemoryStore: IPickerListFilterInMemoryStore
}

extension PickerListFilterWorker: IPickerListFilterWorker {
	var title: String {
		inMemoryStore.title
	}
	
	var items: [IPickerListItem] {
		inMemoryStore.items
	}
	
	var cellType: PickerListCellType {
		inMemoryStore.cellType
	}
}
