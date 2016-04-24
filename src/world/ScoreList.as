package world {
	import entity.menu.Button;
	import entity.menu.Cursor;
	import entity.menu.GameMenu;
	import flash.display.DisplayObject;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class ScoreList extends World {
		public var shared:SharedObject;
		private var aTextName:Array = [];
		private var aTextScore:Array = [];

		private var arrow:Cursor;
		private var titleName:Entity;
		private var titleScores:Entity;

		private var button:Button;
		private var sound:Sfx;
		private var flag:Boolean;

		private var nameTxt:TextField;
		private var gameScore:GameMenu;
		private var buttonSubmit:Button;
		private var txtInput:TextField;
		private var scoreNum:Number;

		public function ScoreList(flag:Boolean = false, scoreNum:int = 0) {
			//Конструктор получает очки игрока и флаг записывать очки или просто показать таблицу очков
			shared = SharedObject.getLocal("score"); //получаем ссылку на SharedObject

			this.flag = flag;
			this.scoreNum = scoreNum;
			
			if (!flag) createCursor(); //если не надо записывать очки то сразу создаем курсор
			
			var i:int;
			sound = new Sfx(GFX.MenuClick);
			
			add(createTextStatic("BEST SCORE", (FP.width - 139) / 2, 50, 400, 50, 0x245376)); //с помощью функции createTextStatic создаем нужные тексты для таблицы
			add(createTextStatic("#", 50, 100));
			add(titleName = createTextStatic("NAME", (FP.width - 64) / 2 - 50, 100));
			add(titleScores = createTextStatic("SCORES", FP.width - 88 - 50, 100));

			for (i = 1; i <= 5; i++) {
				add(createTextStatic(String(i), 52, i * 40 + 120));
			}

			for (i = 0; i < shared.data.aName.length; i++){//текущие значения имен игроков и их очков берем из SharedObject 
				var nameText:Entity = createTextStatic(shared.data.aName[i], titleName.x, i * 40 + 160);
				add(nameText);
				aTextName.push(nameText);
			}

			for (i = 0; i < shared.data.aScores.length; i++){
				var scoreText:Entity = createTextStatic(shared.data.aScores[i], titleScores.x, i * 40 + 160);
				add(scoreText);
				aTextScore.push(scoreText);
			}

			button = new Button("MENU", "scoreBack", 0, 0); //кнопка возврата в основное меню
			button.x = (FP.width - button.width) / 2;
			button.y = FP.height - 100;
			add(button);
			
			if (flag) openNameInput(); //если флаг == true открываем меню ввода имени игрока
		}

		private function openNameInput():void {
			txtInput = createTxt(); //создаем текстовое поля для ввода  имени игрока
			buttonSubmit = new Button("    SAVE \n press ENTER", "saveScore", 152, 0, new Spritemap(GFX.ButtonGameOver, 95, 28), 0x000000, 12); //создаем кнопку

			gameScore = new GameMenu(GFX.MenuGameScore, -200, [buttonSubmit], 90); //создаем меню для ввода игрока
			add(gameScore);
			add(buttonSubmit);
		}
		
		private function createCursor():void { //функция создающая курсор
			arrow = new Cursor();
			arrow.layer = -1;
			add(arrow);
		}

		private function createTxt():TextField { //функция создающая текстовое поле
			nameTxt = new TextField();
			nameTxt.type = TextFieldType.INPUT;
			nameTxt.x = 150;
			nameTxt.width = 100;
			nameTxt.height = 20;
			nameTxt.selectable = true;
			nameTxt.tabEnabled = true;
			nameTxt.maxChars = 7;
			nameTxt.restrict = "A-Z 0-9 a-z";
			nameTxt.tabIndex = 0;
			nameTxt.border = true;
			nameTxt.borderColor = 0xFFFFFF;
			nameTxt.background = true;
			nameTxt.backgroundColor = 0x1B1B1B;
			nameTxt.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, false, true, null, null, null, "center");
			nameTxt.text = "redefy"
			FP.stage.addChild(nameTxt);
			FP.stage.focus = nameTxt;

			return nameTxt;
		}

		private function arraySort(num:Number, name:String):void { //функция сортирующая массивы SharedObject
			var index:int = -1;
			var lengthArray:int = shared.data.aScores.length;

			for (var i:int = 0; i < lengthArray; i++){
				if (shared.data.aScores[i] < num){
					index = i;
					break;
				}
			}

			if (index != -1){
				lengthArray -= 2;
				while (lengthArray >= index){
					shared.data.aScores[lengthArray + 1] = shared.data.aScores[lengthArray];
					shared.data.aName[lengthArray + 1] = shared.data.aName[lengthArray];
					lengthArray--;
				}
				shared.data.aScores[index] = num;
				shared.data.aName[index] = name;

				shared.flush();
				updateText();
			}
		}

		private function updateText():void { //если массивы SharedObject были изменены обновляем текстовые поля с именами игроков и их счетом
			var i:int;
			for (i = 0; i < shared.data.aName.length; i++){
				FP.world.remove(aTextName[i]);
				FP.world.remove(aTextScore[i]);
			}

			for (i = 0; i < shared.data.aName.length; i++){
				var nameText:Entity = createTextStatic(shared.data.aName[i], titleName.x, i * 40 + 160);
				add(nameText);
				aTextName.push(nameText);

				var scoreText:Entity = createTextStatic(shared.data.aScores[i], titleScores.x, i * 40 + 160);
				add(scoreText);
				aTextScore.push(scoreText);
			}
		}
		
		private function createTextStatic(text:String, xx:Number, yy:Number, width:Number=100, height:Number=50, color:Number = 0xFFFFFF):Entity {//функция создает текст, и возвращает объект Entity с этим текстом 
			var txt:Text = new Text (text,0,0, width, height);
			txt.size = 24;
			txt.color = color;
			trace(txt.width);
			
			return new Entity(xx, yy, txt);
		}

		override public function update():void {
			if (txtInput) txtInput.y = gameScore.y + 60;
			
			if (Input.check(Key.ENTER) && flag == true){ //если происходит нажатие клавиши ENTER когда открыто менб ввода игрока
				gameScore.tweenBack(); //убираем это меню
				arraySort(scoreNum, txtInput.text); //сортируем массивы
				flag = false; 

				arrow = new Cursor(); //создаем курсор
				arrow.layer = -1;
				add(arrow);
			}

			if (!flag){ //если меню закрыто проверяем курсор на столкновение с кнопкой возврата в меню
				var ent:Button = arrow.collide("button", arrow.x, arrow.y) as Button;

				if (ent){
					ent.sprite.play("mouseOver");
					ent.txt.color = 0x000000;

					if (Input.mousePressed){ //при нажатии переходим к основному меню
						switch (ent.name){
							case "scoreBack":
								if (txtInput)
									FP.stage.removeChild(txtInput);
								sound.play(2);
								FP.screen.color = 0x000000;
								FP.world = new Menu;
								break;
						}
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