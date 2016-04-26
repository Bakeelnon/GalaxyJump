package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getDefinitionByName;

	[SWF(width="400",height="480",frameRate="60")]

	public class Preloader extends MovieClip {
		private var loader:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var text:TextField = new TextField();

		private const loaderWidth:int = 320;
		private const loaderHeight:int = 32;

		private const loaderColor:uint = 0xffffff;
		private const textColor:uint = 0xbbbbbb;
		private const backgroundColor:uint = 0x000000;

		private var loaded:Number = 0;

		public function Preloader(){
			stage.addEventListener(Event.ENTER_FRAME, progress);

			addChild(loader);
			loader.x = (stage.stageWidth / 2) - (loaderWidth / 2) + 4;
			loader.y = (stage.stageHeight / 2) - (loaderHeight / 2) + 4;

			addChild(border);
			border.x = (stage.stageWidth / 2) - (loaderWidth / 2);
			border.y = (stage.stageHeight / 2) - (loaderHeight / 2);

			addChild(text);
			text.x = (stage.stageWidth / 2) - (loaderWidth / 2);
			text.y = (stage.stageHeight / 2) - (loaderHeight / 2) - 30;
			text.textColor = textColor;

			graphics.beginFill(backgroundColor, 1);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();

			border.graphics.clear();
			border.graphics.lineStyle(2, loaderColor);
			border.graphics.drawRect(0, 0, loaderWidth, loaderHeight);
		}

		private function progress(e:Event):void {
			loaded = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;

			loader.graphics.clear();
			loader.graphics.beginFill(loaderColor);
			loader.graphics.drawRect(0, 0, loaded * (loaderWidth - 8), loaderHeight - 8);
			loader.graphics.endFill();

			text.text = "Loading: " + Math.ceil(loaded * 100) + "%";

			if (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal){
				startup();
			}
		}

		private function startup():void {
			stage.removeEventListener(Event.ENTER_FRAME, progress);
			stop();

			var i:int = numChildren;
			while (i--){removeChildAt(i)}

			var mainClass:Game = new Game();
			parent.addChild(mainClass);

			parent.removeChild(this)
		}
	}
}