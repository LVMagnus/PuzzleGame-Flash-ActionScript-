package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Luiz de Mello
	 */
	public class  ReuseMain extends MovieClip
	{
		var GameField:SGGameField;
		
		public function ReuseMain()
		{
			GameField = new SGGameField(5,4, 1, 0, 0, 112, 75);
			GameField.TotalAnimationTimeInMillis = 100;
			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboard);
			addChild(GameField);
			stage.focus = this;
			stage.frameRate = 24;
			
		}
		
		
		function handleKeyboard(event:KeyboardEvent)
		{
			if (event.keyCode == KeyCodes.S)
				GameField.Reset();
			else if (event.keyCode == KeyCodes.R)
				GameField.Randomize();
		}
	}
	
}