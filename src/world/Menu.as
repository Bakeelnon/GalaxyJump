package world {
	import entity.menu.Button;
	import entity.menu.Cursor;
	import entity.menu.Fon;
	import net.flashpunk.Sfx;
	import world.GameWorld;
	import flash.ui.Mouse;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;

	public class Menu extends World {
		private var buttonNewGame:Button;
		private var buttonScores:Button;
		private var buttonAbout:Button;
		private var arrow:Cursor;
		private var menuFon:Fon;
		private var sound:Sfx;
		
		private var xyButton:Number = (FP.width - 159) / 2; // координата x для кнопок

		public function Menu() {
			buttonNewGame = new Button("New Game", "newGame",xyButton, FP.height - 60 * 3 - 30); //создаем кнопки
			buttonScores = new Button("Scores", "scores",xyButton, FP.height - 60 * 2 - 30);
			buttonAbout = new Button("About", "about",xyButton, FP.height - 60 - 30);
			
			arrow = new Cursor(); //создаем курсор
			
			menuFon = new Fon(); //фон
			menuFon.layer = 3;
			
			addList (buttonNewGame, buttonScores, buttonAbout, arrow, menuFon); //добавляем в мир игры
			
			sound = new Sfx(GFX.MenuClick); //создаем звук
			Mouse.hide(); //прячем мышку
		}	
		
		override public function update():void {
			var ent:Button = arrow.collide("button", arrow.x, arrow.y) as Button; //проверяем курсор на столкновение с объектами типа Button
			
			if (ent) { //если столкновение произошло
				ent.sprite.play("mouseOver"); //у кнопки с которой произошло столкновении проигрываем анимацию "мышка на кнопке"
				ent.txt.color = 0x000000; //и меняем цвет текста на кнопке
				
				if (Input.mousePressed) { //если при этом происходит нажатие мышки
					switch (ent.name) { //получаем имя кнопки
						case "newGame": //если имя "newGame"
						sound.play(2);
						FP.screen.color = 0x161616;
						FP.world = new GameWorld; //запускаем игру
						break;
						
						case "scores": //если имя "scores"
						sound.play(2);
						FP.screen.color = 0x161616;
						FP.world = new ScoreList; //переходим к таблице с лучшими игроками
						break;
						
						case "about": //если имя "about"
						sound.play(2);
						FP.screen.color = 0x161616;
						FP.world = new About; //переходим к меню "об авторе"
						break;
					}
				}
			} else { 
				buttonNewGame.sprite.play("mouseOut"); //если столкновение не поисходит или оно прекратилось
				buttonScores.sprite.play("mouseOut");  //возвращаем кнопках начальное состояние
				buttonAbout.sprite.play("mouseOut"); 
				
				buttonNewGame.txt.color = 0xFFFFFF;
				buttonScores.txt.color = 0xFFFFFF;
				buttonAbout.txt.color = 0xFFFFFF;
			}	
			super.update();
		}
	}
}