//
//  TabBarViewController.swift
//  epic_medical_ios
//
//  Created by NamNH on 03/11/2021.
//
import CommonUI
import Common
import UIKit

private enum Constants {
	static let badgeViewHorizontalTranslation: CGFloat = 0
	static let badgeViewScale: CGFloat = 2 / 3
	static let badgeViewFont: UIFont = TextStyle.textS.font
//	static let tabBarFrame: CGRect = CGRect(x: 0.0, y: UIScreen.main.bounds.height - 94.0, width: UIScreen.main.bounds.width, height: 94.0)
}

class TabBarViewController: UITabBarController {
	
	// MARK: - Variables
	var interactor: ITabBarInteractor!
	var router: ITabBarRouter!
	
	// MARK: Life cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
		getChildViewControllers(isForceReload: false)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}

// MARK: - Setup UI
private extension TabBarViewController {
	func setupUI() {
		delegate = self
		
		applayTabBarTheme()
		addObserver()
		updateTabBarItemAppearance()
	}
	
	func applayTabBarTheme() {
		UITabBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().backgroundImage = UIImage()
		UITabBar.appearance().clipsToBounds = true
		let bgView: UIImageView = UIImageView(image: UIImage(named: "tab-background"))
		bgView.frame = tabBar.bounds
		tabBar.addSubview(bgView)
		tabBar.sendSubviewToBack(bgView)
	}
	
	func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeNumber(_:)), name: .updateBadge, object: nil)
	}
}

// MARK: UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard let viewControllers = tabBarController.viewControllers else { return false }
		let selectedIndex = viewControllers.firstIndex(of: viewController) ?? tabBarController.selectedIndex
		select(at: selectedIndex)
		return false
	}
}

// MARK: Interactor
extension TabBarViewController {
	func select(at index: Int) {
		let request = SelectTabBarUseCase.Request(index: index)
		interactor.selectTabBarItem(request: request)
	}
	
	func getChildViewControllers(isForceReload: Bool) {
		let request = GetChildViewControllerUseCase.Request(isForceReload: isForceReload)
		interactor.getChildViewControllers(request: request)
	}
}

// MARK: ITabBarViewController
extension TabBarViewController: ITabBarViewController {
	func showViewControllers(viewModel: GetChildViewControllerUseCase.ViewModel) {
		viewControllers = viewModel.viewControllers
	}
	
	func showCurrentViewController(viewModel: SelectTabBarUseCase.ViewModel) {
		selectedIndex = viewModel.index
	}
	
	func showTabBarBadgeView(viewModel: PresentTabBarBadgeViewUseCase.ViewModel) {
		updateBadgeViewAppearance()
	}
}

// MARK: - Private
private extension TabBarViewController {
	func updateBadgeViewAppearance() {
		for tabBarButton in self.tabBar.subviews {
			for badgeView in tabBarButton.subviews {
				let className = NSStringFromClass(badgeView.classForCoder)
				if className == "_UIBadgeView" {
					badgeView.layer.transform = CATransform3DIdentity
					badgeView.layer.transform = CATransform3DMakeTranslation(Constants.badgeViewHorizontalTranslation, Constants.badgeViewHorizontalTranslation, 1)
					badgeView.layer.transform = CATransform3DMakeScale(Constants.badgeViewScale, Constants.badgeViewScale, 1)
					badgeView.clipsToBounds = true
				}
			}
		}
	}
	
	func updateTabBarItemAppearance() {
		UITabBarItem.appearance().badgeColor = DependencyResolver.shared.colorSet.red600
		UITabBarItem.appearance().setBadgeTextAttributes([.font: Constants.badgeViewFont, .foregroundColor: UIColor.white], for: .normal)
	}
}

// MARK: - Actions
private extension TabBarViewController {
	@objc func updateBadgeNumber(_ notification: NSNotification) {
		let request = PresentTabBarBadgeViewUseCase.Request()
		interactor?.presentTabBarBadgeView(request: request)
	}
}
