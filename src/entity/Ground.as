package entity{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;


	public class Ground extends Entity {

		public function Ground() {
			var image:Image = new Image(GFX.GroundSprite); //спрайт земли 
			graphic = image;
			x = 0;
			y = FP.height-image.height;
			type = "ground";
			setHitbox(image.width, image.height);
		}
	}
}