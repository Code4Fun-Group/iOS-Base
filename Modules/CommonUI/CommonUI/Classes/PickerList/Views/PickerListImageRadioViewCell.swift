//
//  PickerListImageRadioViewCell.swift
//  CommonUI
//
//  Created by NamNH on 01/12/2021.
//

import UIKit

class PickerListImageRadioViewCell: UITableViewCell {
	
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: CommonLabel!
	@IBOutlet weak var iconRadioImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
		setAccessibilityIdentifier()
	}
	
	func configure(item: IPickerListItem?) {
		if let image = item?.image {
			iconImageView.isHidden = false
			iconImageView.image = image
		} else {
			iconImageView.isHidden = true
		}
		
		titleLabel.text = item?.title
		titleLabel.textColor = item?.isHighlighted ?? false ? commonUIConfig.colorSet.blue700 : commonUIConfig.colorSet.neutral600
		var image: UIImage
		
		if let imageSelectedRadio = item?.radioSelectedImage,
		   let imageNonSelectedRadio = item?.radioNonSelectedRadio {
			image = item?.isHighlighted ?? false ? imageSelectedRadio : imageNonSelectedRadio
		} else {
			image = item?.isHighlighted ?? false ? commonUIConfig.imageSet.radioSelectedIcon : commonUIConfig.imageSet.radioNonSelectedIcon
		}
		iconRadioImageView.image = image
	}
}

// MARK: - Private

extension PickerListImageRadioViewCell {
	
	func setupUI() {
		selectionStyle = .none
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
