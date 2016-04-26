package entity {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	public class Enemy extends Entity {
		private var image:Image;

		public function Enemy(xx:Number, yy:Number) {
			image = new Image(GFX.Enemy);
			graphic = image;
			
			x = xx;
			y = yy;
		}
	}
}