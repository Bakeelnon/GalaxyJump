package entity {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;

	public class Score extends Entity {
		public var textScores:Text;
		public var textBest:Text;
		private var image:Stamp;

		public function Score() {
			textScores = new Text("SCORES: 0", 0,0,200); //создаем два текста с текущим счетом игрока 
			textBest = new Text("BEST SCORES: 0", 0, 0, 200); //и с лучшим счетом
			
			textScores.color = textBest.color = 0x959595;
			textScores.size = textBest.size = 18;
			textBest.x = FP.width - textBest.width-50;
			
			image = new Stamp(GFX.ScoreFon, 0, 0); //создаем подложку для текста
			
			var content:Graphiclist = new Graphiclist(image,textBest, textScores);
			graphic = content;
		}
		
		override public function update():void {
			x = FP.camera.x; //двигаем все это вместе с камерой
			y = FP.camera.y;
		}
	}
}