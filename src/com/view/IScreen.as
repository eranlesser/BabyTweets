package com.view
{
	import org.osflash.signals.Signal;

	public interface IScreen
	{
		function get done():Signal;
		function get goHome():Signal;
		function destroy():void;
	}
}