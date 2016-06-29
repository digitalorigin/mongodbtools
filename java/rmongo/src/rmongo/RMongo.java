package rmongo;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoClientURI;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import com.mongodb.util.JSON;

public class RMongo {
	
	int maxRows = 100;

	MongoClient mongoClient = null;
	MongoDatabase database = null;
//	DB db = null;
	
	public RMongo(String strURI) {
		try {
			MongoClientOptions.Builder options = MongoClientOptions.builder().sslEnabled(true).sslInvalidHostNameAllowed(true);
			SSLContext context;
			context = SSLContext.getInstance("SSL");
					TrustManager[] trustAllCerts = { new InsecureTrustManager() };	
			context.init(null, trustAllCerts, new java.security.SecureRandom());
			options.socketFactory((SSLSocketFactory) context.getSocketFactory());
			MongoClientURI uri = new MongoClientURI(strURI, options);
			
			mongoClient = new MongoClient(uri);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
//	@SuppressWarnings("deprecation")
	public void connectDatabase(String strDB) {
		try {
			if (mongoClient==null) return;
			database = mongoClient.getDatabase(strDB);
//			db = mongoClient.getDB(strDB);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String[] showCollections() {
		if (database==null) return(null);
		MongoIterable<String> listCollectionNames = database.listCollectionNames();
        List<String> listCollNames = listCollectionNames.into(new ArrayList<String>());
        if (listCollNames.size()==0) return(null);
        
        String[] output = listCollNames.toArray(new String[0]); 
		return output;
	}
	
	public void find(String collectionName, String query, String strFile) {
		try {
			MongoCollection<Document> dbCollection = database.getCollection(collectionName);
			
			Bson bson = ( Bson ) JSON.parse( query );
			
			FindIterable<Document> iterable = dbCollection.find(bson);
			MongoCursor<Document> b = iterable.iterator();
			
//			DBCollection dbCollection = db.getCollection(collectionName);
//			
//			DBObject queryObject = (DBObject) JSON.parse(query);
//			DBObject keysObject = (DBObject) JSON.parse(keys);
//			DBCursor cursor = dbCollection.find(queryObject, keysObject);
			
			System.out.println("Exporting to file : "+strFile);
			File fileOutput = new File(strFile);	
		    BufferedWriter bufferedWriterOutput = new BufferedWriter(new FileWriter(fileOutput, false));

		    int row = 1;
		    boolean firstRow = true;
		    boolean firstColumn;
		    String strLine;
		    while (b.hasNext() && (row < maxRows || maxRows <0)) {
//		    while (cursor.hasNext() && (row < maxRows || maxRows <0)) {
		    	Document el = b.next();
//		    	DBObject el = cursor.next();
		    	
		    	Set<String> setKeys = el.keySet();
		    	
		    	if (firstRow) {
		    		firstColumn = true;
		    		strLine = "";
		    		for (String key : setKeys) {
			    		if (firstColumn) {
			    			strLine = strLine + key;
			    			firstColumn = false;
			    		} else {
			    			strLine = strLine + ";" + key;
			    		}
			    	}
		    		bufferedWriterOutput.write(strLine);
				    bufferedWriterOutput.newLine();
				    firstRow = false;
		    	}
		    	
		    	firstColumn = true;
	    		strLine = "";
	    		for (String key : setKeys) {
	    			Object o = el.get(key);
		    		if (firstColumn) {
		    			strLine = strLine + o;
		    			firstColumn = false;
		    		} else {
		    			strLine = strLine + ";" + o;
		    		}
		    	}
				bufferedWriterOutput.write(strLine);
				bufferedWriterOutput.newLine();
				
				row =row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void findVars(String collectionName, String query, String[] listVars, String strFile) {
		try {
			MongoCollection<Document> dbCollection = database.getCollection(collectionName);
			
			Bson bson = ( Bson ) JSON.parse( query );
			
			FindIterable<Document> iterable = dbCollection.find(bson);
			MongoCursor<Document> b = iterable.iterator();
			
//			DBCollection dbCollection = db.getCollection(collectionName);
//			
//			DBObject queryObject = (DBObject) JSON.parse(query);
//			DBObject keysObject = (DBObject) JSON.parse(keys);
//			DBCursor cursor = dbCollection.find(queryObject, keysObject);
			
			List<List<String>> listVarPath = new ArrayList<List<String>>();
			for (int i=0;i<listVars.length;i++) {
				String[] temp;
				temp = listVars[i].split(";");
				listVarPath.add(Arrays.asList(temp)); 
			}
			
			System.out.println("Exporting to file : "+strFile);
			File fileOutput = new File(strFile);	
		    BufferedWriter bufferedWriterOutput = new BufferedWriter(new FileWriter(fileOutput, false));

		    int row = 1;
		    boolean firstRow = true;
		    boolean firstColumn;
		    String strLine;
		    while (b.hasNext() && (row < maxRows || maxRows <0)) {
//		    while (cursor.hasNext() && (row < maxRows || maxRows <0)) {
		    	Document el = b.next();
//		    	DBObject el = cursor.next();
		    	
		    	Set<String> setKeys = el.keySet();
		    	
		    	if (firstRow) {
		    		firstColumn = true;
		    		strLine = "";
					for (int i=0;i<listVars.length;i++) {
						List<String> listPath = listVarPath.get(i);
						String key = listPath.get(listPath.size()-1);
						if (firstColumn) {
			    			strLine = strLine + key;
			    			firstColumn = false;
			    		} else {
			    			strLine = strLine + ";" + key;
			    		}
					}
		    		bufferedWriterOutput.write(strLine);
				    bufferedWriterOutput.newLine();
				    firstRow = false;
		    	}
		    	
		    	firstColumn = true;
	    		strLine = "";
				for (int i=0;i<listVars.length;i++) {
					String val = "";
					List<String> listPath = listVarPath.get(i);
					for (int rec=0;rec<listPath.size();rec++) {
						String key = listPath.get(rec);
						Object o = el.get(key);
					}
					if (firstColumn) {
		    			strLine = strLine + val;
		    			firstColumn = false;
		    		} else {
		    			strLine = strLine + ";" + val;
		    		}
				}
				bufferedWriterOutput.write(strLine);
				bufferedWriterOutput.newLine();
				
				row =row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void close() {
		if (mongoClient != null) mongoClient.close();
//		db = null;
		database = null;
		mongoClient = null;
	}
	
	public int getMaxRows() {
		return maxRows;
	}

	public void setMaxRows(int maxRows) {
		this.maxRows = maxRows;
	}
}
