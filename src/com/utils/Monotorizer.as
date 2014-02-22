package com.utils
{
	import eu.alebianco.air.extensions.analytics.Analytics;
	import eu.alebianco.air.extensions.analytics.api.ITracker;

	public class Monotorizer
	{
		private static var tracker:ITracker ;
		public function Monotorizer()
		{
			
		}
		
		public static function logEvent(category:String,action:String,value:int=-100):void{
			try{
			if (Analytics.isSupported()) {
				if(!tracker){
					tracker:ITracker = Analytics.getInstance().getTracker("UA-48121763-1");
				}
				if(value!=-100){
					tracker.buildEvent(category, action).track();
				}else{
					tracker.buildEvent(category, action).withValue(value).track();
				}
			}
			}catch(e:Error){}
		}
		
		public static function logError(errorId:String,description:String,critical:Boolean=true):void{
			try{
			if (Analytics.isSupported()) {
				if(!tracker){
					tracker:ITracker = Analytics.getInstance().getTracker("UA-48121763-1");
				}
				tracker.buildException(critical).withDescription(description).track();
			}
			}catch(e:Error){}
		}
		
		
		
	}
}