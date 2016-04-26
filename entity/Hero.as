package entity {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Hero extends Entity {
		private var ground:Ground;
		private var image:Image;
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		private var tweenAlpha:NumTween;
		private var sfxJump:Sfx = new Sfx(GFX.Jump);
		private var flagTween:Boolean = false;
		public var flagPause:Boolean = false;

		public function Hero(xx:Number, ground:Ground){
			image = new Image(GFX.Hero);

			graphic = image;
			x = xx;
			y = ground.y - height - 10;
			trace(y);
			type = "hero";
			setHitbox(image.width, image.height);

			this.ground = ground;

			Input.define("leftDefine", Key.A, Key.LEFT);
			Input.define("rightDefine", Key.D, Key.RIGHT);
		}

		public function alphaTween():void {
			flagTween = true;
			tweenAlpha = new NumTween(removeHero);
			tweenAlpha.tween(1, 0, 0.4);
			addTween(tweenAlpha, true);
		}

		private function removeHero():void {
			removeTween(tweenAlpha);
			FP.world.remove(this);
		}

		override public function update():void {
			if (flagTween) image.alpha = tweenAlpha.value;

			if (!flagPause){
				if (Input.check("leftDefine")){if (xSpeed > -5) xSpeed -= 0.29;}
				if (Input.check("rightDefine")) { if (xSpeed < 5) xSpeed += 0.29; }

				if (collide("ground", x, y - 10)) ySpeed = 10;

				var brickEnt:Brick = collide("brick", x, y) as Brick;

				if (brickEnt && brickEnt.flag){
					ySpeed = 10;
					sfxJump.play();
					switch (brickEnt.name){
						case "one":
							break;

						case "two":
							brickEnt.sprite.play("break");
							brickEnt.tweenyY();
							break;

						case "three":
							brickEnt.name = "noCollide";
							brickEnt.tweenAlpha();
							break;

						case "four":
							brickEnt.sprite.play("break");
							ySpeed = 30;
							break;

						case "five":
							break;

						case "six":
							break;
					}
				}

				x += xSpeed;
				if (ySpeed < 1) y += 3.8; else y -= ySpeed;

				ySpeed *= 0.93;

				if (x + width < 0) x = FP.width; else if (x > FP.width) x = 0;
			}
		}
	}
}