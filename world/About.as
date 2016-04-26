package world {
	import entity.menu.Button;
	import entity.menu.Cursor;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;

	public class About extends World {
		private var button:Button;
		private var arrow:Cursor;
		private var sound:Sfx;

		public function About(){
			add(new Entity(0, 0, new Stamp(GFX.AboutFon, 7, 0))); //создаем картинку с информацией об игре

			button = new Button("MENU", "button", 0, 0); //кнопка для возврата в основное меню
			button.x = (FP.width - button.width) / 2;
			button.y = FP.height - 50;
			add(button);

			arrow = new Cursor();
			add(arrow);

			sound = new Sfx(GFX.MenuClick);
		}

		override public function update():void {
			var ent:Button = arrow.collide("button", arrow.x, arrow.y) as Button;

			if (ent){ //как и в классе ScoreList проверяем столкновение курсора с кнопкой
				ent.sprite.play("mouseOver");
				ent.txt.color = 0x000000;

				if (Input.mousePressed){
					switch (ent.name){
						case "button":
							sound.play(2);
							FP.screen.color = 0x000000;
							FP.world = new Menu;
							break;
					}
				}
			} else {
				button.sprite.play("mouseOut");
				button.txt.color = 0xFFFFFF;
			}
			super.update();
		}
	}
}