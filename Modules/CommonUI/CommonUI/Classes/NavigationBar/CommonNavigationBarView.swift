//
//  CommonNavigationBarView.swift
//  CommonUI
//
//  Created by NamNH on 03/11/2021.
//

import UIKit

private enum Constants {
	static let cornerRadius: CGFloat = 16.0
}
public protocol CommonNavigationBarViewDelegate: AnyObject {
	func backButtonTapped()
}

public class CommonNavigationBarView: UIView {
	// MARK: - Outlets
	@IBOutlet private weak var backView: UIView!
	@IBOutlet private weak var backButton: UIButton!
	
	// MARK: - Variables
	public weak var delegate: CommonNavigationBarViewDelegate?

	public override init(frame: CGRect) {
		super.init(frame: frame)
		loadNib()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		loadNib()
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
	}
	
	public func configureBackButton(image: UIImage) {
		backButton.setImage(image, for: [])
	}
}

// MARK: - Private
private extension CommonNavigationBarView {
	func loadNib() {
		let bundle = Bundle.commonUIBundle(for: CommonNavigationBarView.self)
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.translatesAutoresizingMaskIntoConstraints = true
		contentView.frame = bounds
		addSubview(contentView)
		self.layoutIfNeeded()
	}

	func setupUI() {
		backgroundColor = .clear
		backView.layer.cornerRadius = Constants.cornerRadius
		backButton.setImage(commonUIConfig.imageSet.backButton, for: [])
	}
}

// MARK: - Actions
private extension CommonNavigationBarView {
	@IBAction func backButtonTapped(_ sender: UIButton) {
		delegate?.backButtonTapped()
	}
}
