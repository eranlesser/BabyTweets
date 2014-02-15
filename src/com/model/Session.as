package com.model
{
	//import com.freshplanet.nativeExtensions.Flurry;
	
	
	import com.sticksports.nativeExtensions.flurry.Flurry;
	
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
		private static var _lang:String;
		private static var _fullVersionEnabled:Boolean = true;
		public static const inAppFullVersionId:String = "babyTweetsEn.fullVersion";
		//public static const inAppFullVersionId:String = "babyTweetsHeb.fullVersion";
		public static var deviceId:uint=1; // phone 1 , tablet 2
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
			Flurry.logEvent("fullVersionEnabled",{val:value});
			_fullVersionEnabled = value;
			exportSessionData();
			changed.dispatch();
		}
		
		public static function init():void{
			var inputFile:File = File.applicationStorageDirectory.resolvePath("sessions/userSessionData21.xml") ;
			if(inputFile.exists){
				var inputStream:FileStream = new FileStream();
				inputStream.open(inputFile, FileMode.READ);
				var sessionXML:XML = XML(inputStream.readUTFBytes(inputStream.bytesAvailable));
				inputStream.close();
				if(sessionXML.fullVersion == "true"){
					_fullVersionEnabled = true;
					changed.dispatch();
				}
				trace("sessionXML",sessionXML);
			}
		}
		
		private static function exportSessionData():void{
			var folder:File = File.applicationStorageDirectory.resolvePath("sessions");
			if (!folder.exists) { 
				folder.createDirectory();
			} 
			var outputFile:File = folder.resolvePath("userSessionData21.xml");
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