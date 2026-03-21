//
//  Label.swift
//  Notes
//
//  Created by Nagy Bence Damján on 2026. 03. 18..
//

import SwiftData

@Model class Tag : Identifiable, Hashable, Codable {
	@Attribute(.unique) public var text: String

	init(text: String) {
		self.text = text
	}

	required init(from: Decoder) throws {
		let container = try from.singleValueContainer()
		self.text = try container.decode(String.self)
	}

	func encode(to: Encoder) throws {
		var container = to.singleValueContainer()
		try container.encode(self.text)
	}

	public var notes: [Note] = []
}
