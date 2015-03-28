package com.utils
{
	import com.freshplanet.nativeExtensions.Flurry;
	import com.model.Session;
	
	public class Monotorizer
	{
		private static var _inited:Boolean = false;
		public function Monotorizer()
		{
			
		}
		
		private static function init():void{
			if(!_inited){
				try{
				Flurry.getInstance().setIOSAPIKey("PYPGBZP7VD9YYMMTWYDW");
				Flurry.getInstance().setAppVersion(Session.VERSION);
				Flurry.getInstance().startSession();
				//PYPGBZP7VD9YYMMTWYDW  arabic
				}catch(e:Error){}
			}
			_inited = true;
		}
		
		public static function logEvent(category:String,action:String,value:int=-100):void{
			init();
			try{
				Flurry.getInstance().logEvent(category+"_"+action,{param:value});
			}catch(e:Error){}
		}
		
		public static function logError(errorId:String,description:String,critical:Boolean=true):void{
			
			init();
			try{
				Flurry.getInstance().logError(errorId,description);
			}catch(e:Error){}
		}
		
		
		
	}
}