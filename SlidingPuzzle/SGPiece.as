package 
{
	import flash.display.*;
	import flash.events.*;

	/**
	 * Describes a sliding piece withing a sliding game. Must be assosiated with an existing MovieClip.
	 * The MovieClip must contain the image of all pieces of the puzzle, each on a different keyframe
	 * and at the same relative position to the reference point of the MovieClip. Considering the order
	 * that pieces appear when the puzzle is solved, they should be ordered following the formula:
	 * Puzzle Height * X + Y (X,Y positions on the matrix, not on screen, starting at 0,0 at the leftmost-topmost
	 * piece). The empty space is also a piece and an empty keyframe should be inserted wherever it
	 * is, but no other empty keyframe or extra keyframe should be inserted.
	 * 
	 * It is not needed to be instantiated directly, the SGGameField takes care of it, just needs
	 * to be sure that it is assigned to that MovieClip.
	 * 
	 * @author Luiz de Mello
	 */	
	public class SGPiece extends MovieClip
	{						
		
		private var gameField:SGGameField;	
		
		private var type:uint;
		private var id:uint; 	
		private var fieldX:uint;
		private var fieldY:uint;
		private var pieceWidth:uint;
		private var pieceHeight:uint;		
		
		//Geters and setters
		/**
		 * The Width of the each piece in pixels.
		 */
		public function get PieceWidth():uint
		{
			return pieceWidth;
		}		
		/**
		 * The Height of the each piece in pixels.
		 */
		public function get PieceHeight():uint
		{
			return pieceHeight;
		}
		
		/**
		 * The X position of the piece within the playing field, rather than on screen.
		 */
		public function get FieldX():uint
		{
			return fieldX;
		}
		
		/**
		 * @see #get FieldX():uint
		 */
		public function set FieldX(value:uint):void
		{
			if (value < gameField.FieldWidth)
				fieldX = value;
			else
				throw new Error("FieldY: value must be smaller than gameField.FieldWidth.");
			
		}
		
		/**
		 * The Y position of the piece within the playing field, rather than on screen.
		 */
		public function get FieldY():uint
		{
			return fieldY;
		}
		
		/**
		 * @see #get FieldY():unit
		 */
		public function set FieldY(value:uint):void
		{
			
			if (value < gameField.FieldHeight)
				fieldY = value;
			else
				throw new Error("FieldY: value must be smaller than gameField.FieldHeight.");
		}
		
		/**
		 * Gets the name associated with the Type of this piece (either an Empty_Piece or a Filled_Piece).
		 */
		public function get TypeName():String
		{
			if (type == 1)
				return "Empty_Piece";
			else
				return "Filled_Piece";
		}
		
		/**
		 * A number that denotes what piece is this. Indirectly points what frame
		 * it represents within the MovieClip.
		 */
		public function get Id():uint
		{ return id; }
		
		/**
		 * @see #set Id(value:uint):void
		 */
		public function set Id(value:uint):void
		{
			if (value <=0 || value > gameField.FieldHeight * gameField.FieldWidth)
			{
				throw new Error("SGPiece.Id: attempt to set a value out of range. Must be greater than zero and smaller or equal to the total number of pieces on the field (_GameField.FieldWidth * _GameField.FieldHeight");
			}
			
			id = value;
			
			gotoAndStop(id);
			
			if (Id == gameField.EmptyId)
			{
				type = 1;
				mouseEnabled = false;
				buttonMode = false;
			}
			else
			{
				type = 0;
				buttonMode = true;
				mouseEnabled = true;
				this.addEventListener(MouseEvent.CLICK, clickMe);
			}
			
			
		}
	
		/**
		 * Returns the type of piece (Empty = 1, Filled = 0).
		 */
		public function get Type():int
		{ return type; }
		//end
		

		
		/**
		 * Returns a string containing information that describes the piece.
		 * @return The string.
		 */
		public override function toString():String
		{
			return new String("{ ID: " + id.toString() + ", Type: " + type.toString() + " (" + TypeName + 
				"), Field (X,Y): (" + fieldX.toString() +", " + fieldY.toString() +
				"), Piece (Width,Heigth): (" + pieceWidth.toString() + ", " +  pieceHeight.toString() +
				") }");
		}
		
		/**
		 * Set the piece as an empty piece.
		 */
		public function SetAsEmpty():void
		{
			Id = gameField.EmptyId;
		}				
		
		/**
		 * Creates a new instance of this class.
		 * @param	_Id				The initial Id of the piece. Must be greater than 0 and smaller or equal to _GameField.FieldWidth * _GameField.FieldHeight. See the class description for more info.
		 * @param	_FieldX			The X position of the piece within the playing field, rather than on screen.
		 * @param	_FieldY			The Y position of the piece within the playing field, rather than on screen.
		 * @param	_PieceWidth		The Width of the each piece in pixels.	
		 * @param	_PieceHeight	The Height of the each piece in pixels.
		 * @param	_GameField		The SGGameField in which this piece is inserted
		 */
		public function SGPiece(_Id:uint, _FieldX:int, _FieldY:int, _PieceWidth:uint, _PieceHeight:uint, _GameField:SGGameField)
		{	
			
			gameField = _GameField;			
			
			if ( !(_FieldX >= 0 && _FieldX < gameField.FieldWidth && _FieldY >= 0 && _FieldY < gameField.FieldHeight) )
			{
				throw new Error("SGPiece(): _FieldX and _FieldY must be smaller than _GameField.FieldWidth and FieldHeight respectively.");
			}
			else if ( _Id == 0 || _Id > gameField.FieldHeight * gameField.FieldWidth)
					throw new Error("_ID must be greater than 0 and smaller or equal to the total number of pieces on the field (_GameField.FieldWidth * _GameField.FieldHeight. ID value: " + _Id.toString());
			

			
			fieldX = _FieldX;
			fieldY = _FieldY;
			pieceWidth = _PieceWidth;
			pieceHeight = _PieceHeight;
			
			/*
			 * This is the only place where the onscreen position is set.
 			 * It is only a facilitator to position pieces on the place where it is
			 * more likely that they will be placed, but there is no problem manually
			 * changing this value after the creation.
			 */
			x = pieceWidth * fieldX;
			y = pieceHeight * fieldY;
			
			
			//Remember that the accessor performs other attributions too.
			Id = _Id;
			
			

			

			
		}//Close Constructor
		
		
		//Event functions
		private function clickMe(event:MouseEvent)
		{					
				gameField.MoveMe(this, true);
		}
		
		
		
		
	}
	
}
