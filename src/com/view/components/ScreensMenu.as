package com.view.components
{
	import com.Assets;
	import com.Dimentions;
	import com.model.ScreenModel;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.utils.InAppPurchaser;
	import com.utils.InApper;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ScreensMenu extends Sprite
	{
		[Embed(source="../../../assets/bonus.png")]
		private var bonus : 			Class;
		[Embed(source = "../../../assets/btn.png")] 
		private static const btn:Class;
		private var _restoreButton:Button;
		private var _buyButton:Button;
		private var _inApper:InAppPurchaser;
		private var playRoomThmb:ThumbNail;
		private var _screenThumbs:Vector.<ThumbNail> = new Vector.<ThumbNail>();
		public var gotoSignal:Signal = new Signal();
		public function ScreensMenu(screens:ScreensModel)
		{
			init(screens);
			setSelectedScreen();
			initInapper();
			//Starling.juggler.delayCall(initIPurchases,3);
		}
		
		
		
		private function onsessionChanged():void{
			trace("onsessionChanged","Session.fullVersionEnabled",Session.fullVersionEnabled)
			//update bonus screen
			playRoomThmb.locked = false;//!Session.playRoomEnabled;
			//update selected screen + inapp purchase
			//setSelectedScreen();
			for(var i:uint = 0;i<_screenThumbs.length;i++){
				(_screenThumbs[i]).locked=false;
			}
			_restoreButton.visible = false//!Session.fullVersionEnabled;
			_buyButton.visible = false//!Session.fullVersionEnabled;
		}
		
		private function init(screens:ScreensModel):void
		{
			var i:int=0;
			var n:int=0;
			var wdt:uint=170;
			var hgt:uint=136;
			var gap:uint=12;
			for each(var screen:ScreenModel in screens.screens){
				if(screen.thumbNail!=""){
					var menuThmb:ThumbNail = new ThumbNail(Assets.getAtlas("thumbs").getTexture(screen.thumbNail),i);
					_screenThumbs.push(menuThmb);
					menuThmb.x = (n%4)*wdt + (n%4)*gap;//menuThmb.x-5;
					menuThmb.y = Math.floor(n/4)*(hgt+gap);//menuThmb.y-5;
					addChild(menuThmb);
					menuThmb.addEventListener(starling.events.Event.TRIGGERED,function onTriggered(e:starling.events.Event):void{
						var thmbNail:ThumbNail = ThumbNail(Button(e.target).parent);
						if(thmbNail.locked){
							//Flurry.getInstance().logEvent("productStore.available",productStore.available);
							buyFullVersion();
						}else{
							gotoSignal.dispatch(thmbNail.index);
						}
					});
					n++;
				}//if
				i++;
			}//for
			playRoomThmb = new ThumbNail(Assets.getAtlas("thumbs").getTexture("plane"),-2,new Image(Texture.fromBitmap(new bonus())));
			addChild(playRoomThmb);
			playRoomThmb.addEventListener(starling.events.Event.TRIGGERED,function onTriggered(e:starling.events.Event):void{
				gotoSignal.dispatch(ThumbNail(Button(e.target).parent).index);
			});
			playRoomThmb.x = (n%4)*wdt + (n%4)*gap;//menuThmb.x-5;
			playRoomThmb.y = Math.floor(n/4)*(hgt+gap);//menuThmb.y-5;
			x=(Dimentions.WIDTH-width)/2;
			_restoreButton = new Button(Texture.fromBitmap(new btn()),"RESTORE TRANSACTIONS");
			addChild(_restoreButton);
			_restoreButton.x=12;
			_restoreButton.y=-100; // iphone 100 , ipad 72
			_restoreButton.fontSize=24;
			_restoreButton.fontColor=0x003B94;
			_restoreButton.addEventListener(Event.TRIGGERED,onRestoreClicked);
			_restoreButton.visible = !Session.fullVersionEnabled;
			_buyButton = new Button(Texture.fromBitmap(new btn()),"Buy Full Version");
			_buyButton.fontSize=24;
			_buyButton.fontColor=0x003B94;
			addChild(_buyButton);
			_buyButton.x=this.width-12-_buyButton.width;
			_buyButton.y=-100;// iphone 100 , ipad 72
			_buyButton.addEventListener(Event.TRIGGERED,buyFullVersion);
			_buyButton.visible = !Session.fullVersionEnabled;
		}//function
		
		public function setSelectedScreen():void{
			for(var i:uint = 0;i<_screenThumbs.length;i++){ // subtract restore btn
				if(i>Session.FREE_THUMBS_COUNT-1 && !Session.fullVersionEnabled){//apply lock
					(_screenThumbs[i]).locked=true;
				}else{
					(_screenThumbs[i]).locked=false;
				}
				if(_screenThumbs[i].index==Session.currentScreen){//apply selected screen
					_screenThumbs[i].selected = true;
				}else{
					_screenThumbs[i].selected = false;
				}
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
				Session.changed.add(onsessionChanged);
			}
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
		
	}
}


import com.Assets;
import com.Dimentions;
import com.utils.filters.GlowFilter;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class ThumbNail extends Sprite{
	public var index:int;
	private var _btn:Button;
	private var _selectedFrame:Button;
	private var _lock:Image;
	private var isBonusThumb:Boolean=false;
	function ThumbNail(asset:Texture,indx:int,lock:Image=null){
		var frame:Button = new Button((getFrame(1)))
		_selectedFrame = new Button((getFrame(2)))
		_selectedFrame.filter=new GlowFilter(0x041626,1,12,12);
		addChild(frame);
		addChild(_selectedFrame);
		_selectedFrame.visible=false;
		_btn = new Button(asset);
		addChild(_btn)
		_btn.x=(frame.width-_btn.width)/2;
		_btn.y=(frame.height-_btn.height)/2;
		if(lock){//bonus
			_lock=lock;
			_lock.x=(frame.width-_lock.width)/2;
			_lock.y=-15;
			isBonusThumb=true;
		}else{
			_lock = new Image(Texture.fromBitmap(new Assets.Lock));
			_lock.x=(frame.width-_lock.width)/2;
			_lock.y=(frame.height-_lock.height)/2;
			_lock.alpha=0.7;
			_lock.filter = new GlowFilter(0xEDFF19,1,6,6);
		}
		addChild(_lock);
		_lock.touchable=false;
		index=indx;
		
	}
	
	private function getFrame(lineWidth:uint):Texture{
			var nBox:Shape = new Shape();
			nBox.graphics.lineStyle(1,0x008DB2)
			nBox.graphics.beginFill(0xFFFFFF);
			nBox.graphics.drawRect(0,0,170,136);
			nBox.graphics.endFill();
			
			var nBMP_D:BitmapData = new BitmapData(172, 138, true, 0x00000000);
			nBMP_D.draw(nBox);
			
			var nTxtr:Texture = Texture.fromBitmapData(nBMP_D, false, false);
			return nTxtr;
	}
	
	public function set selected(val:Boolean):void{
		_selectedFrame.visible=val;
	}
	
	public function set locked(val:Boolean):void{
		_lock.visible=val;
		if(!isBonusThumb){
			this.touchable = !val;
		}
	}
	
	public function get locked():Boolean{
		return _lock.visible;
	}
	
}