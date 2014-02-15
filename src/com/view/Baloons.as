package com.view
{
	import com.model.ScreenModel;
	
	import flash.display.Stage;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Baloons extends IsScreen
	{
		private var _ballons:Vector.<ColoredBaloon>;
		private var _playIndex:uint=0;
		private var _space:Space;
		private static const GRAVITY_X : Number = 0;
		private static const GRAVITY_Y : Number = 3000;
		private static const STEP_TIME : Number = 0.01;
		[Embed(source="../../assets/balloons/baloonsBg.jpg")]
		private var bg : Class;
		public function Baloons(mdl:ScreenModel)
		{
			super(mdl);
		}
		
		private function createSpace():void
		{
			_space = new Space( new Vec2( GRAVITY_X, GRAVITY_Y ) );
			listenForEnterFrame();
		}
		
		public static const WALL_WIDTH:uint=22;
		private function createFloor():void
		{
			const floor:Body = new Body( BodyType.STATIC );
			
			// what are all these things?
			floor.shapes.add( new Polygon( Polygon.rect( 0, 0, 1024, 22 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 0, 0, 60, 768 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 708, 0, 22, 768 ) ) );
			
			floor.space = _space;
		}
		

		
		private function listenForEnterFrame() : void
		{
			var _nativeStage:Stage = Starling.current.nativeStage;
			addEventListener( starling.events.Event.ENTER_FRAME, function( event : starling.events.Event ) : void
			{
				//_hand.anchor1.setxy( _nativeStage.mouseX, _nativeStage.mouseY );
				_space.step( STEP_TIME );
				for (var i:int = 0; i < _space.liveBodies.length; i++) {
					var body:Body = _space.liveBodies.at(i);
					if (body.userData.graphicUpdate) {
						body.userData.graphicUpdate(body);
					}
				}
			});
			
		}
		
		
		
		override protected function init():void{
			super.init();
			_screenLayer.addChild(new Image(Texture.fromBitmap(new bg())));
			_ballons = new Vector.<ColoredBaloon>();
			createSpace();
			createFloor();
			var baloon:ColoredBaloon = new ColoredBaloon("red",_space,new CbType(),300,300);
			addChild(baloon.material);
			var blubaloon:ColoredBaloon = new ColoredBaloon("blu",_space,new CbType(),600,300);
			addChild(blubaloon.material);
			var greenbaloon:ColoredBaloon = new ColoredBaloon("green",_space,new CbType(),450,300);
			addChild(greenbaloon.material);
			var yellowbaloon:ColoredBaloon = new ColoredBaloon("yellow",_space,new CbType(),750,300);
			addChild(yellowbaloon.material);
			
			baloon.poped.addOnce(setWhoIs);
			blubaloon.poped.addOnce(setWhoIs);
			greenbaloon.poped.addOnce(setWhoIs);
			yellowbaloon.poped.addOnce(onLast);
			
			baloon.enable.add(onEnabled);
			blubaloon.enable.add(onEnabled);
			greenbaloon.enable.add(onEnabled);
			yellowbaloon.enable.add(onEnabled);
			
			_ballons.push(baloon);
			_ballons.push(blubaloon);
			_ballons.push(greenbaloon);
			_ballons.push(yellowbaloon);
			
			_ballons[0].isWho = true;		
			}
		
		
		private function onLast():void{
			closeCurtains();
			Starling.juggler.delayCall(super.dispatchDone,2);
		}
		
		override protected function playWhoIsSound():void{
			_wBirdNote.visible=true;
			_ballons[_playIndex].playQuestion();
		}
		
		
		private function onEnabled(val:Boolean):void{
			_wBirdNote.visible = !val;
		}
		
		private function setWhoIs():void{
			_playIndex++;
			_ballons[_playIndex].isWho = true;
			playWhoIsSound();
		}
		
	}
}
import com.view.Baloons;
import com.view.components.ParticlesEffect;
import com.view.playRoom.PlayItem;
import com.view.utils.SoundPlayer;

import flash.media.Sound;
import flash.net.URLRequest;

import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;


class ColoredBaloon extends PlayItem{
	[Embed(source="../../assets/balloons/blu.png")]
	private var bluBln : Class;
	[Embed(source="../../assets/balloons/green.png")]
	private var greenBln : Class;
	[Embed(source="../../assets/balloons/orangeBln.png")]
	private var orangeBln : Class;
	[Embed(source="../../assets/balloons/red.png")]
	private var redBln : Class;
	[Embed(source="../../assets/balloons/turkuizeBln.png")]
	private var turkuizeBln : Class;
	[Embed(source="../../assets/balloons/yellow.png")]
	private var yellowBln : Class;
	
	private var _color:String;
	private var _popSound:Sound;
	private var _qSound:Sound;
	private var _aSound:Sound;
	private var _isWho:Boolean=false;
	private var _btnmp:Image;
	public var enable:Signal = new Signal();
	public var poped:Signal = new Signal();
	function ColoredBaloon(clr:String,space:Space, cbType:CbType, xx:int, yy:int){
		_btnmp = getBaloon(clr);
		super(space, cbType, xx, yy);
		//_clrSound = new Sound(new URLRequest("../../assets/sounds/colors/"+clr+"_baloon.mp3"));
		_color = clr;
	}
	
	public function get colorSoundFile():String{
		return _color+".mp3";
	}
	
	public function set isWho(value:Boolean):void
	{
		_isWho = value;
	}
	
	public function playQuestion():void{
		if(_material.parent is Baloons && Baloons(_material.parent).isEnabled){
			Starling.juggler.delayCall(_qSound.play,1);
			enable.dispatch(false)
			Starling.juggler.delayCall(function():void{enable.dispatch(true)},2);
		}
	}
	
	private function playAnswer():void{
		if(_material.parent is Baloons && Baloons(_material.parent).isEnabled){
			_aSound.play();
			enable.dispatch(false)
			Starling.juggler.delayCall(function():void{enable.dispatch(true)},1.2);
		}
	}

	private function getBaloon(clr:String):Image{
		var soundManager:SoundPlayer = new SoundPlayer();
		var img:Image;
		switch(clr){
			case "blu":
				img = new Image(Texture.fromBitmap(new bluBln()));
				_qSound = soundManager.getSound("../../../assets/narration/","/colors/4.mp3");  
				_aSound = soundManager.getSound("../../../assets/narration/","/colors/5.mp3");  
			break;
			case "green":
				img = new Image(Texture.fromBitmap(new greenBln()));
				_qSound = soundManager.getSound("../../../assets/narration/","/colors/6.mp3");  
				_aSound = soundManager.getSound("../../../assets/narration/","/colors/7.mp3");  
			break;
			case "red":
				img = new Image(Texture.fromBitmap(new redBln()));
				_qSound = soundManager.getSound("../../../assets/narration/","/colors/2.mp3");  
				_aSound = soundManager.getSound("../../../assets/narration/","/colors/3.mp3");  
			break;
			case "yellow":
				img = new Image(Texture.fromBitmap(new yellowBln()));
				_qSound = soundManager.getSound("../../../assets/narration/","/colors/8.mp3");  
				_aSound = soundManager.getSound("../../../assets/narration/","/colors/9.mp3");  
			break;
		}
		return img;
		
	}
	
	override protected function createBody(cbType:CbType,xx:int,yy:int):void{
		_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
		_body.shapes.add( new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.rubber() ) );
		_body.gravMass = -(0.3)+0.2*Math.random();
		super.createBody(cbType,xx,yy);
		
	}
	
		
	public function get body():Body{
		return _body;
	}
	
	override protected function createMaterial():void{
		_material = new Sprite();
		
		_material.addChild( ( _btnmp ) ) as Sprite;
		_popSound = new Sound(new URLRequest("../../../assets/sounds/playroom/pop.mp3"));
		_material.addEventListener(TouchEvent.TOUCH,onTouch);
	}
	
	
	public function pop():void{
		
		var particlesEffect:ParticlesEffect;
		particlesEffect = new ParticlesEffect();
		particlesEffect.width=_material.width/10;
		particlesEffect.height=_material.height/10;
		particlesEffect.x=_material.x+_material.width/2;
		particlesEffect.y=_material.y+_material.height/2;
		_material.parent.addChild(particlesEffect);
		particlesEffect.start("jfish");
		_popSound.play();
		Starling.juggler.delayCall(removeParticles,0.3,particlesEffect);
		_material.removeFromParent(true);
		_space.bodies.remove(_body);
	}
	
	private function removeParticles(particlesEffect:ParticlesEffect):void{
		particlesEffect.stop();
		//particlesEffect.dispose();
		particlesEffect.parent.removeChild(particlesEffect);
		poped.dispatch();
	}
	
	private function onTouch(e:TouchEvent):void{
		if(e.getTouch(_material.stage).phase == TouchPhase.BEGAN){
			if(_material.parent is Baloons && Baloons(_material.parent).isEnabled){
				if(!_isWho ){
					playAnswer();
					return;
				}
				_material.removeEventListener(TouchEvent.TOUCH,onTouch);
				pop();
			}
		}
	}
}