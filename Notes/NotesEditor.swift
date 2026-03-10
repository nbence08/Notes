//
//  NoteEditor.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 09..
//

import SwiftUI
import SwiftData

struct NoteEditor : View {
	@State private var title: String = ""
	@State private var text: String = ""

	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	public let note: Note

	var body: some View {
		Form {
			TextField("Title", text: $title)
			TextEditor(text: $text)
			Button("Save") {
				note.title = title
				note.text = text
				do {
					try modelContext.save()
				}
				catch {
					print(error.localizedDescription)
				}
				dismiss.callAsFunction()
			}
		}.onAppear {
			title = note.title
			text = note.text
		}
	}
}
