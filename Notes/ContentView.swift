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
	@State private var selectTagsSheet: Bool = false
	@State private var selectedTags: Set<Tag> = []

	@State private var navigationPath: NavigationPath = NavigationPath()
	
	var itemsWithSelectedTags: [Note] {
		var retVal: [Note] = []
		guard !selectedTags.isEmpty else {
			return items
		}

		for note in items {
			if selectedTags.intersection(note.tags).count > 0 {
				retVal.append(note)
			}
		}

		return retVal
	}

	var isEditMode: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}

	var body: some View {
		NavigationStack (path: $navigationPath) {
			List(selection: $selection) {
				ForEach(itemsWithSelectedTags, id: \.id) { note in
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
			.sheet(isPresented: $selectTagsSheet) {
				TagSelector(selectedTags: $selectedTags)
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
				ToolbarItem {
					Button {
						selectTagsSheet = true
					} label: {
						Image(systemName: "number")
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
