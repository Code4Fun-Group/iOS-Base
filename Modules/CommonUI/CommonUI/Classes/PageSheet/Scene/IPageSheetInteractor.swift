import Foundation

public protocol IPageSheetInteractor {
	var pageSheetPresenter: IPageSheetPresenter? { get }
	
	func movePageSheet(request: MovePageSheetPosition.Request)
}
