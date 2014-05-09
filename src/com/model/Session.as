package com.model
{
	//import com.freshplanet.nativeExtensions.Flurry;
	
	
	import com.utils.Monotorizer;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.osflash.signals.Signal;

	public class Session
	{
		public static var currentScreen:int=0;
		public static const FREE_THUMBS_COUNT:uint=4;
		public static var changed:Signal = new Signal();
		public static var langChanged:Signal = new Signal();
		public static var OS:String="IOS";
		public static var IS_RETINA:Boolean = false;
		private static var _lang:String;
		private static var _fullVersionEnabled:Boolean = false;
		public static const inAppFullVersionId:String = "babyTweetsEn.fullVersion";
		//public static const inAppFullVersionId:String = "babyTweetsHeb.fullVersion";
		public static var deviceId:uint=2; // phone 1 , tablet 2
		public function Session()
		{
		}
		
		public static function get lang():String
		{
			return _lang;
		}

		public static function set lang(value:String):void
		{
			_lang = value;
			langChanged.dispatch();
		}


		
		public static function get fullVersionEnabled():Boolean
		{
			return _fullVersionEnabled;
		}

		
		public static function set fullVersionEnabled(value:Boolean):void
		{
			Monotorizer.logEvent("fullVersionEnabled",value.toString());
			_fullVersionEnabled = value;
			exportSessionData();
			changed.dispatch();
		}
		
		public static function init():void{
			var inputFile:File = File.documentsDirectory.resolvePath("babytweets/sessions/5_0.xml") ;
			if(inputFile.exists){
				var inputStream:FileStream = new FileStream();
				inputStream.open(inputFile, FileMode.READ);
				var sessionXML:XML = XML(inputStream.readUTFBytes(inputStream.bytesAvailable));
				inputStream.close();
				if(sessionXML.fullVersion == "true"){
					_fullVersionEnabled = true;
					changed.dispatch();
				}
			}
		}
		
		private static function exportSessionData():void{
			var folder:File = File.documentsDirectory.resolvePath("babytweets/sessions");
			if (!folder.exists) { 
				folder.createDirectory();
			} 
			var outputFile:File = folder.resolvePath("5_0.xml");
			if(outputFile.exists){
				outputFile.deleteFile();
			}
			var outputStream:FileStream = new FileStream();
			outputStream.open(outputFile,FileMode.WRITE);
			var sessionXml:XML = new XML(<xml><fullVersion>{_fullVersionEnabled}</fullVersion></xml>)
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += sessionXml.toXMLString()+'\n';
			outputStream.writeUTFBytes(outputString);
			outputStream.close();
		}
		

	}
}