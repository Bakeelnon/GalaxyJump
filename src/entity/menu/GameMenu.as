package entity.menu {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.FP;

	public class GameMenu extends Entity {
		public var flagTweenUp:Boolean = false;
		public var flagTweenBack:Boolean = false;
		private var image:Image;
		private var tweens:NumTween;
		private var aEntity:Array;
		private var offsetY:Number;

		public function GameMenu(source:*, yy:Number, aEntity:Array, offsetY:Number = 110 ) {
			//В конструктор передаем класс с графикой менюшки, массив объектами Entity и смещение по оси y
			this.aEntity = aEntity;
			this.offsetY = offsetY;
			
			image = new Image(source);
			graphic = image;
			
			x = 40;
			y = yy;
			
			tweens = new NumTween(checkFlag); //создаем твин
			tweens.tween(yy, yy + 350, 0.4, Ease.expoOut); //который двигает меню с вверху вниз
			addTween(tweens);
		}
		
		public function tweenBack ():void { //эта функция убирает меню с экрана
			flagTweenUp = false;
			flagTweenBack = true;
			tweens = new NumTween(removeAll); //по окончании твина вызывается функции removeAll
			tweens.tween(y, y - 650, 0.9, Ease.expoOut);
			addTween(tweens, true);
		}
	
		private function checkFlag ():void { removeTween(tweens); flagTweenUp = true; }
		
		private function removeAll():void { //удаляем все объекты Entity из мира
			removeTween(tweens);
			FP.world.remove(this);
		  for (var i:int = 0; i < aEntity.length; i++) {
				FP.world.remove(aEntity[i]);
			 }	
		}
		
		public override function update ():void {
			y = tweens.value; //обновляем позицию меню в соответствии с текущим значением твина
		
				for (var i:int = 0; i < aEntity.length; i++) aEntity[i].y = tweens.value + offsetY; //также двигаем все объекты Entity из массива aEntity
		}
	}
}