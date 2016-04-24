package entity{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.NumTween;

	public class Brick extends Entity {
		public var name:String;
		public var flagFour:Boolean = false;
		public var flagFive:Boolean = false;
		public var flag:Boolean = false;
		
		private var image:Image;
		private var hero:Hero;
		private var alphaTween:NumTween;
		private var yTween:NumTween;
		private var fooFour:Number = 0;
		private var fooFive:Number = 0;
		private var xEntity:Number;
		private var yEntity:Number;
		private var num:Number = Math.random() * 0.03 +0.02;
		
		public var sprite:Spritemap;
			
		public function Brick(source:*, xx:Number, yy:Number, name:String, hero:Hero, nameSprite:String = null) {
			this.name = name;
			this.hero = hero;
			 
			if (!nameSprite) { //если не указано имя спрайта создаем статичный кирпич
				image = new Image(source);
				graphic = image;
				setHitbox(image.width, 2);
			} else {  //иначе с анимацией
				switch (nameSprite) {
							case "break": 
							sprite = new Spritemap(source, 52, 37);
							break;
						
							case "jump": {
							sprite = new Spritemap(source, 52, 22);
							break;
						}
				}
				createAnimation();
				graphic = sprite; 
				setHitbox(sprite.width, 2);
			}
			xEntity = x = xx;
			yEntity = y = yy;
			type = "brick";
		}
		
		public function  tweenAlpha():void { //твин для исчезающего кирпича
			alphaTween = new NumTween(completeTween);
			alphaTween.tween(1, 0, 0.5);
			addTween(alphaTween,true);
		}
		
		public function  tweenyY():void { //твин для ломающегося кирпича
			yTween = new NumTween(completeTween);
			yTween.tween(y, y+300, 0.5);
			addTween(yTween,true);
		}
		
		override public function update ():void {
				if (image && alphaTween) image.alpha = alphaTween.value;
				if (yTween) y = yTween.value;
				if (flagFour) tweenFour();
				if (flagFive) tweenFive();
				
				if (hero.y+hero.height+10 < y) flag = true; //еслт игрок находится над кирпичом флаг = true
				else if (hero.y > y) flag = false; //иначе false
		}
		
		private function  completeTween():void {
			removeTween(alphaTween);
			FP.world.remove(this);
		}
		
		private function  tweenFour():void { //твин для горизонтально движущегося кирпича
			fooFour += num;
			x = Math.cos (fooFour) * 50 + xEntity;
		}
		
		private function  tweenFive():void { //твин для виртикально движущегося кирпича
			fooFive += num;
			y = Math.cos (fooFive) * 70 + yEntity;
		}
		
		private function createAnimation ():void {
			sprite.add("break", [0, 1, 2], 10,false);
		}
	}
}