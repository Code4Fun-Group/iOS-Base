//
//  IntrinsicTableView.swift
//  CommonUI
//
//  Created by NamNH on 07/11/2021.
//

import UIKit

public class IntrinsicTableView: UITableView {
	public override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}

	public override var intrinsicContentSize: CGSize {
		layoutIfNeeded()
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
