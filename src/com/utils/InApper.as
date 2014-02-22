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
	import flash.events.MouseEvent;
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
			trace("in get_Product");
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS,productDetailsSucceeded);
			productStore.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productDetailsFailed);
			
			var vector:Vector.<String> = new Vector.<String>(1);
			vector[0] = Session.inAppFullVersionId;
			productStore.requestProductsDetails(vector);
		}
		
		public function productDetailsSucceeded(e:ProductEvent):void
		{
			trace("in productDetailsSucceeded "+e);
			var i:uint=0;
			while(e.products && i < e.products.length)
			{
				var p:Product = e.products[i];
				i++;
			}
		}
		
		public function productDetailsFailed(e:ProductEvent):void
		{
			trace("in productDetailsFailed"+e);
			var i:uint=0;
			while(e.invalidIdentifiers && i < e.invalidIdentifiers.length)
			{
				trace(e.invalidIdentifiers[i]);
				i++;
			}
		}
		
		public function purchase(product:String,quantety:uint):void
		{
			trace("purchase product...");
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			productStore.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			productStore.makePurchaseTransaction(product,1);
		}
		
		
		protected function purchaseTransactionSucceeded(e:TransactionEvent):void
		{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			trace("in purchaseTransactionSucceeded" +e);
			var i:uint=0;
			var t:Transaction;
			while(e.transactions && i < e.transactions.length)
			{
				t = e.transactions[i];
				printTransaction(t);
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
					trace("LOAD COMPLETE: " + ldr.data);
					productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
					productStore.finishTransaction(t.identifier);
				});
				
				trace("Called Finish on/Finish Transaction " + t.identifier); 
			}
			getPendingTransaction(productStore);
		}
		
		protected function purchaseTransactionCanceled(e:TransactionEvent):void{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			trace("in purchaseTransactionCanceled"+e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				printTransaction(t);
				i++;
				trace("FinishTransactions >>purchaseTransactionCanceled" + t.identifier);
				productStore.finishTransaction(t.identifier);
			}
			getPendingTransaction(productStore);
		}
		
		protected function purchaseTransactionFailed(e:TransactionEvent):void
		{
			productStore.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			trace("in purchaseTransactionFailed"+e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				printTransaction(t);
				i++;
				trace("FinishTransactions" + t.identifier);
				productStore.finishTransaction(t.identifier);
			}
			
			getPendingTransaction(productStore);
		}
		
		protected function finishTransactionSucceeded(e:TransactionEvent):void{
			trace("in finishTransactionSucceeded" +e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				printTransaction(t);
				i++;
			}
			if(i>=1){
				_signal.dispatch(PRODUCT_TRANSACTION_SUCCEEDED);
			}
		}
		
		public function restoreTransactions():void
		{
			trace("in restore_Transactions");
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS, restoreTransactionSucceeded);
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL, restoreTransactionFailed);
			productStore.addEventListener(TransactionEvent.RESTORE_TRANSACTION_COMPLETE,  restoreTransactionCompleted);
			productStore.restoreTransactions();
			
		}
		
		protected function restoreTransactionSucceeded(e:TransactionEvent):void{
			trace("in restoreTransactionSucceeded" +e);
			var i:uint=0;
			while(e.transactions && i < e.transactions.length)
			{
				var t:Transaction = e.transactions[i];
				printTransaction(t);
				i++;
				
				trace("FinishTransactions" + t.identifier);
				productStore.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
				productStore.finishTransaction(t.identifier);
			}
			
			getPendingTransaction(productStore);
		}
		
		protected function restoreTransactionFailed(e:TransactionEvent):void{
			trace("in restoreTransactionFailed" +e);
		}
		
		protected function restoreTransactionCompleted(e:TransactionEvent):void{
			trace("in restoreTransactionCompleted" +e);
		}
		
		protected function pending_transaction(event:MouseEvent):void
		{
			getPendingTransaction(productStore);
		}
		
		public function getPendingTransaction(prdStore:ProductStore):void
		{
			trace("pending transaction");
			var transactions:Vector.<Transaction> = prdStore.pendingTransactions; 
			var i:uint=0;
			while(transactions && i<transactions.length)
			{
				var t:Transaction = transactions[i];
				printTransaction(t);
				i++;
			}
		}
		
		public function printTransaction(t:Transaction):void
		{
			trace("-------------------in Print Transaction----------------------");
			trace("identifier :"+t.identifier);
			trace("productIdentifier: "+ t.productIdentifier);
			trace("productQuantity: "+t.productQuantity);
			trace("date: "+t.date);
			trace("receipt: "+t.receipt);
			trace("error: "+t.error);
			trace("originalTransaction: "+t.originalTransaction);
			if(t.originalTransaction)
				printTransaction(t.originalTransaction);
			trace("---------end of print transaction----------------------------");
		}		
	}
}