//
//  LoadingView.swift
//  CommonUI
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

public protocol ILoadingViewAppearance {
	var backgroundColor: UIColor { get }
	var backgroundAlpha: CGFloat { get }
	var loadingColor: UIColor { get }
	var centerContainerBackgroundColor: UIColor { get }
	var centerContainerCornerRadius: CGFloat { get }
}

public enum LoadingViewAppearance: ILoadingViewAppearance {
	case `default`
	case dark
	case containerRounded
	
	public var backgroundColor: UIColor {
		switch self {
		case .default: return UIColor.white
		case .dark: return UIColor.black
		case .containerRounded: return UIColor.clear
		}
	}
	
	public var loadingColor: UIColor {
		switch self {
		case .default: return UIColor.lightGray
		case .dark: return UIColor.white
		case .containerRounded: return UIColor.white
		}
	}
	
	public var backgroundAlpha: CGFloat {
		switch self {
		case .default: return 0.3
		case .dark: return 0.3
		case .containerRounded: return 1
		}
	}
	
	public var centerContainerBackgroundColor: UIColor {
		switch self {
		case .default: return .clear
		case .dark: return .clear
		case .containerRounded: return UIColor(white: 0, alpha: 0.7)
		}
	}
	
	public var centerContainerCornerRadius: CGFloat {
		switch self {
		case .default: return 0
		case .dark: return 0
		case .containerRounded: return 24.0
		}
	}

}

public protocol ILoadingView {
	func show()
	func hide()
}

public class LoadingView: UIView {
	public var backgroundView = UIView()
	public var centerContainerView = UIView()
	public var loadingIndicatorView: UIActivityIndicatorView?
	public var appearance = LoadingViewAppearance.default { didSet { updateAppearance() } }

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
	}
	
	// MARK: - View Lifecycle
	public override func layoutSubviews() {
		super.layoutSubviews()
		
	}
	
	// MARK: - Appearance
	func updateAppearance() {
		backgroundView.backgroundColor = appearance.backgroundColor
		backgroundView.alpha = appearance.backgroundAlpha
		loadingIndicatorView?.color = appearance.loadingColor
		centerContainerView.backgroundColor = appearance.centerContainerBackgroundColor
		centerContainerView.layer.cornerRadius = appearance.centerContainerCornerRadius
	}
}

// MARK: - Private
private extension LoadingView {
	func setupUI() {
		clipsToBounds = false
		
		setupBackgroundView()
		setupCenterContainerView()
		setupLoadingIndicatorView()
		updateAppearance()
		setAccessibilityIdentifier()
		
		backgroundColor = .clear
		isUserInteractionEnabled = true
		isHidden = true
	}
	
	func setupBackgroundView() {
		backgroundView.fitInView(self)
		backgroundView.isUserInteractionEnabled = false
	}
	
	func setupCenterContainerView() {
		centerContainerView.centerInView(backgroundView, size: CGSize(width: 128, height: 128))
		centerContainerView.isUserInteractionEnabled = false
	}
	
	func setupLoadingIndicatorView() {
		if #available(iOS 13.0, *) {
			loadingIndicatorView = UIActivityIndicatorView(style: .large)
		} else {
			loadingIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
		}
		
		guard let loadingIndicatorView = loadingIndicatorView else {
			return
		}
		loadingIndicatorView.centerInView(centerContainerView, size: loadingIndicatorView.frame.size)
		bringSubviewToFront(loadingIndicatorView)
	}
	
	func setAccessibilityIdentifier() {
		backgroundView.accessibilityIdentifier = "view_background_loadingview"
		centerContainerView.accessibilityIdentifier = "view_centercontainer_loadingview"
		loadingIndicatorView?.accessibilityIdentifier = "activityindicator_loading_loadingview"
	}
}

// MARK: - ILoadingView
extension LoadingView: ILoadingView {
	public func show() {
		isHidden = false
		loadingIndicatorView?.startAnimating()
	}
	
	public func hide() {
		isHidden = true
		loadingIndicatorView?.stopAnimating()
	}
}
