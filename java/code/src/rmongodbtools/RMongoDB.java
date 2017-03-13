package rmongodbtools;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

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
	
	int maxRows = -1;

	String strDateFormat = "yyyy-MM-dd HH:mm:ss";
	SimpleDateFormat dateFormat = new SimpleDateFormat(strDateFormat);
	
	MongoClient mongoClient = null;
	MongoDatabase database = null;
//	DB db = null;
	
	public RMongoDB(String strURI, int maxRows, boolean silent) {
		try {
			System.out.println("Creating RMongoDB java object...");
			if (silent) {
				Logger mongoLogger = Logger.getLogger( "org.mongodb" );
				mongoLogger.setLevel(Level.WARNING);
			} 
			MongoClientOptions.Builder options = MongoClientOptions.builder().sslEnabled(true).sslInvalidHostNameAllowed(true);
			SSLContext context;
			context = SSLContext.getInstance("SSL");
					TrustManager[] trustAllCerts = { new InsecureTrustManager() };	
			context.init(null, trustAllCerts, new java.security.SecureRandom());
			options.socketFactory((SSLSocketFactory) context.getSocketFactory());
			MongoClientURI uri = new MongoClientURI(strURI, options);
			
			this.mongoClient = new MongoClient(uri);
			this.maxRows = maxRows;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public RMongoDB(String strURI, boolean silent) {
		try {
			System.out.println("Creating RMongoDB java object...");
			if (silent) {
				Logger mongoLogger = Logger.getLogger( "org.mongodb" );
				mongoLogger.setLevel(Level.WARNING);
			} 
			MongoClientOptions.Builder options = MongoClientOptions.builder().sslEnabled(true).sslInvalidHostNameAllowed(true);
			SSLContext context;
			context = SSLContext.getInstance("SSL");
					TrustManager[] trustAllCerts = { new InsecureTrustManager() };	
			context.init(null, trustAllCerts, new java.security.SecureRandom());
			options.socketFactory((SSLSocketFactory) context.getSocketFactory());
			MongoClientURI uri = new MongoClientURI(strURI, options);
			
			this.mongoClient = new MongoClient(uri);
			
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
	
	public void findVarsToCSV(String collectionName, String query, String[] listVars, String strFile) {
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
				
				row = row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void findVarsToJSON(String collectionName, String query, String strFile) {
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
		    while (b.hasNext() && (row < maxRows || maxRows <0)) {
//		    while (cursor.hasNext() && (row < maxRows || maxRows <0)) {
		    	Document el = b.next();
//		    	DBObject el = cursor.next();
		    	
		    	String strLine = String.format("%s",JSON.serialize(el));
		    	
				bufferedWriterOutput.write(strLine);
				bufferedWriterOutput.newLine();
				
				row = row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public MongoCollection<Document> getCollection(String collectionName) {
		try {
			MongoCollection<Document> dbCollection = database.getCollection(collectionName);
			return dbCollection;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public FindIterable<Document> find(MongoCollection<Document> dbCollection, String query) {
		try {
			Bson bson = ( Bson ) JSON.parse( query );
			FindIterable<Document> iterable = dbCollection.find(bson);
			return iterable;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public FindIterable<Document> projection(FindIterable<Document> iterable, String query) {
		try {
			Bson bson = ( Bson ) JSON.parse( query );
			iterable = iterable.projection(bson);
			return iterable;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public FindIterable<Document> sort(FindIterable<Document> iterable, String query) {
		try {
			Bson bson = ( Bson ) JSON.parse( query );
			iterable = iterable.sort(bson);
			return iterable;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public FindIterable<Document> skip(FindIterable<Document> iterable, int nSkip) {
		try {
			iterable = iterable.skip(nSkip);
			return iterable;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public MongoCursor<Document> iterator(FindIterable<Document> iterable) {
		try {
			MongoCursor<Document> it = iterable.iterator();
			return it;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public boolean hasNext(MongoCursor<Document> it) {
		try {
			return it.hasNext();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public String next(MongoCursor<Document> it) {
		try {
			String strLine = null;
		    if (it.hasNext()) {
		    	Document el = it.next();
		    	strLine = String.format("%s",JSON.serialize(el));
		    }
		    return strLine;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}	
	
	public void toCSV(MongoCursor<Document> it, String[] listVars, String strFile) {
		try {
			if (!it.hasNext()) return;
			
			List<List<String>> listVarPath = new ArrayList<List<String>>();
			for (int i=0;i<listVars.length;i++) {
				String[] temp;
				temp = listVars[i].split("\\.");
				listVarPath.add(Arrays.asList(temp)); 
			}
			
			File fileOutput = new File(strFile);	
		    BufferedWriter bufferedWriterOutput = new BufferedWriter(new FileWriter(fileOutput, false));
			
		    int row = 0;
		    boolean firstColumn;
		    String strLine;
			Document el;
	    	
			// Headers		
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
			
		    while (it.hasNext() && (row < maxRows || maxRows <1)) {
		    	el = it.next();
		    	
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
				
				row = row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void toCSV(MongoCursor<Document> it, String strFile) {
		try {
			if (!it.hasNext()) return;
			
			File fileOutput = new File(strFile);	
		    BufferedWriter bufferedWriterOutput = new BufferedWriter(new FileWriter(fileOutput, false));
			
		    int row = 0;
		    boolean firstColumn;
		    String strLine;
			Document el = it.next();
			Set<String> setKeys = el.keySet();
	    	
			// Headers			
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
			
		    // First row
		    firstColumn = true;
    		strLine = "";
    		for (String key : setKeys) {
    			Object obj = el.get(key);
				String val = "";
				
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
			
			row = row + 1;
			
		    while (it.hasNext() && (row < maxRows || maxRows <1)) {
		    	el = it.next();
		    	
		    	firstColumn = true;
	    		strLine = "";
	    		for (String key : setKeys) {
	    			Object obj = el.get(key);
					String val = "";
					
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
				
				row = row + 1;
		    }
		    bufferedWriterOutput.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void toJSON(MongoCursor<Document> it, String strFile) throws Exception {
		if (!it.hasNext()) return;
		
		File fileOutput = new File(strFile);	
	    BufferedWriter bufferedWriterOutput = new BufferedWriter(new FileWriter(fileOutput, false));
		
	    int row = 0;
	    String strLine;
		Document el;
		
	    while (it.hasNext() && (row < maxRows || maxRows <1)) {
	    	el = it.next();
	    	
	    	strLine = String.format("%s",JSON.serialize(el));
	    	
			bufferedWriterOutput.write(strLine);
			bufferedWriterOutput.newLine();
			
			row = row + 1;
	    }
	    bufferedWriterOutput.close();
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
	
	public String getDateFormat() {
		return strDateFormat;
	}

	public void setDateFormat(String strDateFormat) {
		this.strDateFormat = strDateFormat;
		this.dateFormat = new SimpleDateFormat(strDateFormat);
	}
	
	private String getText(Object o) {
		if (o == null) {
			return "";
		} else if (o instanceof org.bson.types.ObjectId) {
			org.bson.types.ObjectId obj = (org.bson.types.ObjectId) o;
			return obj.toString();
		} else if (o instanceof com.mongodb.BasicDBObject) {
//			com.mongodb.BasicDBObject obj = (com.mongodb.BasicDBObject) o;
//			return obj.toJson();
			return String.format("%s",JSON.serialize(o));
		} else if (o instanceof org.bson.Document) {
//			org.bson.Document obj = (org.bson.Document) o;
//			return obj.toJson();
			return String.format("%s",JSON.serialize(o));
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
		} else if (o instanceof java.lang.Boolean) {
			java.lang.Boolean obj = (java.lang.Boolean) o;
			return obj.toString();				
		} else if (o instanceof java.util.Date) {
			java.util.Date obj = (java.util.Date) o;
			return this.dateFormat.format(obj);
		} else {
//			System.out.println("Class not recognized (getText): "+o.getClass().getName());
//			return (o.toString());
			return String.format("%s",JSON.serialize(o));
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
			System.out.println("Class not recognized (getByKey): "+o.getClass().getName());
			return (o);
		}
	}
}
