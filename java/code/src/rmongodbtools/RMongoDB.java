package rmongodbtools;

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

public class RMongoDB {
	
	int maxRows = 100;

	MongoClient mongoClient = null;
	MongoDatabase database = null;
//	DB db = null;
	
	public RMongoDB(String strURI) {
		try {
			System.out.println("Creating RMongoDB java object...");
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
				temp = listVars[i].split("\\.");
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
					Object obj = null;
					List<String> listPath = listVarPath.get(i);
					for (int rec=0;rec<listPath.size();rec++) {
						String key = listPath.get(rec);
						if (rec==0) {
							if (el != null) obj = getByKey(el, key);
						} else {
							if (obj != null) obj = getByKey(obj, key);
						}
					}
					if (obj != null) val = getText(obj);
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
	
	private String getText(Object o) {
		if (o == null) {
			return (null);
		} else if (o instanceof org.bson.types.ObjectId) {
			org.bson.types.ObjectId obj = (org.bson.types.ObjectId) o;
			return obj.toString();
		} else if (o instanceof com.mongodb.BasicDBObject) {
			com.mongodb.BasicDBObject obj = (com.mongodb.BasicDBObject) o;
			return obj.toJson();
		} else if (o instanceof org.bson.Document) {
			org.bson.Document obj = (org.bson.Document) o;
			return obj.toJson();
		} else if (o instanceof java.lang.Double) {
			java.lang.Double obj = (java.lang.Double) o;
			return obj.toString();
		} else if (o instanceof java.lang.Integer) {
			java.lang.Integer obj = (java.lang.Integer) o;
			return obj.toString();
		} else if (o instanceof java.lang.String) {
			java.lang.String obj = (java.lang.String) o;
			return obj;			
		} else if (o instanceof java.lang.Float) {
			java.lang.Float obj = (java.lang.Float) o;
			return obj.toString();
		} else if (o instanceof java.lang.Long) {
			java.lang.Long obj = (java.lang.Long) o;
			return obj.toString();			
		} else {
			System.out.println("Class not recognized: "+o.getClass().getName());
			return (o.toString());
		}
	}
	
	private Object getByKey(Object o, String key) {
		if (o == null) {
			return (null);
		} else if (o instanceof org.bson.types.ObjectId) {
			org.bson.types.ObjectId obj = (org.bson.types.ObjectId) o;
			return obj;
		} else if (o instanceof com.mongodb.BasicDBObject) {
			com.mongodb.BasicDBObject obj = (com.mongodb.BasicDBObject) o;
			return obj.get(key);
		} else if (o instanceof org.bson.Document) {
			org.bson.Document obj = (org.bson.Document) o;
			return obj.get(key);
		} else {
			System.out.println("Class not recognized: "+o.getClass().getName());
			return (o);
		}
	}
}