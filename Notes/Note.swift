//
//  Note.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 09..
//

import Foundation
import SwiftData

@Model class Note: Identifiable, Hashable, Codable {
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
	
	required init(from: any Decoder) throws {
		let container = try from.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(UUID.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.text = try container.decode(String.self, forKey: .text)
		self.createdAt = try container.decode(Date.self, forKey: .createdAt)
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
