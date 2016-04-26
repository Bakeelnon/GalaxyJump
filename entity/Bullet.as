package entity {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;

	public class Bullet extends Entity {
		private var image:Image;
		private var ySpeed:Number = 5;

		public function Bullet(xx:Number, yy:Number) {
			image = new Image(GFX.Bullet);
			graphic = image;

			x = xx;
			y = yy;
		}
		
		override public function update():void {
			y -= ySpeed;
			
			if (y < FP.camera.y - 50) FP.world.remove(this);
			ySpeed += 0.2;
		}
	}
}