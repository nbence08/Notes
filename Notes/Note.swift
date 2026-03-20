//
//  Note.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 09..
//

import Foundation
import SwiftData

@Model class Note: Identifiable, Hashable, Encodable {
	@Attribute(.unique) public var id: UUID
	public var title: String
	public var text: String
	public var createdAt: Date = Date()
	
	init(title: String, text: String) {
		self.id = UUID.init()
		self.title = title
		self.text = text
		self.createdAt = Date.now
	}
	
	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(text, forKey: .text)
		try container.encode(createdAt, forKey: .createdAt)
	}
	
	enum CodingKeys: String, CodingKey {
		case id, title, text, createdAt
	}
	
	@Relationship(inverse: \Label.self) public var labels: Set<Label> = []
}
