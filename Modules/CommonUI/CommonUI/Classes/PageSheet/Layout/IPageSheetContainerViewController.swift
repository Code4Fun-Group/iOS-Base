import UIKit

public protocol IPageSheetContainerViewController: AnyObject {
	var pageSheetTrackingScrollView: UIView? { get }
	var pageSheetController: IPageSheetController? { get set }
	var pageSheetContentView: UIView? { get }
	var isDragDismiss: Bool { get }
}

public extension IPageSheetContainerViewController {
	var isDragDismiss: Bool { true }
}

public protocol IPageSheetContainerViewControllerDelegate: AnyObject {
	func pageSheetWillBeginDragging()
	func pageSheetDidEndDragging()
	func pageSheetDidMove()
}

@objc public protocol IPageSheetAlertViewControllerDelegate: AnyObject {
	var isAllowedDismiss: Bool { get }
	
	func pageSheetDidDismiss()
}
