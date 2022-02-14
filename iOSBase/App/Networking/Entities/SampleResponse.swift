//
//  SampleResponse.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import Foundation

struct SampleResponse: Codable {
	var id: Int
	var title: String
}

extension SampleModel {
	init(item: SampleResponse) {
		id = item.id
		name = item.title
	}
}
