package com.view
{
	import com.model.ScreenModel;
	
	import org.osflash.signals.Signal;

	public interface IScreen
	{
		function get done():Signal;
		function get goHome():Signal;
		function destroy():void;
		function set model(mdl:ScreenModel):void;
		function get model():ScreenModel;
	}
}