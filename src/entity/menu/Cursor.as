package entity.menu {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;

	public class Cursor extends Entity {

		public function Cursor() {
			var image:Image = new Image(GFX.Arrow); //картинка курсора
			x = FP.stage.mouseX;
			y = FP.stage.mouseY;
			
			graphic = image;
			setHitbox(5, 5);
		}
		
		override public function update ():void {
				x = FP.stage.mouseX; //присваиваем координатам картинки курсора координаты мышки
				y = FP.stage.mouseY;
			}
	}
}