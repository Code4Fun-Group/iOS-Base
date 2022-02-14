//
//  PickerListRadioViewCell.swift
//  CommonUI
//
//  Created by NamNH on 29/11/2021.
//

import UIKit

class PickerListRadioViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: CommonLabel!
	@IBOutlet weak var iconImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
		setAccessibilityIdentifier()
	}
	
	func configure(item: IPickerListItem?) {
		titleLabel.text = item?.title
		titleLabel.textColor = item?.isHighlighted ?? false ? commonUIConfig.colorSet.blue700 : commonUIConfig.colorSet.neutral600
		let image = item?.isHighlighted ?? false ? commonUIConfig.imageSet.radioSelectedIcon : commonUIConfig.imageSet.radioNonSelectedIcon
		iconImageView.image = image
	}
}

// MARK: - Private

extension PickerListRadioViewCell {
	
	func setupUI() {
		backgroundColor = .clear
		titleLabel.textStyle = .textL
		titleLabel.textAlignment = .left
		titleLabel.textColor = commonUIConfig.colorSet.neutral600
		titleLabel.highlightedTextColor = commonUIConfig.colorSet.blue700
	}
	
	func setAccessibilityIdentifier() {
		titleLabel.accessibilityIdentifier = "lbl_title_pickerlistradioviewcell"
		iconImageView.accessibilityIdentifier = "imgview_icon_pickerlistradioviewcell"
	}
}
