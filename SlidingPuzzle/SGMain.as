package 
{
	/**
	 * @author Luiz de Mello
	 */
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	
	
	
	
	public class SGMain extends MovieClip
	{
		var field:SGGameField;
		var menu:SGMenu;
		var showingMenu:Boolean;
		
		public function SGMain()
		{
			field = new SGGameField(4, 4, 16, 3,3,125,125);
			field.x = 25;
			field.y = 24;
			addChild(field);
			
			field.TotalAnimationTimeInMillis = 200;
			
			showingMenu = false;			
			menu = new SGMenu();
			menu.x = 0;
			menu.y = -28;
			
			addChild(menu);
			
			
			menu.ingroup.solve.addEventListener(MouseEvent.CLICK, solveClick);
			menu.ingroup.mix.addEventListener(MouseEvent.CLICK, mixClick);
			menu.addEventListener(MouseEvent.ROLL_OUT, menuMouseRollOut);
			menu.ingroup.mouseEnabled = false;
			
			addEventListener(MouseEvent.MOUSE_MOVE, showMenu);
			
		}
		
		function showMenu(event:MouseEvent):void
		{			
			if (mouseY < 25 && !showingMenu)
			{	
				if (menu.currentFrame == 1 || menu.currentFrame == 20)
					menu.gotoAndPlay(2);
				else if (menu.currentFrame > 10)
					gotoAndPlay(20 - menu.currentFrame);
				else if (menu.currentFrame < 10)
					menu.gotoAndPlay(menu.currentFrame);
				
				
				
				showingMenu = true;
			}
		}
		
		function menuMouseRollOut(event:MouseEvent):void
		{
			if (menu.currentFrame >= 10)
					gotoAndPlay(10);
				else if (menu.currentFrame < 10)
					menu.gotoAndPlay(20 - menu.currentFrame);
					
			if (menu.currentFrame == 10)
			menu.gotoAndPlay(11);
					
			showingMenu = false;
		}
		
		function solveClick(event:MouseEvent):void
		{
			this.field.Reset();
		}
		
		function mixClick(event:MouseEvent):void
		{
			this.field.Randomize();
		}
		

	}
}