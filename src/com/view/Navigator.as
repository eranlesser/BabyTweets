package com.view
{
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Navigator extends Sprite
	{
		
		
		[Embed(source="../../assets/confBut.png")]
		private var wBird : 			Class;
		public var openMenuSignal:Signal = new Signal();
		public function Navigator()
		{
			init();
		}
		
		private function init():void{
			addMenuBtn();
		}
		
		private function addMenuBtn():void{
			var whereBird:Button = new Button(Texture.fromBitmap(new wBird()));
			addChild(whereBird);
			whereBird.x=8;
			whereBird.y=8;
			whereBird.addEventListener(starling.events.Event.TRIGGERED,openMenu);
		}
		
		
		private function openMenu():void{
			openMenuSignal.dispatch();
		}
	}
}