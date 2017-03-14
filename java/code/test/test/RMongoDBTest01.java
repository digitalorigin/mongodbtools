package test;

import java.util.ArrayList;
import java.util.List;

import org.bson.Document;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;

import rmongodbtools.RMongoDB;

public class RMongoDBTest01 {
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
	         
	         rmongo.setMaxRows(10);
	         
//	         String strFile = "C:/workspace/prova_java.csv";
//	         List<String> listAVars = new ArrayList<String>();
//	         listAVars.add("_id");
//	         listAVars.add("contexts.ONLINE_BANKING.OnlineBankingRules.account.sumAmountRule.amount");
//	         String[] listVars = listAVars.toArray(new String[0]);
//	         rmongo.findVarsToCSV(
//	        		 "flex_eval", 
//	        		 "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-07-10T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}", 
//	        		 listVars, 
//	        		 strFile);
		         
	         String strFile = "C:/workspace/prova_java.csv";
	         String strCollection = "evaluation"; 
	         String strFind = "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-10-01T00:00:00.000Z\"} }, \"contexts.BASKET_MODEL.score\":{\"$exists\":true}}"; 
	         List<String> listAVars = new ArrayList<String>();
	         listAVars.add("_id");
	         listAVars.add("refId");
	         listAVars.add("createDate");
	         listAVars.add("contexts.BASKET_MODEL.score");
	         listAVars.add("contexts.BASKET_MODEL.items_number");
	         listAVars.add("contexts.BASKET_MODEL.normalizedItems");
	         String[] listVars = listAVars.toArray(new String[0]);
	         MongoCollection<Document> dbCollection = rmongo.getCollection(strCollection);
	         FindIterable<Document> iterable = rmongo.find(dbCollection, strFind);
	         rmongo.toCSV(iterable.iterator(), listVars, strFile);	         
		         
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rmongo != null) rmongo.close();
		}
	}
}
