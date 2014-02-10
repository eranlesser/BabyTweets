package com.view.layouts
{
	import com.Dimentions;
	
	import starling.display.Sprite;

	public class ThreeLayout extends Layout
	{
		private const numItems:int = 3;
		public function ThreeLayout(view:Sprite)
		{
			super(view);
			init();
		}
		
		private function init():void{
			const gap:int= (Dimentions.WIDTH - 3*300)/4;
			var itemWidth:int = 300;
			for(var i:uint=0;i<numItems;i++){
				addPlaceHolder(gap+i*itemWidth+i*gap,(Dimentions.HEIGHT)/2,itemWidth,320);
			}
		}
	}
}