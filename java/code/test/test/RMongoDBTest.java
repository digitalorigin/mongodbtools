package test;

import java.util.ArrayList;
import java.util.List;

import rmongodbtools.RMongoDB;

public class RMongoDBTest {
	static String user = "******";
	static String pass = "******";
	static String ip = "******";
	static String port = "******";
	
	public static void main(String[] args) {
		RMongoDB rmongo = new RMongoDB("mongodb://"+user+":"+pass+"@"+ip+":"+port+"/?authSource=audit_prod");
		try {
			rmongo.connectDatabase("audit_prod");
			
			String[] listDB = rmongo.showCollections();
			
	         for (String el : listDB) {
	        	 System.out.println(el);
	         }
	         
	         rmongo.setMaxRows(10);
	         
	         String strFile = "C:/workspace/prova_java.csv";
	         List<String> listAVars = new ArrayList<String>();
	         listAVars.add("_id");
	         listAVars.add("contexts.ONLINE_BANKING.OnlineBankingRules.account.sumAmountRule.amount");
	         String[] listVars = listAVars.toArray(new String[0]);
	         rmongo.findVars(
	        		 "flex_eval", 
	        		 "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-07-10T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}", 
	        		 listVars, 
	        		 strFile);
	         
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rmongo != null) rmongo.close();
		}
	}
}
