package entity.menu {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;

	public class Button extends Entity {
		public var sprite:Spritemap = new Spritemap(GFX.Button, 159, 38);
		public var txt:Text;
		public var name:String;

		public function Button(text:String, name:String, xx:Number, yy:Number, spriteMap:Spritemap = null, color:Number = 0xFFFFFF, size:int = 18) {
			//в конструктор передается текст кнопки, ее имя, начальные координаты, спрайт кнопки, цвет текста и размер
			this.name = name;
			
			if (spriteMap) sprite = spriteMap;
			
			txt = new Text(text, 0,10,150);
			txt.color = color;
			txt.size = size;
			txt.x = (sprite.width - txt.width) / 2;
			txt.y = (sprite.height - txt.height) / 2;
			
			var content:Graphiclist = new Graphiclist(sprite, txt);
			graphic = content;
			
			x = xx;
			y = yy;
			
			type = "button";
			setHitbox(sprite.width, sprite.height);
			
			createAnimation();
		}
		
		private function createAnimation():void {
			sprite.add("mouseOver", [1], 5, false); //режем спрайт на два кадра
			sprite.add("mouseOut", [0], 5, false); //один показывается когда мышка находится над кнопкой, другой когда не находится
		}
	}
}