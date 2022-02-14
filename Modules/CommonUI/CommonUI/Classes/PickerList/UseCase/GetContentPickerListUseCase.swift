import Foundation

enum GetContentPickerListUseCase {
	struct Request {
		
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
