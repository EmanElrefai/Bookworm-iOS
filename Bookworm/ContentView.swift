//
//  ContentView.swift
//  Bookworm
//
//  Created by Eman Elrefai on 11/12/20.
//

import SwiftUI
struct ContentView: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {

        NavigationView {
            Form {
                ForEach(books, id: \.self) { book in
                    Section{
                        NavigationLink(
                            destination: DetailView(book: book)) {
                            
                            EmojiRatingView(rating: book.rating)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown title").font(.headline)
                                Text(book.author ?? "Unknown author").foregroundColor(.secondary)
                                
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
                
            }.background(Color.blue)
            
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton().accentColor(Color.black), trailing:
                                    Button(action: {
                                        self.showingAddScreen.toggle()
                                    }) {
                                        Image(systemName: "plus").accentColor(Color.black)
                                    }
            )
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
