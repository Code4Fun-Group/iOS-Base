//
//  PickerListFilterDelegate.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import Common

public protocol PickerListFilterDelegate: AnyObject {
	func pickerDidSelectAt(item: IPickerListItem)
}
