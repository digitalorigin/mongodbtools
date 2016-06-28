package rmongo;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoClientURI;

public class RMongo {
	
	MongoClient mongoClient = null;
	
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
}
