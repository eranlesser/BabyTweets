package com.model.rawData
{
	public class Transportation
	{
		public function Transportation()
		{
		}
		
		
		public static var data:XML = 
			<data type="whereScene" backGround="transportation" folder="transportation"  thumbNail="transportationTmb">
				<item   groupId="boat" qsound="8.mp3" asound="9.mp3">
					<rect vector="10,10,500,380"/>
				</item>
				<item  qsound="2.mp3" asound="3.mp3" groupId="car">
					<rect vector="505,10,500,380"/>
				</item>
				<item  qsound="6.mp3" asound="7.mp3" groupId="truck">
					<rect vector="10,390,500,380"/>
				</item>
				<item  qsound="4.mp3" asound="5.mp3" groupId="plane">
					<rect vector="505,390,500,380"/>
				</item>
			</data>;
	}
}