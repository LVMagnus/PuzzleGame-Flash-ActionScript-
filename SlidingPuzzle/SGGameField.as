package 
{
	

	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	 * A class defining the game field of an sliding puzzle.
	 * @author Luiz de Mello
	 */
	public class SGGameField extends Sprite
	{
		
		private var initialEmptyPieceX:uint;
		private var initialEmptyPieceY:uint;		
		
		private var emptyPieceX:uint;
		private var emptyPieceY:uint;
		private var emptyId:uint;
		private var fieldWidth:uint;
		private var fieldHeight:uint;
		private var pieceWidth:uint;
		private var pieceHeight:uint;
		
		private var field:Array;
		
		//Animation related
		private var animationPiece:SGPiece;
		
		private var locked:Boolean;
		
		
		private var animationDir:int = 0; //0 = stoped, 1 = go right, 2 = go left, 3 = go down, 4 = go up
		private var animationTargetPos:int = 0; //x or y pos, depending on the Dir
		private var animationStartPos:int = 0;
		private var AnimTMillis:int = 0;
		private var lastTimer:int = 0;
		/**
		 * The full time that the sliding animations should take.
		 */
		public var TotalAnimationTimeInMillis:int = 500;
		
		
		//Getters and setters
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
		 * The number of pieces per row in the field.
		 */
		public function get FieldWidth():uint
		{
			return fieldWidth;			
		}
		
		/**
		 * The number of pieces per column in the field.
		 */
		public function get FieldHeight():uint
		{
			return fieldHeight;
		}
		
		/**
		 * Gets the current X position of the empty piece.
		 */
		public function get EmptyPieceX():uint
		{ return emptyPieceX; }
		
		/**
		 * Gets the current Y position of the empty piece.
		 */
		public function get EmptyPieceY():uint
		{ return emptyPieceY; }
		
		/**
		 * Gets the Id of the empty piece.
		 */
		public function get EmptyId():uint
		{ return emptyId; }

		
		//end
		
		
		
		
		/**
		 * Instantiates a new SGGameField.
		 * @param	_FieldWidth		The number of pieces per row in the field.
		 * @param	_FieldHeight	The number of pieces per column in the field.
		 * @param	_EmptyId		The Id of the piece. Must follow the rule 0 < Id <= FieldWidth*FieldHeight.
		 * @param	_EmptyPieceX    The initial X position for the empty piece (i.e. the one when the puzzle is solved).
		 * @param	_EmptyPieceY	The initial Y position for the empty piece (i.e. the one when the puzzle is solved).
		 * @param	_PieceWidth		The Width of the each piece in pixels.
		 * @param	_PieceHeight	The Height of the each piece in pixels.		 
		 */
		public function SGGameField(_FieldWidth:uint, _FieldHeight:uint, _EmptyId:uint, _EmptyPieceX:uint, _EmptyPieceY:uint, _PieceWidth:uint, _PieceHeight:uint)
		{	
			
			if (_FieldWidth-1 < _EmptyPieceX || _FieldHeight-1 < _EmptyPieceY)
				throw new Error("Both EmptyPieceX and Y must be smaller than the FieldWidth and FieldHeight, respectively");
			else if ( _EmptyId == 0 || _EmptyId > _FieldHeight * _FieldWidth)
				throw new Error("_EmptyId must be greater than 0 and smaller or equal to the total number of pieces on the field (_GameField.FieldWidth * _GameField.FieldHeight. ID value: " + _EmptyId.toString());
			
			
			locked = false;
			
			fieldWidth = _FieldWidth;
			fieldHeight = _FieldHeight;
			pieceHeight = _PieceHeight;
			pieceWidth = _PieceWidth;			
			emptyPieceX = _EmptyPieceX;
			emptyPieceY = _EmptyPieceY;
			emptyId = _EmptyId;
			
			//Do not change after this point.
			initialEmptyPieceX = emptyPieceX;
			initialEmptyPieceY = emptyPieceY;
			
			
			
			field = new Array(fieldWidth);			
			for (var i:uint; i < fieldWidth; i++)
			{
				field[i] = new Array(fieldHeight);
			}
			
			
			InitializeField();
			addEventListener(Event.ENTER_FRAME, updateAnimation);
		}//Close constructor		
		
		/**
		 * Shuffles the pieces so to provide an automatic disorder. It does the process
		 * exactly like a human would do (i.e. following the same rules).
		 */
		public function Randomize():void
		{
			if (!locked)
			{
				Reset();
				
				var neighbors:uint;
				var chosen:uint;
				var cantGoToDir:uint = 0;//0 = no restraint//start, 1 = Right, 2 = Left, 3 = Down, 4 = Up
				var tempX:uint;
				var tempY:uint;
				
				var moveOptions:Array = new Array(4);
				
				for (var TotalMoves:uint = Random.NewNumber(101, 20); TotalMoves > 0; TotalMoves--)
				{								
					neighbors = 0;
					
					if (cantGoToDir != 1 && emptyPieceX < fieldWidth - 1)
					{
						moveOptions[neighbors] = "R";
						neighbors++;
					}
					
					if (cantGoToDir != 2 && emptyPieceX > 0)
					{
						moveOptions[neighbors] = "L";
						neighbors++;
					}
					
					if (cantGoToDir != 3 && emptyPieceY < fieldHeight - 1)
					{
						moveOptions[neighbors] = "D";
						neighbors++;
					}
					
					if (cantGoToDir != 4 && emptyPieceY > 0)
					{
						moveOptions[neighbors] = "U";
						neighbors++;
					}
					
					
					
					
					tempX = emptyPieceX;
					tempY = emptyPieceY;
					
					chosen = Random.NewNumber(neighbors);
					
					switch(moveOptions[chosen])
					{
						case "R":
							tempX++;
							cantGoToDir = 2
						break;
						case "L":
							cantGoToDir = 1;
							tempX--;
						break;
						case "D":
							tempY++;
							cantGoToDir = 4;
						break;
						case "U":
							tempY--;
							cantGoToDir = 3;
						break;
						default:
							trace("Something is quite wrong on the SGGameField.Randomize().");
					}
					
					
					
					
					
					
					
					MoveMe(field[tempX][tempY], false);
					
					
				}
			}
		}
		
		/**
		 * Move the give SGPiece to the empty space if it neighbors the empty piece and there
		 * is no animation running.
		 * @param	_Piece		The piece to be moved.
		 * @param	_Animate	Indicates if this movement should trigger an animation or not (intantaneous).
		 * @return Returns if it actually moved the piece or not.
		 */
		public function MoveMe(_Piece:SGPiece, _Animate:Boolean=false):Boolean
		{
			var r:Boolean = true;
			
			
			if (!locked)
			{
				if (_Piece.FieldX + 1 == emptyPieceX && _Piece.FieldY == emptyPieceY)
				{
					
					animationDir = 1;
					
					if (_Animate)
					{
						animationStartPos = _Piece.x;
						animationTargetPos = field[emptyPieceX][emptyPieceY].x;// animationStartPos + pieceWidth;
					}
				
				}
				else if (_Piece.FieldX - 1 == emptyPieceX && _Piece.FieldY == emptyPieceY)
				{
					animationDir = 2;
					
					if (_Animate)
					{
						animationStartPos = _Piece.x;
						animationTargetPos = field[emptyPieceX][emptyPieceY].x;
					}
					
				}
				else if (_Piece.FieldX == emptyPieceX && _Piece.FieldY + 1 == emptyPieceY)
				{
					animationDir = 3;
					
					if (_Animate)
					{
						animationStartPos = _Piece.y;
						animationTargetPos = field[emptyPieceX][emptyPieceY].y;
					}
				}
				else if (_Piece.FieldX == emptyPieceX && _Piece.FieldY - 1 == emptyPieceY)
				{
					animationDir = 4;
					
					if (_Animate)
					{
						animationStartPos = _Piece.y;
						animationTargetPos = field[emptyPieceX][emptyPieceY].y;
					}
					
				}
				else
				{
					r = false;
				}//ends if - else-if ...else sequence
				
				if (r)
				{					
					if (_Animate)
					{
						animationPiece.x = _Piece.x;
						animationPiece.y = _Piece.y;
						animationPiece.Id = _Piece.Id;
						animationPiece.FieldX = emptyPieceX;
						animationPiece.FieldY = emptyPieceY;
						animationPiece.Id = _Piece.Id;
						
						locked = true;
						lastTimer = getTimer();
					}
					else
					{
						animationDir = 0;
						field[emptyPieceX][emptyPieceY].Id = _Piece.Id;						
					}
					
					
					emptyPieceX = _Piece.FieldX;
					emptyPieceY = _Piece.FieldY;
					_Piece.Id = emptyId;
					
					
				}
				
			}//close if(!locked)
			
			
			
			return r;
		}
		
		
		
		/**
		 * Resets, or solves, the puzzle.
		 */
		public function Reset():void
		{
			if (!locked)
			{
				//Certifying that all references and childs are removed			
				for (var i:uint = 0; i < fieldWidth; i++)
				{
					for (var j:uint=0; j < fieldHeight; j++)
					{
						removeChild(field[i][j]);
						field[i][j] = null;
						
					}
				}
				InitializeField();	
			}
		}
		
		
		private function InitializeField():void
		{
			
			//Initial Position (X,Y) of each piece	
			for (var i:uint=0; i < fieldWidth; i++)
				for (var j:uint=0; j < fieldHeight; j++)
				{				
					field[i][j] = new SGPiece((i * fieldHeight) + j + 1, i , j , pieceWidth, pieceHeight, this);
					addChild(field[i][j]);
					
				}//Close For (i) for (j)
				
			animationPiece = null;
			animationPiece = new SGPiece(emptyId, emptyPieceX, emptyPieceY, pieceWidth, pieceHeight, this);
			addChild(animationPiece);
			emptyPieceX = initialEmptyPieceX;
			emptyPieceY = initialEmptyPieceY;
			
			
			
		}//Close function InitializeField()
		
		
		//Event methods
		function updateAnimation(event:Event):void
		{			
			var cTimer:int = getTimer();
			if (locked)
			{
				if (animationPiece.y == field[animationPiece.FieldX][animationPiece.FieldY].y && animationPiece.x == field[animationPiece.FieldX][animationPiece.FieldY].x)
				{
					locked = false;
					field[animationPiece.FieldX][animationPiece.FieldY].Id = animationPiece.Id;
					animationPiece.Id = emptyId;					
				}
				else
				{
					var tDif:int = cTimer - lastTimer;
					
					
					
					if (animationDir == 1)
					{
						
						animationPiece.x += (animationTargetPos - animationStartPos) * (tDif / TotalAnimationTimeInMillis);
						animationPiece.x = Math.min(animationPiece.x, animationTargetPos);
					}
					else if (animationDir == 2)
					{
						animationPiece.x += (animationTargetPos - animationStartPos) * (tDif / TotalAnimationTimeInMillis);
						animationPiece.x = Math.max(animationPiece.x, animationTargetPos);
					}
					else if (animationDir == 3)
					{
						animationPiece.y += (animationTargetPos - animationStartPos) * (tDif / TotalAnimationTimeInMillis);
						animationPiece.y = Math.min(animationPiece.y, animationTargetPos);
					}
					else
					{
						animationPiece.y += (animationTargetPos - animationStartPos) * (tDif / TotalAnimationTimeInMillis);
						animationPiece.y = Math.max(animationPiece.y, animationTargetPos);
					}
					animationPiece.x = Math.floor(animationPiece.x);
					animationPiece.y = Math.floor(animationPiece.y);
					
					
				}
				
				
			}
			lastTimer = cTimer;
		}
		
	}//Close class definition
	
}