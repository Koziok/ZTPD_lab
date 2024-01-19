package app.lucene;

import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, ParseException {

        //StandardAnalyzer analyzer = new StandardAnalyzer();
        //EnglishAnalyzer analyzer = new EnglishAnalyzer();
        PolishAnalyzer analyzer = new PolishAnalyzer();
        Directory directory = new ByteBuffersDirectory();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter w = new IndexWriter(directory, config);

//        w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
//        w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
//        w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
//        w.addDocument(buildDoc("The Art of Computer Science", "9781250301695"));
//        w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));
//        w.close();

        w.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        w.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        w.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        w.addDocument(buildDoc("Naturalnie urodzeni mordercy","9780316485616"));
        w.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        w.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));
        w.close();

//        Zad 6
//        String querystr = "*:*";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 7
//        String querystr = "dummy";
//        String querystr = "and";
//        Query q = new QueryParser("title", analyzer).parse(querystr);
//        Zad 9
//        Można wywnioskować, że angielski analizatror używa stopwords oraz uwzględnia odmiane słów.

//        Zad 12a
//        String querystr = "9780062316097";
//        Query q = new QueryParser("isbn", analyzer).parse(querystr);

//        Zad 12b
//        String querystr = "urodzić";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12c
//        String querystr = "rodzić";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12d
//        String querystr = "ro*";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12e
//        String querystr = "ponieważ";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12f
//        String querystr = "\"Lucyna\" AND \"akcja\"";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12g
//        String querystr = "\"akcja\" NOT \"Lucyna\"";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12h
//        String querystr = "\"naturalnie morderca\"~2";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12i
//        String querystr = "\"naturalnie morderca\"~1";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12j
//        String querystr = "\"naturalnie morderca\"~0";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12k
//        String querystr = "naturalne";
//        Query q = new QueryParser("title", analyzer).parse(querystr);

//        Zad 12l
        String querystr = "\"naturalne\"~";
        Query q = new QueryParser("title", analyzer).parse(querystr);

        int maxHits = 10;
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        TopDocs docs = searcher.search(q, maxHits);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");
        StoredFields storedFields = searcher.storedFields();
        for(int i=0; i<hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = storedFields.document(docId);
            System.out.println((i + 1) + ". " + d.get("isbn")
                    + "\t" + d.get("title"));
        }
        reader.close();
    }
    private static Document buildDoc (String title, String isbn){
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }
}
