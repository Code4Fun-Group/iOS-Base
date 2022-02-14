import Foundation

public protocol IPickerListItem {
	var id: String { get }
	var title: String { get }
	var subTitle: String? { get }
	var image: UIImage? { get }
	var radioNonSelectedRadio: UIImage? { get }
	var radioSelectedImage: UIImage? { get }
	var isHighlighted: Bool { get }
}

// MARK: - IPickerListItem

public extension IPickerListItem {
	var image: UIImage? {
		nil
	}
	
	var radioNonSelectedRadio: UIImage? { nil }
	var radioSelectedImage: UIImage? { nil }
}
