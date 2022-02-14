import Foundation

protocol IPickerListInMemoryStore {
	var title: String { get }
	var items: [IPickerListItem] { get }
	var cellType: PickerListCellType { get }
}

struct PickerListInMemoryStore {
	var title: String
	var items: [IPickerListItem]
	var cellType: PickerListCellType
}

// MARK: - IPickerListInMemoryStore

extension PickerListInMemoryStore: IPickerListInMemoryStore {
	
}
