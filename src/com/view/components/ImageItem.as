package com.view.components{
	
import org.osflash.signals.Signal;
import starling.display.Image;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ImageItem extends Image{
	private var _questionSound:String;
	private var _answerSound:String;
	private var _hSound:String;
	private var _bg:Image;
	private var _frame:Image;
	private var _frameGood:Image;
	public var touched:Signal = new Signal();
	
	[Embed(source="../../../assets/frames/frame1.png")]
	private var frame : Class;
	[Embed(source="../../../assets/frames/frame5.png")]
	private var frameGood : Class;

	
	function ImageItem(texture:Texture,qsound:String,asound:String,hSound:String):void{
		_questionSound = qsound;
		_answerSound = asound;
		_hSound = hSound;
		super(texture);
		addEventListener(TouchEvent.TOUCH,onClick);
	}
	
	private function onClick(t:TouchEvent):void{
		if(t.getTouch(stage)&&(t.getTouch(stage).phase == TouchPhase.BEGAN)){
			touched.dispatch(this);
		}
	}
	
	public function get bg():Image
	{
		return _bg;
	}

	public function set bg(value:Image):void
	{
		_bg = value;
		_bg.addEventListener(TouchEvent.TOUCH,onClick);
		_frame = new Image(Texture.fromBitmap(new frame()));
		_frame.width=_bg.width+12;
		_frame.height=_bg.height+12;
		_frameGood = new Image(Texture.fromBitmap(new frameGood()));
		_frameGood.width=_bg.width+12;
		_frameGood.height=_bg.height+12;
		_frame.touchable=false;
	}
	
	public function get border():Image{
		return _frame;
	}
	public function get borderGood():Image{
		return _frameGood;
	}
	
	public function onGoodClick():void{
		_frame.parent.addChild(_frameGood);
		_frameGood.x=_frame.x;
		_frameGood.y=_frame.y;
	}

	public function get qSound():String
	{
		return _questionSound;
	}
	public function get aSound():String
	{
		return _answerSound;
	}
	
	public function get enhanceSound():String{
		return _hSound;
	}
	
}
}