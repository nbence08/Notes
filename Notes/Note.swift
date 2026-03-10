//
//  Note.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 09..
//

import Foundation
import SwiftData

@Model class Note {
	@Attribute(.unique) public var id: UUID?
	public var title: String
	public var text: String
	
	init(title: String, text: String) {
		self.id = UUID.init()
		self.title = title
		self.text = text
	}
}
