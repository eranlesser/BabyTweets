package com.view
{
	import com.Assets;
	import com.Dimentions;
	import com.model.Item;
	import com.model.ScreenModel;
	import com.view.components.ImageItem;
	import com.view.components.ParticlesEffect;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class WhereIsScene extends IsScreen
	{
		private var _whereIsBtns:Vector.<Button>;
		public function WhereIsScene(mdl:ScreenModel)
		{
			super(mdl);
			_whereIsBtns = new Vector.<Button>();
		}
		private var _clics:uint=0;
		private var _resoult:String="";
		private var _touchPoint:Point;

		override protected function init():void{
			super.init();
			var bg:Image = new Image(Texture.fromBitmap(Assets.getImage(_model.backGround)));
			_screenLayer.addChild(bg);
			bg.x = (Dimentions.WIDTH-bg.width)/2;
			bg.y = (Dimentions.HEIGHT-bg.height)/2;
			for(var i:uint=0;i<_model.numItems;i++){
				addItem(_model.distractor);
			}
			setItems();
			this.addEventListener(TouchEvent.TOUCH,function onMouseDown(e:TouchEvent):void{
				var touch:Touch = e.getTouch(stage);
				
				if(touch && (touch.phase == TouchPhase.BEGAN)){
					_clics++;
					_touchPoint = new Point(touch.globalX,touch.globalY);
					var x:int;
					var y:int;
					if(_clics==1){
						x=touch.globalX;
						y=touch.globalY;
						_resoult = _resoult + x.toString()+","+y.toString()+",";
					}else if(_clics==2){
						_resoult = _resoult + Math.round(touch.globalX-x).toString()+",";
					}else{
						_resoult = _resoult + Math.round(touch.globalY-y).toString();
						_clics=0;
						_resoult="";
					}
					
				}
			});
			
			
		}
		
		override protected function setItems():Boolean{
			if(!super.setItems()){
				return false;
			}
			setWhoIs(_model.whoIsItem)
			return true;
		}
		
		private function setWhoIs(item:Item):void{
			for each(var btn:Button in _whereIsBtns){
				_screenLayer.removeChild(btn);
			}
			_whoIs = item;
			for each(var rect:Rectangle in item.rects){
				var shp:Shape = new Shape();
				shp.graphics.beginFill(0x333333);
				shp.graphics.drawRect(0,0,rect.width,rect.height);
				shp.graphics.endFill();
				var btmData:BitmapData = new BitmapData(shp.width,shp.height);
				btmData.draw(shp);
				var wiBtn:Button;
				var img:Image = new Image(Texture.fromBitmapData(btmData));
				wiBtn = new Button(img.texture);
				wiBtn.x = rect.x;
				wiBtn.y = rect.y;
				_screenLayer.addChild(wiBtn);
				if(!_categorySoundPlaying){//wait for categorySound
					playWhoIsSound();
				}
				wiBtn.addEventListener(starling.events.Event.TRIGGERED,function onGood():void{
					if(onGoodClick()){
						wiBtn.removeEventListener(starling.events.Event.TRIGGERED, onGood);
						var touchEffect:ParticlesEffect = new ParticlesEffect();
						addChild(touchEffect);
						touchEffect.x=_touchPoint.x;
						touchEffect.y=_touchPoint.y;
						touchEffect.start("touchstar");
						touchEffect.alpha=0.6;
						Starling.juggler.delayCall(function():void{
							touchEffect.stop();
							removeChild(touchEffect);
						},1);

					}
				});
				wiBtn.alpha=0;
				_whereIsBtns.push(wiBtn);
			}
		}
		
		override protected function onWhereSoundDone(e:flash.events.Event):void{
			
			super.onWhereSoundDone(e);
		}
		
		
		
		private function addItem(item:Item):void{
			for each(var rect:Rectangle in item.rects){

			var shp:Shape = new Shape();
			shp.graphics.beginFill(0xFFFFFF);
			shp.graphics.drawRect(0,0,rect.width,rect.height);
			shp.graphics.endFill();
			var btmData:BitmapData = new BitmapData(shp.width,shp.height);
			btmData.draw(shp);
			var img:ImageItem = new ImageItem(Texture.fromBitmapData(btmData),item.qSound,item.aSound,item.hSound);
			img.x = rect.x;
			img.y = rect.y;
			img.alpha=0;
			_screenLayer.addChild(img);
			img.touched.add(onDistractorTouch);
			}
		}
	}
}