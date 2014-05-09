/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright [first year code created] Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

package com.utils
{
	import com.adobe.ane.productStore.Product;
	import com.adobe.ane.productStore.ProductEvent;
	import com.adobe.ane.productStore.ProductStore;
	import com.adobe.ane.productStore.Transaction;
	import com.adobe.ane.productStore.TransactionEvent;
	import com.model.Session;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.osflash.signals.Signal;
	
	public class InApper implements InAppPurchaser
	{			
		private var productStore:ProductStore = null;
		private var _signal:Signal = new Signal();
		public static const PRODUCT_TRANSACTION_SUCCEEDED:String=		"purchaseTransactionSucceeded";
		
		public function InApper()
		{
			productStore=new ProductStore();
			Monotorizer.logEvent("productstore supported",ProductStore.isSupported.toString());
			Monotorizer.logEvent("productstore available",productStore.available.toString());
			get_Product();
		}
		
		
		
		public function get signal():Signal
		{
			return _signal;
		}

		private function get_Product():void
		{
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS,productDetailsSucceeded);
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productDetailsFailed);
			
			var vector:Vector.<String> = new Vector.<String>(1);
			vector[0] = Session.inAppFullVersionId;
			productStore.requestProductsDetails(vector);
		}
		
		public function productDetailsSucceeded(e:ProductEvent):void
		{
			var i:uint=0;
			while(e.products && i < e.products.length)
			{
				var p:Product = e.products[i];
				i++;
				Monotorizer.logEvent("inapper","productDetailsSucceeded "+p.identifier);
			}
		}
		
		public function productDetailsFailed(e:ProductEvent):void
		{
			Monotorizer.logError("inapper","product detail failed");
			var i:uint=0;
			while(e.invalidIdentifiers && i < e.invalidIdentifiers.length)
			{
				i++;
			}
		}
		
		public function purchase(product:String,quantety:uint):void
		{
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			productStore.makePurchaseTransaction(product,1);
		}
		
		
		protected function purchaseTransactionSucceeded(e:TransactionEvent):void
		{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			var i:uint=0;
			var t:Transaction;
			while(e.transactions && i < e.transactions.length)
			{
				t = e.transactions[i];
				i++;
				var Base:Base64=new Base64();
				var encodedReceipt:String = Base64.Encode(t.receipt);
				//var req:URLRequest = new URLRequest("https://sandbox.itunes.apple.com/verifyReceipt");
				var req:URLRequest = new URLRequest("https://buy.itunes.apple.com/verifyReceipt");
				req.method = URLRequestMethod.POST;
				req.data = "{\"receipt-data\" : \""+ encodedReceipt+"\"}";
				var ldr:URLLoader = new URLLoader(req);
				ldr.load(req);
				ldr.addEventListener(Event.COMPLETE,function(e:Event):void{
					productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
					productStore.finishTransaction(t.identifier);
				});
				
			}
			finishTransactionSucceeded(null);
			getPendingTransaction(productStore);
		}
		
		protected function purchaseTransactionCanceled(e:TransactionEvent):void{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
				productStore.finishTransaction(t.identifier);
			}
			getPendingTransaction(productStore);
		}
		
		protected function purchaseTransactionFailed(e:TransactionEvent):void
		{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
				productStore.finishTransaction(t.identifier);
			}
			
			getPendingTransaction(productStore);
		}
		
		protected function finishTransactionSucceeded(e:TransactionEvent):void{
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
			}
			if(i>=1){
				_signal.dispatch(PRODUCT_TRANSACTION_SUCCEEDED);
			}
		}
		
		public function restoreTransactions():void
		{
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS, restoreTransactionSucceeded);
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL, restoreTransactionFailed);
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_COMPLETE,  restoreTransactionCompleted);
			productStore.restoreTransactions();
			
		}
		
		protected function restoreTransactionSucceeded(e:TransactionEvent):void{
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				i++;
				
				productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
				productStore.finishTransaction(t.identifier);
			}
			finishTransactionSucceeded(null);
			getPendingTransaction(productStore);
		}
		
		protected function restoreTransactionFailed(e:TransactionEvent):void{
			trace("in restoreTransactionFailed  " +e);
		}
		
		protected function restoreTransactionCompleted(e:TransactionEvent):void{
			trace("in restoreTransactionCompleted  " +e);
		}
		
		
		private function getPendingTransaction(prdStore:ProductStore):void
		{
			var transactions:Vector.<Transaction> = prdStore.pendingTransactions; 
			var i:uint=0;
			while(transactions && i<transactions.length)
			{
				var t:Transaction = transactions[i];
				i++;
			}
		}
		
			
	}
}