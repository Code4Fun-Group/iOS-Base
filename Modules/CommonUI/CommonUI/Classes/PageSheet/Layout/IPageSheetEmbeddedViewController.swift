import FloatingPanel

public protocol IPageSheetEmbeddedViewController: AnyObject {
	var pageSheetController: IPageSheetController? { get set }
	var pageSheetModalViewController: IPageSheetContainerViewController? { get }
	
	func willPreparePageSheet()
}

// MARK: - Default

public extension IPageSheetEmbeddedViewController where Self: UIViewController {
	func preparePageSheet() {
		guard let modalViewController = pageSheetModalViewController as? UIViewController else { return }
		let appearance = PageSheetStyle.embedded
		
		let pageSheetVC = FloatingPanelController()
		pageSheetVC.layout = CommonEmbeddedFloatingPanelLayout(appearance: appearance)
		pageSheetVC.set(contentViewController: modalViewController)
		
		let pageAppearance = SurfaceAppearance()
		let shadow = SurfaceAppearance.Shadow()
		pageAppearance.shadows = [shadow]
		pageAppearance.cornerRadius = appearance.surfaceCornerRadius
		pageAppearance.backgroundColor = appearance.surfaceBackgroundColor
		
		pageSheetVC.surfaceView.grabberAreaOffset = appearance.grabberAreaOffset
		pageSheetVC.surfaceView.appearance = pageAppearance
		
		pageSheetVC.contentMode = .fitToBounds
		pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = appearance.dismissTapGestureEnabled
		pageSheetVC.backdropView.backgroundColor = appearance.backdropColor
		
		pageSheetVC.set(contentViewController: modalViewController)
		pageSheetVC.addPanel(toParent: self)
		
		if let modalScrollView = pageSheetModalViewController?.pageSheetTrackingScrollView as? UIScrollView {
			pageSheetVC.track(scrollView: modalScrollView)
		}
		
		if var parentController = self as? IPageSheetContainerViewController {
			parentController.pageSheetController = pageSheetVC
			pageSheetModalViewController?.pageSheetController = pageSheetVC
		}
		
		if let delegator = pageSheetModalViewController as? IPageSheetContainerViewControllerDelegate {
			pageSheetVC.delegate = pageSheetVC
			pageSheetVC.pageSheetDelegate = delegator
		}
	}
}
