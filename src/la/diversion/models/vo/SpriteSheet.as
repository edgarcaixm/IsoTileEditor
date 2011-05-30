
package la.diversion.models.vo
{
	import de.polygonal.ds.Array2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class SpriteSheet extends Sprite
	{
		//rendering interval
		public static const RENDER_INTERVAL:Number = 64;
		
		//bitmap frames
		protected var _bitmapArray:Array2;
		//sheet source
		protected var _source:DisplayObject;
		//frame size
		protected var _frameWidth:Number;
		protected var _frameHeight:Number;
		//the rendered bitmap
		protected var _frameBitmap:Bitmap;
		protected var _frameRect:Rectangle;
		
		//current facing direction
		protected var _direction:String;
		//current frame row
		protected var _currentRow:Array;
		protected var _currentColNum:Number;
		//render timer
		protected var _oldTime:Number = 0;
		protected var _renderInterval:Number;
		
		//is the south-facing sequence on the first row (true) or not (false)?
		protected var _southFirst:Boolean;
		
		//the visual state 
		protected var _isIdle:Boolean;
		
		//if true, a new bitmap will be generated
		protected var _isDirty:Boolean;
		
		public function SpriteSheet()
		{
			super();
		}
		
		
		/**
		 * Build the sprite sheet. The source must contain 8 rows of animation frames arranged in clockwise order.
		 * The first row can be the south face or the south west. A tool like SpriteForge renders tilesheets 
		 * with the south-facing sequence on the first row. 
		 * 
		 * Acceptable row arrangements : S,SW,W,NW,N,NE,E,SE or SW,W,NW,N,NE,E,SE,S
		 * 
		 * @param	source			The source Display object. 
		 * @param	frameWidth		animation frame width
		 * @param	frameHeight		animation frame height
		 * @param	renderInterval	delay between renders. This defines the animation speed in milliseconds
		 * @param	southFirst		the south-facing sequence is on the first row (true) or the last (false). 
		 *                          
		 */
		public function build(source:DisplayObject, frameWidth:Number, frameHeight:Number, renderInterval:Number = SpriteSheet.RENDER_INTERVAL, southFirst:Boolean = true):void
		{
			
			_source = source;
			_frameWidth = frameWidth;
			_frameHeight = frameHeight;
			_renderInterval = renderInterval;
			_southFirst = southFirst;
			
			var sourceBd:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			sourceBd.draw(source, null, null, null, null, true);
			
			var numCols:Number = Math.floor(source.width / frameWidth);
			var numRows:Number = Math.floor(source.height / frameHeight);
			
			_frameRect = new Rectangle(0, 0, frameWidth, frameHeight);
			
			_bitmapArray = new Array2(numCols, numRows);
			
			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numCols; j++)
				{
					var bd:BitmapData = new BitmapData(frameWidth, frameHeight, true, 0x000000);
					_frameRect.x = j * frameWidth;
					_frameRect.y = i * frameHeight;
					
					bd.copyPixels(sourceBd, _frameRect, new Point(0, 0));
					
					_bitmapArray.set(j, i, bd);
					
				}
				
			}
			
			_frameRect.x = 0;
			_frameRect.y = 0;
			
			//if the south faces is on the last row, move it to the first
			if (!_southFirst)
			{
				_bitmapArray.shiftS();
			}
			
			setDirection(Directions.S);
			idle();
			
			_oldTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			render();
		}
		
		/**
		 * Set the state to idle
		 */
		public function idle():void
		{
			
			_isIdle = true;
			_isDirty = true;
		};
		
		/**
		 * Set the state to walk/animated
		 * 
		 */
		public function action():void
		{
			_isIdle = false;
			_isDirty = true;
		};
		
		protected function onEnterFrame(e:Event = null):void
		{
			
			var elapsed:Number = getTimer() - _oldTime;
			
			if (elapsed >= _renderInterval && _isDirty)
			{
				render();
				_oldTime = getTimer();
				//trace("--------------------------------------------------------------------------------------------->render:"+_currentColNum);
			}
			
		}
		
		protected function render():void
		{
			if (_frameBitmap == null)
			{
				_frameBitmap = new Bitmap(new BitmapData(_frameWidth, _frameHeight, true, 0x00000000));
				addChild(_frameBitmap);
			}
			
			_frameBitmap.bitmapData.lock();
			
			if (_isIdle)
			{
				_currentColNum = 0;
				_frameBitmap.bitmapData.copyPixels(_currentRow[_currentColNum], _frameRect, new Point(0, 0), null, null, false);
				//trace(this + "render idle");
				_isDirty = false;
			}
			else
			{
				
				if (_currentColNum < _currentRow.length-1)
				{
					try {
						_frameBitmap.bitmapData.copyPixels(_currentRow[_currentColNum], _frameRect, new Point(0, 0), null, null, false);
					}catch (error:Error) {
						//trace("ERROR RENDERING : " + _currentColNum);
						return;
					}
					_currentColNum++;
				}
				else
				{
					_currentColNum = 1;
				}
				
				_isDirty = true;
			}
			
			_frameBitmap.bitmapData.unlock();
		}
		
		/**
		 * Set the active direction and make _currentRow point to a specific row in _bitmapArray
		 * @param	direction
		 */
		public function setDirection(direction:String):void
		{
			//trace(this +"set direction : " +direction);
			_direction = direction;
			var rowNum:Number;
			switch (direction)
			{
				case Directions.S:
					rowNum = 0;
					break;
				case Directions.SW:
					rowNum = 1;
					break;
				case Directions.W:
					rowNum = 2;
					break;
				case Directions.NW:
					rowNum = 3;
					break;
				case Directions.N:
					rowNum = 4;
					break;
				case Directions.NE:
					rowNum = 5;
					break;
				case Directions.E:
					rowNum = 6;
					break;
				case Directions.SE:
					rowNum = 7;
					break;
				default:
					rowNum = 0;
			}
			//trace(this + "setDirection, row " + rowNum);
			
			//polygonal library change fix
			//_currentRow = _bitmapArray.getRow(rowNum);
			_currentRow = _bitmapArray.getRow(rowNum, new Array());
			
			_isDirty = true;
			render();
			
		}
		
		/**
		 * Get currently rendered frame
		 * 
		 * @return Bitmap
		 */
		public function getFrameBitmap():Bitmap
		{
			return _frameBitmap;
		}
		
		/**
		 * Get current direction
		 * @return
		 */
		public function getDirection():String
		{
			return _direction;
		}
		
		public function clone():*{
			var newSS:SpriteSheet = new SpriteSheet();
			if (_source){
				newSS.build(_source, _frameWidth, _frameHeight, _renderInterval, _southFirst);
			}
			newSS.x = this.x;
			newSS.y = this.y;
			return newSS;
		}
	}
}