import Foundation

protocol IPickerListWorker {
	var title: String { get }
	var items: [IPickerListItem] { get }
	var cellType: PickerListCellType { get }
}

struct PickerListWorker {
	let inMemoryStore: IPickerListInMemoryStore
	
	init(inMemoryStore: IPickerListInMemoryStore) {
		self.inMemoryStore = inMemoryStore
	}
}

// MARK: - IPickerListWorker
extension PickerListWorker: IPickerListWorker {
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
