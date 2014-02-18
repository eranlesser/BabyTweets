package com.view.menu
{
	import com.model.Session;
	import com.utils.InAppPurchaser;
	import com.utils.InApper;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Store extends Sprite
	{
	[Embed(source="../../../assets/home/homeBtn.png")]
	private var homeBt : 			Class;
	private var _inApper:InAppPurchaser;
	public var goHome:Signal = new Signal();
		public function Store()
		{
			super();
			init();
			
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			var homeBut:Button = new Button( Texture.fromBitmap(new homeBt()) );
			addChild(homeBut);
			homeBut.x=8;
			homeBut.y=8;
			homeBut.addEventListener(starling.events.Event.TRIGGERED, function():void{
				goHome.dispatch()
			});
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
		
		public function buyFullVersion():void{
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
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;

class ChildSafe extends Sprite{
	[Embed(source="../../../assets/menu/whiteBg.png")]
	private var bg : 			Class;
	[Embed(source="../../../assets/menu/bg.png")]
	private var bg2 : 			Class;
	
	public var goodAnswer:Signal = new Signal();
	private var _tField:flash.text.TextField;
	private var _alert:Sprite = new Sprite();
	
	
	public function start():void{
		_tField.visible=true;
	}
	
	public function stop():void{
		_tField.text="";
		_tField.visible=false;
	}
	
	private function init():void{
		_alert.addChild(new Image(Texture.fromBitmap(new bg())));
		var tf:starling.text.TextField = new starling.text.TextField(400,100,"Are you an adult?","verdana",24,0XFF530D);
		_alert.addChild(tf);
		
		tf.x=(_alert.width-tf.width)/2
		var qf:starling.text.TextField = new starling.text.TextField(400,100,"20 - 6 =","Verdana",22,0x99583D);
		_alert.addChild(qf);
		qf.y=80;
		qf.x=42;
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
		addChild(new Image(Texture.fromBitmap(new bg2())));
		addChild(_alert);
		_alert.x=(Dimentions.WIDTH-_alert.width)/2;
		_alert.y=(Dimentions.HEIGHT-_alert.height)/2;
		
	}
	
	protected function onGoodAnswer(event:flash.events.Event):void
	{
		// TODO Auto-generated method stub
		if(_tField.text=="14"){
			goodAnswer.dispatch();
		}
		
	}
}