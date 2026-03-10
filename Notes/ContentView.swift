//
//  ContentView.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 08..
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [Note]

	var body: some View {
		NavigationStack {
			List {
				ForEach(items) { note in
					NavigationLink(note.title, value: note)
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						let newNote = Note(title: "new", text: "")
						modelContext.insert(newNote)
						do {
							try modelContext.save()
						} catch {
							print(error.localizedDescription)
						}
					} label: {
						Image(systemName: "plus")
					}
				}
				ToolbarItem {
					Button {
						for item in items {
							modelContext.delete(item)
						}
						do {
							try modelContext.save()
						} catch {
							print(error.localizedDescription)
						}
					} label: {
						Image(systemName: "trash")
					}
				}
			}
			.navigationDestination(for: Note.self) { note in
				NoteEditor(note: note)
			}
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Note.self, inMemory: true)
}
