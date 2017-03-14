package test;

import org.bson.Document;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;

import rmongodbtools.RMongoDB;

public class RMongoDBTest02 {
	static String user = "******";
	static String pass = "******";
	static String ip = "******";
	static String port = "******";
	static String database = "******";
	
	public static void main(String[] args) {
		RMongoDB rmongo = new RMongoDB("mongodb://"+user+":"+pass+"@"+ip+":"+port+"/?authSource="+database, false);
		try {
			rmongo.connectDatabase(database);
			
			String[] listDB = rmongo.showCollections();
	         for (String el : listDB) {
	        	 System.out.println(el);
	         }
	         
	         String str_collection = "evaluation";
	         String str_find = "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2017-03-01T00:00:00.000Z\"} }, \"createDate\" : {\"$lte\" :  { \"$date\" : \"2017-03-02T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}";
	         String str_projection = "{\"_id\":0, \"refId\":1, \"createDate\":1, \"contexts.BASKET_MODEL.score\":1, \"contexts.BASKET_MODEL.items_number\":1, \"contexts.BASKET_MODEL.normalizedItems\":1}";
	         
	         MongoCollection<Document> java_dbCollection = null;
	         FindIterable<Document> java_iterable = null;
	         MongoCursor<Document> java_it = null;
	         
	         java_dbCollection = rmongo.getCollection(str_collection);
	         java_iterable = rmongo.find(java_dbCollection, str_find);
	         
//	         java_dbCollection.count(json);
//	         java_iterable.skip();
//	         java_iterable.limit();
//	         java_dbCollection.aggregate(list_json);
	         
	         java_iterable = rmongo.projection(java_iterable, str_projection);
	         java_it = rmongo.iterator(java_iterable);
	         
	         int i = 0;
	         while (rmongo.hasNext(java_it) && i < 10) {
	        	 String json = rmongo.next(java_it);
	        	 System.out.println(json);
	        	 i++;
	         }
	         
	         rmongo.close();
	         
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rmongo != null) rmongo.close();
		}
	}
}
