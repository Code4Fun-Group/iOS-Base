import Foundation

public protocol PickerListDelegate: AnyObject {
	func pickerDidSelectAt(index: Int, item: IPickerListItem)
}
