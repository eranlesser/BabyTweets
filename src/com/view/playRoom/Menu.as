package com.view.playRoom
{
	import com.Assets;
	import com.Dimentions;
	import com.model.ScreenModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Menu extends Sprite
	{
		private var _items:Vector.<MenuItem>;
		private var _atlas:TextureAtlas;
		
		public var itemDropped:Signal = new Signal();
		
		
		public static const HEIGHT:int = 90;
		public function Menu()
		{
			init()
		}
		
		public function set model(data:ScreenModel):void{
			if(_atlas){
				return;
			}
			_atlas = Assets.getAtlas(data.groupName);
			for each(var item:XML in data.menu.item){
				addMenuItem(item);
			}
		}
		
		public function set enabled(bool:Boolean):void{
			this.alpha = 0.5;
		}
		
		private function init():void{
			addBg();
			_items = new Vector.<MenuItem>();
			
		}
		
		private function addMenuItem(item:XML):void{
			var menuItem:MenuItem = new MenuItem(_atlas.getTexture(item.@image),item.@image,item.@recycled=="true");
			addChild(menuItem);
			menuItem.x = _items.length * (Menu.HEIGHT+30)+50;
			menuItem.y = menuItem.y + Dimentions.HEIGHT - HEIGHT - 2;
			_items.push(menuItem);
			menuItem.dropped.add(dropped);
		}
		private function dropped(x:int,y:int,item:MenuItem):void{
			item.resetPosition();
			if(y>620){
				return;
			}
			itemDropped.dispatch(x,y,item.id);
			if(item.recycled){
				
			}else{
				//item.dropped.remove(dropped);
				item.removeFromParent();
			}
		}
		
		private function addBg():void{
			var btmpData:BitmapData = new BitmapData(Dimentions.WIDTH,HEIGHT,false,0xFFFFFF);
			var bg:Bitmap = new Bitmap(btmpData);
			var img:DisplayObject = addChild(new Image(Texture.fromBitmap(bg)));
			img.y=Dimentions.HEIGHT - HEIGHT - 2;
		}
		
		public function reset():void{
			for each(var menuItem:MenuItem in _items){
				if(menuItem.parent!=this){
					addChild(menuItem);
					menuItem.resetPosition();
					menuItem.dropped.add(dropped);
				}
			}
		}
	}
}