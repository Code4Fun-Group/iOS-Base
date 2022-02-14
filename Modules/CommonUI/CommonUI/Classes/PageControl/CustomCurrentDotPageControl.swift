//
//  CustomCurrentDotPageControl.swift
//  CommonUI
//

import UIKit

open class CustomCurrentDotPageControl: UIControl {
	
	// MARK: - Properties
	
	@IBInspectable public var pageIndicatorTintColor: UIColor? = .lightGray
	@IBInspectable public var currentPageIndicatorTintColor: UIColor? = .darkGray
	@IBInspectable public var hidesForSinglePage: Bool = true
	@IBInspectable public var currentDotWidth: CGFloat = 12.0
	
	private var dotsWidthConstraints: [NSLayoutConstraint] = []
	private lazy var stackView = UIStackView(frame: bounds)
	
	private var numberOfDots: [UIView] = [] {
		didSet {
			if numberOfDots.count == numberOfPages {
				setupViews()
			}
		}
	}
	
	public var numberOfPages: Int = 0 {
		didSet {
			numberOfDots.removeAll()
			stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
			dotsWidthConstraints.removeAll()
			for tag in 0..<numberOfPages {
				let dot: UIView = getDotView()
				dot.tag = tag
				setupDotAppearance(dot)
				numberOfDots.append(dot)
			}
		}
	}
	
	public var currentPage: Int = 0 {
		didSet {
			updateSelectedDotAppearance(at: currentPage)
		}
	}
	
	// MARK: - Intialisers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

// MARK: - Private

private extension CustomCurrentDotPageControl {
	func setupViews() {
		setupStackView()
		dotsWidthConstraints.removeAll()
		numberOfDots.forEach { dot in
			self.stackView.addArrangedSubview(dot)
			self.addConstraints([
				dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
				dot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.45, constant: 0)
			])
			let dotWidthConstraint: NSLayoutConstraint = dot.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.45, constant: 0)
			dotsWidthConstraints.append(dotWidthConstraint)
			dotWidthConstraint.isActive = true
		}
		stackView.layoutIfNeeded()
		stackView.isHidden = (hidesForSinglePage) ? numberOfDots.count == 1 : false
	}
	
	func updateSelectedDotAppearance(at selectedIndex: Int) {
		numberOfDots.enumerated().forEach { index, dot in
			setupDotAppearance(dot)
			if index == selectedIndex {
				self.dotsWidthConstraints[index].constant = currentDotWidth
				dot.backgroundColor = self.currentPageIndicatorTintColor
			} else {
				self.dotsWidthConstraints[index].constant = 0
			}
		}
	}
	
	func getDotView() -> UIView {
		let dotView: UIView = UIView()
		setupDotAppearance(dotView)
		return dotView
	}
	
	func setupDotAppearance(_ dotView: UIView) {
		dotView.transform = .identity
		dotView.layer.cornerRadius = dotView.bounds.height / 2
		dotView.layer.masksToBounds = true
		dotView.backgroundColor = pageIndicatorTintColor
	}
	
	func setupStackView() {
		stackView.alignment = .center
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.spacing = 8
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		addConstraints([
			stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
			stackView.heightAnchor.constraint(equalTo: heightAnchor)
		])
	}
}
