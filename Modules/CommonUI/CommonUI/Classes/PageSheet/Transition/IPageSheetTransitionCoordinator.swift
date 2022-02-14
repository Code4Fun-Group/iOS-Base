import UIKit
import FloatingPanel

public protocol IPageSheetTransitionCoordinator {
	func presentPageSheetAlert(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
	func presentPageSheetContainer(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
	func presentDismissablePageSheetContainer(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
	func presentPageSheetEmbedded(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
	func presentPageSheetDialogue(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

// MARK: - IPageSheetTransitionCoordinator

public extension IPageSheetTransitionCoordinator {
	func presentPageSheetAlert(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		let appearance: PageSheetStyle = .alert
		
		let pageSheetVC = FloatingPanelController()
		pageSheetVC.layout = CommonIntrinsicFloatingPanelLayout(appearance: appearance)
		pageSheetVC.set(contentViewController: modalViewController)
		
		pageSheetVC.contentMode = .fitToBounds
		pageSheetVC.isRemovalInteractionEnabled = false
		
		pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = appearance.dismissTapGestureEnabled
		pageSheetVC.backdropView.backgroundColor = appearance.backdropColor
		
		pageSheetVC.surfaceView.backgroundColor = appearance.surfaceBackgroundColor
		pageSheetVC.surfaceView.grabberAreaOffset = appearance.grabberAreaOffset
		pageSheetVC.surfaceView.grabberHandle.isHidden = true
		pageSheetVC.surfaceView.gestureRecognizers?.removeAll()
		
		pageSheetVC.panGestureRecognizer.isEnabled = appearance.panGestureRecognizerEnabled
		
		if let modalVC = contentViewController(modalViewController) as? IPageSheetAlertViewControllerDelegate {
			if modalVC.isAllowedDismiss {
				pageSheetVC.backdropView.gestureRecognizers?.removeAll()
				let gesture = UITapGestureRecognizer(target: modalVC, action: #selector(IPageSheetAlertViewControllerDelegate.pageSheetDidDismiss))
				pageSheetVC.backdropView.addGestureRecognizer(gesture)
				
			} else {
				pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = false
			}
		}
		presentPageSheet(pageSheetVC: pageSheetVC, on: parentViewController, animated: animated, completion: completion)
	}
	
	func presentPageSheetContainer(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		let appearance: PageSheetStyle = .modal
		
		let pageSheetVC = FloatingPanelController()
		pageSheetVC.layout = CommonFloatingPanelLayout(appearance: appearance)
		pageSheetVC.set(contentViewController: modalViewController)
		
		pageSheetVC.surfaceView.backgroundColor = appearance.surfaceBackgroundColor
		pageSheetVC.surfaceView.grabberAreaOffset = appearance.grabberAreaOffset
		
		pageSheetVC.contentMode = .fitToBounds
		pageSheetVC.isRemovalInteractionEnabled = true
		
		pageSheetVC.backdropView.dismissalTapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
		pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = appearance.dismissTapGestureEnabled
		pageSheetVC.backdropView.backgroundColor = appearance.backdropColor
		
		if let modalVC = contentViewController(modalViewController) as? IPageSheetContainerViewController {
			modalVC.pageSheetController = pageSheetVC
			pageSheetVC.isRemovalInteractionEnabled = modalVC.isDragDismiss
			if !modalVC.isDragDismiss {
				pageSheetVC.surfaceView.gestureRecognizers?.removeAll()
				pageSheetVC.surfaceView.grabberHandle.isHidden = true
			}
			if let scrollView = modalVC.pageSheetTrackingScrollView as? UIScrollView {
				pageSheetVC.track(scrollView: scrollView)
			}
		}
		
		presentPageSheet(pageSheetVC: pageSheetVC, on: parentViewController, animated: animated, completion: completion)
	}
	
	func presentDismissablePageSheetContainer(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		let appearance: PageSheetStyle = .dismissableModal
		
		let pageSheetVC = FloatingPanelController()
		pageSheetVC.layout = CommonFloatingPanelLayout(appearance: appearance)
		pageSheetVC.set(contentViewController: modalViewController)
		
		pageSheetVC.surfaceView.backgroundColor = appearance.surfaceBackgroundColor
		pageSheetVC.surfaceView.grabberAreaOffset = appearance.grabberAreaOffset
		
		pageSheetVC.contentMode = .fitToBounds
		pageSheetVC.isRemovalInteractionEnabled = true
		
		pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = appearance.dismissTapGestureEnabled
		pageSheetVC.backdropView.backgroundColor = appearance.backdropColor
		
		if let modalVC = contentViewController(modalViewController) as? IPageSheetContainerViewController {
			modalVC.pageSheetController = pageSheetVC
			
			if let scrollView = modalVC.pageSheetTrackingScrollView as? UIScrollView {
				pageSheetVC.track(scrollView: scrollView)
			}
		}
		
		presentPageSheet(pageSheetVC: pageSheetVC, on: parentViewController, animated: animated, completion: completion)
	}
	
	func presentPageSheetEmbedded(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		if let pageSheetVC = modalViewController as? IPageSheetEmbeddedViewController {
			pageSheetVC.willPreparePageSheet()
		}
		
		presentPageSheet(pageSheetVC: modalViewController, on: parentViewController, animated: animated, completion: completion)
	}
	
	func presentPageSheetDialogue(modalViewController: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		let appearance: PageSheetStyle = .dialogue
		
		let pageSheetVC = FloatingPanelController()
		pageSheetVC.layout = CommonIntrinsicFloatingPanelLayout(appearance: appearance)
		pageSheetVC.set(contentViewController: modalViewController)
		
		pageSheetVC.contentMode = .static
		pageSheetVC.isRemovalInteractionEnabled = false
		
		pageSheetVC.backdropView.dismissalTapGestureRecognizer.isEnabled = appearance.dismissTapGestureEnabled
		pageSheetVC.backdropView.backgroundColor = appearance.backdropColor
		
		pageSheetVC.surfaceView.backgroundColor = appearance.surfaceBackgroundColor
		pageSheetVC.surfaceView.grabberAreaOffset = appearance.grabberAreaOffset
		pageSheetVC.surfaceView.grabberHandle.isHidden = true
		pageSheetVC.surfaceView.gestureRecognizers?.removeAll()
		
		pageSheetVC.panGestureRecognizer.isEnabled = appearance.panGestureRecognizerEnabled
		
		if var modalVC = modalViewController as? IPageSheetPresentationStyle {
			modalVC.pageSheetStyle = appearance
		}
		if let modalVC = contentViewController(modalViewController) as? IPageSheetContainerViewController {
			modalVC.pageSheetController = pageSheetVC
		}
		
		presentPageSheet(pageSheetVC: pageSheetVC, on: parentViewController, animated: animated, completion: completion)
	}
}

// MARK: - Private

private extension IPageSheetTransitionCoordinator {
	func presentPageSheet(pageSheetVC: UIViewController, on parentViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		parentViewController.present(pageSheetVC, animated: animated, completion: completion)
	}
}

// MARK: - IApplicationTransitionCoordinator

public extension IPageSheetTransitionCoordinator {
	func childViewControllerFromPageSheet(_ fromViewController: UIViewController) -> UIViewController? {
		if let pageSheet = fromViewController as? FloatingPanelController {
			if let contentViewController = pageSheet.contentViewController {
				return contentViewController
			}
		}
		
		return nil
	}
	
	func contentViewController(_ fromViewController: UIViewController) -> UIViewController {
		if let tabBar = fromViewController as? UITabBarController {
			if let selectedViewController = tabBar.selectedViewController {
				return contentViewController(selectedViewController)
			}
		}
		
		if let navigationController = fromViewController as? UINavigationController {
			if let lastViewController = navigationController.viewControllers.last {
				return contentViewController(lastViewController)
			}
		}
		
		if let modalViewController = fromViewController.presentedViewController {
			return contentViewController(modalViewController)
		}
		
		if let pageSheet = childViewControllerFromPageSheet(fromViewController) {
			return contentViewController(pageSheet)
		}
		
		fromViewController.loadViewIfNeeded()
		return fromViewController
	}
}
