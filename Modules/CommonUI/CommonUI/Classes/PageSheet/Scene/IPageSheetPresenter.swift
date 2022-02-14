import Foundation

public protocol IPageSheetPresenter {
	var pageSheetController: IPageSheetController? { get }
	
	func presentMovePageSheet(response: MovePageSheetPosition.Response)
}
