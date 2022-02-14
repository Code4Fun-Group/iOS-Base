import FloatingPanel
import ObjectiveC.runtime

private enum Constants {
	static let animationDuration: TimeInterval = 0.1
	static var kFloatingPanelControllerLayout = "kFloatingPanelControllerLayout"
	static var kPageSheetDelegate = "kPageSheetDelegate"
}

extension FloatingPanelController: IPageSheetController {
	var currentLayout: PageSheetStyle {
		get {
			(objc_getAssociatedObject(self, &Constants.kFloatingPanelControllerLayout) as? PageSheetStyle) ?? .modal
		}
		
		set {
			objc_setAssociatedObject(self, &Constants.kFloatingPanelControllerLayout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	public func showMovePageSheet(viewModel: MovePageSheetPosition.ViewModel) {
		switch viewModel.position {
		case .full:
			move(to: .full, animated: true)
			
		case .half:
			move(to: .half, animated: true)
			
		case .height(let height):
			let newLayout = CommonAdjustableHeightFloatingPanelLayout(appearance: PageSheetStyle.modal, height: height)
			layout = newLayout
			UIView.animate(withDuration: Constants.animationDuration) { self.invalidateLayout() }
			move(to: .half, animated: true)
		
		case .heightWithEmbedded(let height):
			let newLayout = CommonAdjustableHeightFloatingPanelLayout(appearance: PageSheetStyle.embedded, height: height)
			layout = newLayout
			UIView.animate(withDuration: Constants.animationDuration) { self.invalidateLayout() }
			move(to: .half, animated: true)
		
		case .tip:
			move(to: .tip, animated: true)
		}
	}
}

extension FloatingPanelController: FloatingPanelControllerDelegate {
	var pageSheetDelegate: IPageSheetContainerViewControllerDelegate? {
		get {
			(objc_getAssociatedObject(self, &Constants.kPageSheetDelegate) as? IPageSheetContainerViewControllerDelegate)
		}
		
		set {
			objc_setAssociatedObject(self, &Constants.kPageSheetDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	public func floatingPanelWillBeginDragging(_ fpc: FloatingPanelController) {
		pageSheetDelegate?.pageSheetWillBeginDragging()
	}
	
	public func floatingPanelDidEndDragging(_ fpc: FloatingPanelController, willAttract attract: Bool) {
		pageSheetDelegate?.pageSheetDidEndDragging()
	}
	
	public func floatingPanelDidMove(_ fpc: FloatingPanelController) {
		pageSheetDelegate?.pageSheetDidMove()
	}
}
