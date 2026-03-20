//
//  Label.swift
//  Notes
//
//  Created by Nagy Bence Damján on 2026. 03. 18..
//

import SwiftData

@Model
class Label : Hashable, Identifiable {

	@Attribute(.unique) var text: String

	init(text: String) {
		self.text = text
	}
	
	@Relationship(inverse: \Note.self) var notes: Set<Note>
}
