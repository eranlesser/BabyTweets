package com.utils.errorHandlers
{
	import com.sticksports.nativeExtensions.flurry.Flurry;
	
	import flash.display.LoaderInfo;
	import flash.events.UncaughtErrorEvent;

	public class GlobalExceptionHandler
	{
		
		
		
		public function GlobalExceptionHandler(loaderInfo:LoaderInfo)
		{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,
				uncaughtErrorHandler);
		}
		
		private function catchGlobalErrors(loaderInfo:LoaderInfo):void{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if(event.error is Error){
				Flurry.logError(event.errorID.toString(),event.error.message+" : "+event.error.getStackTrace())
				trace(event.errorID.toString(),event.error.message+" : "+event.error.getStackTrace())
			}
			event.preventDefault();
		}
	}
}
