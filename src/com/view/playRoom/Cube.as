package com.view.playRoom
{
	import flash.display.Bitmap;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Cube extends PlayItem
	{
		[Embed(source="../../../assets/cubes/cube1.png")]
		private var cube1 : Class;
		[Embed(source="../../../assets/cubes/cube2.png")]
		private var cube2 : Class;
		[Embed(source="../../../assets/cubes/cube3.png")]
		private var cube3 : Class;
		[Embed(source="../../../assets/cubes/cubeLion.png")]
		private var cubeLion : Class;
		[Embed(source="../../../assets/cubes/cubeMonkey.png")]
		private var cubeMonkey : Class;
		
		
		public function Cube(space:Space,cbType:CbType,xx:int,yy:int,indx:uint)
		{
			super(space,cbType,xx,yy);
			
		}
		
		override protected function createBody(cbType:CbType,xx:int,yy:int):void{
			_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
			_body.shapes.add( new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.wood() ) );
			super.createBody(cbType,xx,yy);
			
		}
		
		override protected function createMaterial():void{
			_material = new Sprite();
			var btnmp:Bitmap;
			var rand:Number = Math.random()*5;
			if(rand<1){
				btnmp = new cube1();
			}else if(rand<2){
				btnmp = new cube2();
				
			}else if(rand<3){
				btnmp = new cube3();
				
			}else if(rand<4){
				btnmp = new cubeMonkey();
				
				
			}else if(rand<5){
				btnmp = new cubeLion();
				
			}
			_material.addChild( Image.fromBitmap( btnmp ) ) as Sprite;
			//_material.pivotX = _material.width >> 1;
			//_material.pivotY = _material.height >> 1;
		}
		
		
	}
}