import UIKit

public protocol IPageSheetController: UIViewController {
	func showMovePageSheet(viewModel: MovePageSheetPosition.ViewModel)
}
