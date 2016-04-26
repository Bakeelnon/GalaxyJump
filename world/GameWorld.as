package world {
	import entity.Brick;
	import entity.Ground;
	import entity.Hero;
	import entity.menu.Button;
	import entity.menu.Cursor;
	import entity.menu.GameMenu;
	import entity.Score;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.net.SharedObject;

	public class GameWorld extends World {
		private var hero:Hero;
		private var ground:Ground;
		private var score:Score;
		private var brick:Brick;
		private var wall:Entity;
		private var gameOver:GameMenu;
		private var gamePause:GameMenu;
		
		private var aBrick:Array = [GFX.BrickNormal, GFX.BrickBreak, GFX.BrickOpacity, GFX.BrickJump, GFX.BrickGorizont, GFX.BrickVertical];
		private var aMakeBrick:Array = [];
		
		private var yBrick:Number;
		private var aLevel:Array = [-800, -1800, -2600, -3400, -4800, - 6000];
		private var currentLevel:Number = 1;
		private var xyBrick:Point = new Point(Math.random() * 350, 400);
		
		private var maxY:int = 376;
		private var scores:int;
		private var noDefend:Boolean = true;
		private var preYCamera:Number;
		private var defeatOpen:Boolean = false;
		private var pauseOpen:Boolean = false;
		private var scoreCurrent:Number;
		
		private var buttonScores:Button;
		private var buttonRestart:Button;
		private var buttonMenu:Button;
		private var buttonSounds:Button;
		private var buttonSoundsText:String = " SOUNDS OFF\n PRESS '1'";

		public function GameWorld() {
			
			ground = new Ground();
			add(ground);
			
			hero = new Hero(250,ground);
			hero.layer = -1;
			add(hero);
			
			score = new Score();
			score.layer = -5;
			add(score);
			
			score.textBest.text = "BEST SCORES: " + SharedObject.getLocal("score").data.aScores[0];
			
			wall = new Entity(0, 0, new Backdrop(GFX.WallSprite, false, true));
			wall.layer = 3;
			add(wall);
			
			createBrick(currentLevel);
		}

		override public function update():void {
			if (hero.y < FP.height / 2 && noDefend) FP.camera.y = preYCamera = maxY - FP.height/2;
			if (hero.y < aLevel[currentLevel-1] && currentLevel!=aLevel.length) {currentLevel++;}
			if (hero.y < yBrick) createBrick(currentLevel);
			if (FP.camera.y < -ground.height+10) remove(ground);
			
			checkYBrick();
			checkScores();	
			if (noDefend) checkDefeat();
			if (defeatOpen && gameOver.flagTweenUp) checkPress("defeat");
			if (pauseOpen && gamePause.flagTweenUp)  checkPress("pause");
			if (!pauseOpen && !defeatOpen) checkPause();
			
			super.update();
		}

		private function createBrick(level:int):void {
			for (var i:int = 0; i < 10; i++) {
				
				var yB:Number = xyBrick.y -(Math.random() * 70 +30);
				xyBrick.y = yB;
				
				var rand:Number = Math.random() * 290 + 20;
				
				var randGfx:int = getRandomValue(level);
				
				switch (randGfx) {
					
						case 0:
						brick = new Brick(aBrick[0], rand, yB, "one", hero);
						aMakeBrick.push(brick);
						add(brick);
						break;
						
						case 1:
						brick = new Brick(aBrick[1], rand, yB,"two", hero,"break");
						aMakeBrick.push(brick);
						add(brick);
						break;
						
						case 2:
						brick = new Brick(aBrick[2], rand, yB,"three", hero);
						aMakeBrick.push(brick);
						add(brick);
						break;
						
						case 3:
						brick = new Brick(aBrick[3], rand, yB,"four", hero,"jump");
						aMakeBrick.push(brick);
						add(brick);
						break;
						
						case 4:
						rand = Math.random() * 200;
						var back:Entity = new Entity(rand, yB, new Stamp(aBrick[4]));
						brick = new Brick(aBrick[0], rand + 75, yB + 10, "five", hero);
						aMakeBrick.push(back);
						aMakeBrick.push(brick);
						add(back);
						add(brick);
						brick.flagFour = true;
						break;
						
						case 5:
						yB = xyBrick.y -(Math.random() *150 +10);
						
						xyBrick.y = yB;
						
						var backFive:Entity = new Entity(rand, yB, new Stamp(aBrick[5]));
						backFive.setHitbox(39, 195);
						
						brick = new Brick(aBrick[0], rand-5, yB + 90, "six", hero);
						aMakeBrick.push(backFive);
						aMakeBrick.push(brick);
						add(backFive);
						add(brick);
						brick.flagFive = true;
						break;
				}
	
				xyBrick.x = brick.x;
				if (i == 5) yBrick = brick.y;
			}
		}
		
		private function checkYBrick():void {
			for (var i:int = 0; i < aMakeBrick.length; i++) {
					if (aMakeBrick[i].y > FP.camera.y + FP.height) remove(aMakeBrick[i]);
			}
		}
		
		private function checkScores():void {
			
			if (hero.y > 0) {
				if(hero.y < maxY) maxY = hero.y;
				scores = 376 - maxY;
				scoreCurrent = scores * 2;
			} else {
				if (hero.y < maxY) maxY = hero.y;
				scoreCurrent = (scores + (maxY * -1)) * 2;
			}
			score.textScores.text = "SCORES:" + scoreCurrent;
		}
		
		private function checkPress(name:String):void {
			switch (name) {
				case "defeat":
					if (Input.check(Key.DIGIT_1)) FP.world = new ScoreList(true, scoreCurrent);
					if (Input.check(Key.DIGIT_2)) FP.world = new GameWorld;
					if (Input.check(Key.DIGIT_3)) FP.world = new Menu;
				break;
				
				case "pause":
					if (Input.pressed(Key.DIGIT_1)) { if (FP.volume == 1) {FP.volume = 0; buttonSounds.txt.text = buttonSoundsText = " SOUNDS ON\n PRESS '1'"} else {FP.volume = 1; buttonSounds.txt.text = buttonSoundsText = " SOUNDS OFF\n PRESS '1'"}};
					if (Input.check(Key.DIGIT_2)) { hero.flagPause = false; pauseOpen = false; gamePause.tweenBack()};
					if (Input.check(Key.DIGIT_3)) FP.world = new Menu;
				break;
			}
		}
		
		private function checkDefeat():void {
			if (hero.y > FP.camera.y + FP.screen.height) {
				noDefend = false;
				
				hero.alphaTween();
				
				FP.camera.y = preYCamera;
				
				var sprite:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonScores = new Button(" SCORES\n PRESS '1'", "gameOverScores", 50, 0, sprite, 0x000000,13);
				buttonScores.layer = -1;
				add(buttonScores);
				
				var sprite2:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonRestart = new Button(" RESTART\n PRESS '2'", "gameOverRestart", 152, 0, sprite2, 0x000000,13);
				buttonRestart.layer = -1;
				add(buttonRestart);
				
				var sprite3:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonMenu = new Button(" MENU\n PRESS '3'", "gameOverMenu", 255, 0, sprite3, 0x000000,13);
				buttonMenu.layer = -1;
				add(buttonMenu);
				
				gameOver = new GameMenu(GFX.MenuGameOver,FP.camera.y - 200, [buttonScores, buttonRestart, buttonMenu]);
				add(gameOver);
				
				defeatOpen = true;
			}	
		}
		
		private function checkPause():void {if (Input.check(Key.P)) pause();}
		
			private function pause():void {
				hero.flagPause = true;
				pauseOpen = true;
				
				var sprite:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonSounds = new Button(buttonSoundsText, "gameSounds", 50, 0, sprite, 0x000000,13);
				buttonSounds.layer = -3;
				add(buttonSounds);
				
				var sprite2:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonRestart = new Button(" RESUME\n PRESS '2'", "gameOverRestart", 152, 0, sprite2, 0x000000,13);
				buttonRestart.layer = -3;
				add(buttonRestart);
				
				var sprite3:Spritemap = new Spritemap(GFX.ButtonGameOver,95,28);
				buttonMenu = new Button(" MENU\n PRESS '3'", "gameOverMenu", 255, 0, sprite3, 0x000000,13);
				buttonMenu.layer = -3;
				add(buttonMenu);
				
				gamePause = new GameMenu(GFX.MenuGamePause,FP.camera.y - 200, [buttonSounds, buttonRestart, buttonMenu]);
				gamePause .layer = -2;
				add(gamePause );
			}	
		
		
			private function getRandomValue(level:int):int {
					var position:int = Math.random() * level;
					var current:int;
			
					for (var i:int = 0; i < position*4; i++) current = Math.random() * level;
					return current;
		}
	}
}