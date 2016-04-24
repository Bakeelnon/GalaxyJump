package {
	import flash.net.SharedObject;
	import world.Menu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	[SWF(width="400",height="480",frameRate="60")] //настройки flash player
	public class Game extends Engine {
		private var aScores:Array = [10, 9, 8, 7, 6]; //начальные очки игрока
		private var aName:Array = ["redefy", "redefy", "redefy", "redefy", "redefy"]; //имена лучших игроков
		/* В дальнейшем мы создадим меню с таблицей лучших игроков, для этого мы будем использовать SharedObject
		 * В этих двух массивах хранятся начальные имена и очки игроков */
		 
		public function Game ():void {
			super(400, 480, 60, false); //вызываем конструктор класса Engine
		}
		
		override public function init():void {
			createSharedObject(); //создаем SharedObject
			FP.screen.color = 0x000000; //цвет фона
			FP.world = new Menu; //начальный мир игры
			trace("Brick Jump started");
		}
		
		private function createSharedObject():void {
			var shared:SharedObject = SharedObject.getLocal("score"); //получаем SharedObject
			
			 if (!shared.data.aScores) { //если в объекте data свойство aScores == null
				shared.data.aScores = aScores; //записываем в data два массива с именами игроков 
				shared.data.aName = aName; //и их очками
				shared.flush();
			}
		}
	}
}