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
	@Environment(\.editMode) private var editMode
	@Query public var items: [Note]
	@State private var selection: Set<UUID> = []

	@State private var navigationPath: NavigationPath = NavigationPath()

	var isEditMode: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}

	var body: some View {
		NavigationStack (path: $navigationPath) {
			List(selection: $selection) {
				ForEach(items, id: \.id) { note in
					HStack {
						Text(note.title)
						Spacer()
					}
					.contentShape(Rectangle())
					.tag(note.id)
					.onTapGesture {
						if isEditMode { return }
						navigationPath.append(note)
					}
					
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
						for id in selection {
							if let item = items.first(where: { $0.id == id }) {
								modelContext.delete(item)
							}
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
				ToolbarItem {
					EditButton()
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
