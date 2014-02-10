package com.utils
{
	import com.amazon.nativeextensions.android.AmazonPurchase;
	import com.amazon.nativeextensions.android.events.AmazonPurchaseEvent;
	import com.model.Session;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class AmazoneInApper implements InAppPurchaser
	{
		private var _signal:Signal = new Signal();
		public function AmazoneInApper()
		{
			AmazonPurchase.create();
			AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
			AmazonPurchase.amazonPurchase.loadItemData([Session.inAppFullVersionId]);
		}
		
		
		
		public function purchase(product:String,quantety:uint):void{
			AmazonPurchase.amazonPurchase.purchaseItem(product);
		}
		
		protected function onPurchaseSuccess(event:Event):void
		{
			_signal.dispatch(InAppEvents.PRODUCT_TRANSACTION_SUCCEEDED);
			
		}
		
		public function restoreTransactions():void
		{
			trace("Restoring transactions...");
			AmazonPurchase.amazonPurchase.restoreTransactions();
			trace("transactions restored.");
		}
		
		public function get signal():Signal{
			return _signal;
		}
	}
}