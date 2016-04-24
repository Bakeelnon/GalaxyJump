package entity.menu {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;

	public class Fon extends Entity {
		private var image:Image;
		private var imageMask:Stamp;
		private var txt:Text;
		private var angleX:Number = 0;
		private var angleY:Number = 4;

		public function Fon() {
			image = new Image(GFX.MenuFon); //создаем картинку, заметьте что в качестве класса с графикой мы указываем графику из класса GFX
			imageMask = new Stamp(GFX.MenuMask, 0, 0); //создаем маску
			
			txt = new Text("BRICK JUMP", 0,0,200,50); //черный текст "BRICK JUMP" на картинке 
			txt.color = 0x000000;
			txt.size = 32;
			txt.x = (image.width - txt.width) / 2;
			txt.y = 130;
			
			var content:Graphiclist = new Graphiclist(image, imageMask,txt);
			graphic = content;
		}
		
		override public function update():void {
			angleX += 0.01;
			angleY += 0.02;
			
			image.x = Math.cos(angleX) * 70; //двигаем картинку
			image.y = Math.cos(angleY) * 50;
		}
	}
}