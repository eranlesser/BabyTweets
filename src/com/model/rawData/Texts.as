package com.model.rawData
{
	import com.model.Session;
	import com.view.components.FlagsMenu;
	
	import flash.utils.Dictionary;

	public class Texts
	{
		
		
		private var _hebTexts:Dictionary = new Dictionary();
		private var _engTexts:Dictionary = new Dictionary();
		private var _frTexts:Dictionary = new Dictionary();
		private var _ruTexts:Dictionary = new Dictionary();
		public function Texts()
		{
			init();
		}
		
		private function init():void{
			_hebTexts["nav"]="תפריט";
			_hebTexts["about"]="אודות";
			_hebTexts["menu"]="תפריט";
			_hebTexts["title"]="ציוצים ראשונים";
			_engTexts["nav"]="Screens";
			_engTexts["about"]="About";
			_engTexts["menu"]="MENU";
			_frTexts["menu"]="MENU";
			_ruTexts["menu"]="MENU";
			_engTexts["title"]="Baby Tweets";
			_frTexts["title"]="Mes premiers mots";
			_ruTexts["title"]="Детский щебет";
			_hebTexts["play"]="משחק";
			_engTexts["play"]="PLAY";
			_frTexts["play"]="PLAY";
			_ruTexts["play"]="PLAY";
			_frTexts["about"]="About";
			_ruTexts["about"]="About";
			_frTexts["nav"]="Screens";
			_ruTexts["nav"]="Screens";
		}
		
		private function getDictionarr(lang:String):Dictionary{
			var dict:Dictionary;
			switch(lang){
				case FlagsMenu.ISRAEL:
					dict = _hebTexts;
					break;
				case FlagsMenu.USA:
					dict = _engTexts;
					break;
				case FlagsMenu.FRANCE:
					dict = _frTexts;
					break;
				case FlagsMenu.RUSSIA:
					dict = _ruTexts;
					break;
			}
			return dict;
		}
		
		public function getText(id:String):String{
			if(Session.lang==FlagsMenu.ISRAEL){
				return flip(_hebTexts[id]);
			}else{
				return getDictionarr(Session.lang)[id];
			}
		}
		
		private function flip(str:String):String{
			if(Session.lang!=FlagsMenu.ISRAEL){
				return str;
			}
			var newStr:String = "";
			for(var i:int=str.length-1;i>=0;i--){
				newStr = newStr + str.charAt(i);
			}
			
			return newStr;
		}
		
		public function getAboutText():String{
			var txt:String="When we follow the general development of a baby, one observes that language and speech are primary components in the infant's development.  At the outset the baby pronounces parts of words or just gibberish.  As he continues to develop, at age one or two years, he expresses himself in complete words related to his surroundings and supporters. The first word the child acquires are connected to his immediate world such as: toys, pets, family members, body parts, clothing etc. He will pronounce words such as: daddy, mommy, ball (Teddy) bear, bottle, head, dog etc. When he is asked by to identify an object from pictures in books or in various choice games, he knows to choose the correct object even if he pronounces the words incorrectly. In this application we have concentrated on the baby's ability to identify individual objects in a picture showing a number of objects familiar to infants from their surroundings. The baby, from one and a half to two years old, is asked, by a pleasant voice, to point to a particular object in a group of pictures and when he touches the correct picture he receives positive reinforcement.  In the event he chooses incorrectly he will hear the correct name of the object sought and in this way will enlarge his vocabulary. The infant at this age is capable of learning new words every day and his vocabulary generally contains hundreds of words and this before he knows how to form words into sentences. This application is designed to aid you the parent to expose the infant to a variety of words thus enriching his language skills."
			switch(Session.lang){
				case  FlagsMenu.USA:
					txt = "When we follow the general development of a baby, one observes that language and speech are primary components in the infant's development.  At the outset the baby pronounces parts of words or just gibberish.  As he continues to develop, at age one or two years, he expresses himself in complete words related to his surroundings and supporters. The first word the child acquires are connected to his immediate world such as: toys, pets, family members, body parts, clothing etc. He will pronounce words such as: daddy, mommy, ball (Teddy) bear, bottle, head, dog etc. When he is asked by to identify an object from pictures in books or in various choice games, he knows to choose the correct object even if he pronounces the words incorrectly. In this application we have concentrated on the baby's ability to identify individual objects in a picture showing a number of objects familiar to infants from their surroundings. The baby, from one and a half to two years old, is asked, by a pleasant voice, to point to a particular object in a group of pictures and when he touches the correct picture he receives positive reinforcement.  In the event he chooses incorrectly he will hear the correct name of the object sought and in this way will enlarge his vocabulary. The infant at this age is capable of learning new words every day and his vocabulary generally contains hundreds of words and this before he knows how to form words into sentences. This application is designed to aid you the parent to expose the infant to a variety of words thus enriching his language skills."
					break;
				case  FlagsMenu.RUSSIA:
					txt = "When we follow the general development of a baby, one observes that language and speech are primary components in the infant's development.  At the outset the baby pronounces parts of words or just gibberish.  As he continues to develop, at age one or two years, he expresses himself in complete words related to his surroundings and supporters. The first word the child acquires are connected to his immediate world such as: toys, pets, family members, body parts, clothing etc. He will pronounce words such as: daddy, mommy, ball (Teddy) bear, bottle, head, dog etc. When he is asked by to identify an object from pictures in books or in various choice games, he knows to choose the correct object even if he pronounces the words incorrectly. In this application we have concentrated on the baby's ability to identify individual objects in a picture showing a number of objects familiar to infants from their surroundings. The baby, from one and a half to two years old, is asked, by a pleasant voice, to point to a particular object in a group of pictures and when he touches the correct picture he receives positive reinforcement.  In the event he chooses incorrectly he will hear the correct name of the object sought and in this way will enlarge his vocabulary. The infant at this age is capable of learning new words every day and his vocabulary generally contains hundreds of words and this before he knows how to form words into sentences. This application is designed to aid you the parent to expose the infant to a variety of words thus enriching his language skills."
					break;
				case  FlagsMenu.FRANCE:
					txt = "Lorsqu’on observe le développement d’un nourrisson, on constate que le vocabulaire et la parole sont les principaux composants de son développement. Dans son plus jeune âge, le nourrisson prononce des simples syllabes et des mots qui nous sont incompréhensibles. Plus tard, à l’âge d’un ou deux ans, il s’exprime avec des mots complets associés à son entourage Les premiers mots qu’apprend l’enfant sont des mots de son proche entourage, tels que: les jouets, les animaux, les membres de la famille, des parties du corps, les vêtements, etc. Il prononcera des mots tels que : papa, maman, nounours, tête, chien etc. Quand on lui demandera d’identifier un objet parmi des images dans un livre, il saura choisir la juste image même s’il ne prononcera pas son nom correctement. Cette application a été spécialement conçue pour accroitre le vocabulaire de l’enfant et lui permettre d’identifier de nombreux objets parmi des images qui lui sont présentées. L’enfant est demandé par une douce voix de pointer un certain objet parmi plusieurs images. S’il réussit, il sera complimenté. Sinon, il entendra le nom correct de l’objet désigné, et de cette .répertoire lexical façon élargira son Un enfant de cet âge est capable d’apprendre de nouveaux mots tous les jours, ce qui lui permet d’avoir de nombreux mots dans son répertoire, avec lesquels il pourra par la suite former des phrases complètes." 
					break;
				
			}
			txt = txt + "\n\n\n Developed by Creative Lamas";
			return txt;
		}
		
		public function getMenuTextSize():uint{
			if(Session.lang==FlagsMenu.ISRAEL){
				return 18;
			}else{
				return 14;
			}
		}
		
	}
}