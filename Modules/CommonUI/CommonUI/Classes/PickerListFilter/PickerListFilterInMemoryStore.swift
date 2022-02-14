//
//  PickerListFilterInMemoryStore.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Foundation

protocol IPickerListFilterInMemoryStore {
	var title: String { get }
	var items: [IPickerListItem] { get }
	var cellType: PickerListCellType { get }
}

struct PickerListFilterInMemoryStore {
	var title: String
	var items: [IPickerListItem]
	var cellType: PickerListCellType
}

extension PickerListFilterInMemoryStore: IPickerListFilterInMemoryStore {
	
}
