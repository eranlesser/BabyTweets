package com.utils
{
	import org.osflash.signals.Signal;

	public interface InAppPurchaser
	{
		function purchase(product:String,quantety:uint):void;
		function restoreTransactions():void;
		function get signal():Signal;
	}
}