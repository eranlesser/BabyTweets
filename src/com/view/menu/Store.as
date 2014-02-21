package com.view.menu
{
	import com.Dimentions;
	import com.model.Session;
	import com.utils.InAppPurchaser;
	import com.utils.InApper;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Store extends Sprite
	{
		[Embed(source="../../../assets/confBut.png")]
		private var wBird : 			Class;
	[Embed(source="../../../assets/store/bgg.png")]
	private var btn : 			Class;
	[Embed(source="../../../assets/menu/bg.png")]
	private var bg : 			Class;

	private var _inApper:InAppPurchaser;
	private var _ageValidator:AgeValidator;
	private var _purchase:Button;
	private var _restore:Button;
	public var goHome:Signal = new Signal();
		public function Store()
		{
			init();
			
		}
		
		public function start():void{
			_ageValidator.start();	
		}
		
		public function stop():void{
			_ageValidator.stop();
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			var bgr:Image = new Image(Texture.fromBitmap(new bg()));
			addChild(bgr);
			var homeBut:Button = new Button( Texture.fromBitmap(new wBird()) );
			addChild(homeBut);
			homeBut.x=8;
			homeBut.y=8;
			homeBut.addEventListener(starling.events.Event.TRIGGERED, function():void{
				goHome.dispatch()
			});
			_purchase = new Button(Texture.fromBitmap(new btn()),"Buy");
			_purchase.fontColor = 0xFFFFFF;
			addChild(_purchase);
			_purchase.x=Dimentions.WIDTH/2-_purchase.width-22;;
			_purchase.y=400; // iphone 100 , ipad 72
			_purchase.fontSize=24;
			_purchase.addEventListener(starling.events.Event.TRIGGERED,buyFullVersion);
			
			_restore = new Button(Texture.fromBitmap(new btn()),"Restore Purchase");
			_restore.fontColor = 0xFFFFFF;
			addChild(_restore);
			_restore.x=Dimentions.WIDTH/2+22;;
			_restore.y=400; // iphone 100 , ipad 72
			_restore.fontSize=24;
			_restore.addEventListener(starling.events.Event.TRIGGERED,onRestoreClicked);
			_ageValidator = new AgeValidator();
			addChild(_ageValidator);
			_ageValidator.x = (this.width - _ageValidator.width)/2;
			_ageValidator.y=220;
			initInapper();
		}
		private function onInApperEvent(eventType:String,data:Object=null):void{
			switch(eventType){
				case InApper.PRODUCT_TRANSACTION_SUCCEEDED:
					Session.fullVersionEnabled=true;
					break;
				//				case InApper.PRODUCT_RESTORE_SUCCEEDED:
				//					Session.fullVersionEnabled=true;
				//					break;
			}
		}
		private function onRestoreClicked(e:Event):void{
			
			_inApper.signal.addOnce(onInApperEvent);
			_inApper.restoreTransactions();
		}
		
		private function buyFullVersion():void{
			_inApper.signal.addOnce(onInApperEvent);
			//_inApper.purchase("babyTweetsHeb.fullVersion",1);
			_inApper.purchase(Session.inAppFullVersionId,1);
		}
		
		private function initInapper():void{
			if(!_inApper){
				if(Session.OS=="IOS"){
					_inApper = new InApper();
				}else{
					//_inApper = new InApperAndroid();
				}
			}
		}
	}
}
import com.Dimentions;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;

class AgeValidator extends Sprite{
	[Embed(source="../../../assets/menu/whiteBg.png")]
	private var bg : 			Class;
		
	public var goodAnswer:Signal = new Signal();
	private var _tField:flash.text.TextField;
	public var confirmed:Boolean=false;
	private var _bg:Image;
	public function AgeValidator(){
		init();
	}
	
	public function start():void{
		_tField.visible=true;
	}
	
	public function stop():void{
		_tField.text="";
		_tField.visible=false;
	}
	
	private function init():void{
		addChild(new Image(Texture.fromBitmap(new bg())));
		var tf:starling.text.TextField = new starling.text.TextField(400,100,"Please insert year of birth","verdana",24,0XFF530D);
		addChild(tf);
		tf.x=(width-tf.width)/2
		
		_tField = new flash.text.TextField();
		// Create default text format
		var textFormat:TextFormat = new TextFormat("Arial", 24, 0x000000);
		textFormat.align = TextFormatAlign.LEFT;
		_tField.defaultTextFormat = textFormat;
		// Set text input type
		_tField.type = TextFieldType.INPUT;
		// Set background just for testing needs
		_tField.height=40;
		_tField.background = true;
		_tField.border=true;
		_tField.backgroundColor = 0xffffff;
		Starling.current.nativeOverlay.addChild(_tField);
		_tField.visible=false;
		_tField.x=(Dimentions.WIDTH-_tField.width)/2+52;
		_tField.y=(Dimentions.HEIGHT-_tField.height)/2+12;
		_tField.addEventListener(flash.events.Event.CHANGE,onGoodAnswer);
		//addChild(_alert);
		//_alert.x=(Dimentions.WIDTH-_alert.width)/2;
		//_alert.y=(Dimentions.HEIGHT-_alert.height)/2;
		
	}
	
	protected function onGoodAnswer(event:flash.events.Event):void
	{
		// TODO Auto-generated method stub
		if(_tField.text=="14"){
			goodAnswer.dispatch();
			confirmed = true;
		}
		
	}
}