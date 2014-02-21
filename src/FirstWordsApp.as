package
{
	import com.Assets;
	import com.Dimentions;
	import com.controller.Progressor;
	import com.sticksports.nativeExtensions.flurry.Flurry;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class FirstWordsApp extends Sprite
	{
		[Embed(source="assets/logo.png")]
		private var logo : Class;
		private var _logo:Image;
		public var screensLayer:Sprite;
		public var navLayer:Sprite;
		public function FirstWordsApp()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			screensLayer=new Sprite();
			navLayer=new Sprite();
			addChild(screensLayer);
			addChild(navLayer);
			Assets.load();
			_logo = addChild(new Image(Texture.fromBitmap(new logo()))) as Image;
			Starling.juggler.delayCall(start,2);
			_logo.x= (Dimentions.WIDTH-_logo.width)/2;
			_logo.y= (Dimentions.HEIGHT-_logo.height)/2;
			//Flurry.startSession("FGJG54WS4ZBX3DYR8T8Q");//heb
			//Flurry.startSession("YR2VKK8QV4KB67S9HWKZ");//amazon
			Flurry.startSession("MRGRZM7YSBQK5FQ3FFVC");//all
			
		}
		
		private function start():void{
			removeChild(_logo);
			
			var progressor:Progressor = new Progressor(this);
			
		}
		
		
		
	}
}