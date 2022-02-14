//
//  CommonBannerCell.swift
//  CommonUI
//
//  Created by Nguyễn Nam on 7/30/21.
//

import UIKit

public class CommonBannerCell: UICollectionViewCell {

	public lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	public func configure(imageURLStr: String?) {
		if let url = URL(string: imageURLStr ?? "") {
			imageView.load(url: url)
		} else {
			imageView.image = nil
		}
	}
	
	public func configure(image: UIImage?) {
		imageView.image = image
	}
}

private extension CommonBannerCell {
	func commonInit() {
		addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
