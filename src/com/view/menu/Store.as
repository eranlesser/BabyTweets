package com.view.menu
{
	import com.Dimentions;
	import com.model.Session;
	import com.utils.InAppPurchaser;
	import com.utils.InApper;
	import com.utils.Monotorizer;
	
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
	[Embed(source="../../../assets/home/home.png")]
	private var home : 			Class;

	private var _inApper:InAppPurchaser;
	private var _ageValidator:AgeValidator;
	private var _purchase:Button;
	private var _restore:Button;
	public var goHome:Signal = new Signal();
		public function Store()
		{
			init();
			
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			var bgr:Image = new Image(Texture.fromBitmap(new bg()));
			addChild(bgr);
			var homebg:Image = addChild(new Image(Texture.fromBitmap(new home()))) as Image; 
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
			_purchase.y=Dimentions.HEIGHT/2-_purchase.height; // iphone 100 , ipad 72
			_purchase.fontSize=24;
			_purchase.addEventListener(starling.events.Event.TRIGGERED,buyFullVersion);
			
			_restore = new Button(Texture.fromBitmap(new btn()),"Restore Purchase");
			_restore.fontColor = 0xFFFFFF;
			addChild(_restore);
			_restore.x=Dimentions.WIDTH/2+22;;
			_restore.y=Dimentions.HEIGHT/2-_restore.height; // iphone 100 , ipad 72
			_restore.fontSize=24;
			_restore.addEventListener(starling.events.Event.TRIGGERED,onRestoreClicked);
			_ageValidator = new AgeValidator();
			addChild(_ageValidator);
			_ageValidator.x = (this.width - _ageValidator.width)/2;
			_ageValidator.y=280;
			_ageValidator.goodAnswer.add(setPurchaseState);
			addEventListener(Event.ADDED_TO_STAGE,setPurchaseState);
			initInapper();
			setPurchaseState();
		}
		
		private function setPurchaseState(e:Event=null):void
		{
			if(_ageValidator.confirmed){
				_ageValidator.visible=false;
				_restore.visible=true;
				_purchase.visible=true;
			}else{
				_ageValidator.visible=true;
				_restore.visible=false;
				_purchase.visible=false;
			}
		}
		private function onInApperEvent(eventType:String,data:Object=null):void{
			switch(eventType){
				case InApper.PRODUCT_TRANSACTION_SUCCEEDED:
					_inApper.signal.remove(onInApperEvent);
					Session.fullVersionEnabled=true;
					Monotorizer.logEvent("store","fullversionenabled",1);
					break;
				//				case InApper.PRODUCT_RESTORE_SUCCEEDED:
				//					Session.fullVersionEnabled=true;
				//					break;
			}
		}
		private function onRestoreClicked(e:Event):void{
			
			
			_inApper.restoreTransactions();
		}
		
		private function buyFullVersion():void{
			//_inApper.purchase("babyTweetsHeb.fullVersion",1);
			_inApper.purchase(Session.inAppFullVersionId,1);
		}
		
		private function initInapper():void{
			if(!_inApper){
				if(Session.OS=="IOS"){
					_inApper = new InApper();
					_inApper.signal.add(onInApperEvent);
				}else{
					//_inApper = new InApperAndroid();
				}
			}
		}
	}
}
import com.Dimentions;
import com.model.Session;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

class AgeValidator extends Sprite{
	
		
	public var goodAnswer:Signal = new Signal();
	private var _tField:flash.text.TextField;
	public var confirmed:Boolean=false;
	private var _bg:Image;
	public function AgeValidator(){
		init();
	}
	
	
	override public function set visible(value:Boolean):void{
		super.visible=value;
		_tField.visible=value;
	}
	
	private function init():void{
		var tf:starling.text.TextField = new starling.text.TextField(400,100,"Please insert year of birth","verdana",28,0x002661);
		addChild(tf);
		tf.x=(width-tf.width)/2
		_tField = new flash.text.TextField();
		// Create default text format
		var textFormat:TextFormat = new TextFormat("Arial", 28, 0x000000);
		textFormat.align = TextFormatAlign.CENTER;
		_tField.defaultTextFormat = textFormat;
		// Set text input type
		_tField.type = TextFieldType.INPUT;
		// Set background just for testing needs
		_tField.height=40;
		_tField.background = true;
		_tField.border=true;
		_tField.borderColor = 0x002661;
		//_tField.backgroundColor = 0x333333;
		Starling.current.nativeOverlay.addChild(_tField);
		//_tField.visible=false;
		_tField.x=(Dimentions.WIDTH-_tField.width)/2;
		_tField.y=(Dimentions.HEIGHT-_tField.height)/2+30;
		_tField.maxChars=4;
		_tField.addEventListener(flash.events.Event.CHANGE,onGoodAnswer);
		addEventListener(starling.events.Event.REMOVED_FROM_STAGE,function(e:starling.events.Event):void{
			_tField.visible=false;
			_tField.text="";
		});
	}
	
	protected function onGoodAnswer(event:flash.events.Event):void
	{
		// TODO Auto-generated method stub
		if(int(_tField.text)<=1996 && int(_tField.text)>=1800){
			confirmed = true;
			goodAnswer.dispatch();
		}
		if(_tField.text=="alma"){
			Session.fullVersionEnabled=true;
			confirmed = true;
			goodAnswer.dispatch();
		}
		
	}
}