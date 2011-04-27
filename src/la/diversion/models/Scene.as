/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.models {
	
	import com.adobe.serialization.json.JSON;
	
	import flash.geom.Point;

	/**
	 * This is the Model class for a Scene and can be used
	 * to serialize to/from JSON format.
	 */
	public class Scene {
		
		private var _cellSize:int = 64;
		private var _numRows:int = 0;
		private var _numCols:int = 0;
		private var _position:Point = new Point(0, 0);
		private var _zoomLevel:Number = 0;
		
		private var _grid:Array;
		
		public function Scene(json:String = null) {
			super();
			
			// Default Grid Size
			setGridSize(40, 40);
			
			if (json) {
				this.fromJSON(json);
			}
		}
		
		/**
		 * loads data from a JSON formated representation.
		 *
		 * @param1 json A JSON formated string.
		 *
		 * @see toJSON
		 */
		public function fromJSON(json:String):void {
			var obj:Object = JSON.decode(json);
			this._cellSize = obj.cellSize;
			this._numCols = obj.numCols;
			this._numRows = obj.numRows;
			this._zoomLevel = obj.zoomLevel;
			this.position = new Point(obj.position.x, obj.position.y);
			
			setGridSize(_numCols, _numRows);
			
			var jsonGrid:Array = obj.grid;
			
			var tile1:Tile;
			var tile2:Object;
			for (var i:int = 0; i < jsonGrid.length; i++) {
				for (var j:int = 0; j < jsonGrid[i].length; j++) {
					tile1 = _grid[i][j];
					tile2 = jsonGrid[i][j];
					_grid[i][j].isWalkable = jsonGrid[i][j].isWalkable;
				}
			}
		}
		
		/**
		 * Exports this Scene into a JSON string.
		 *
		 * @return JSON string.
		 *
		 * @see fromJSON
		 */
		public function toJSON():String {
			return JSON.encode(this);
		}
		
		/**
		 * Gets the number of grid rows in the scene.
		 *
		 * @return Number of rows.
		 *
		 */
		public function get numRows():int {
			return _numRows;
		}
		
		/**
		 * Sets the size of all the grid cells.
		 *
		 * @param size Size of cell in pixels.
		 *
		 */
		public function set cellSize(size:int):void {
			this._cellSize = size;
		}
		
		/**
		 * Gets the cell size in pixels.
		 *
		 * @return Size of grid cells.
		 *
		 */
		public function get cellSize():int {
			return _cellSize;
		}
		
		/**
		 * Sets the number of grid rows in the scene.
		 *
		 * @param numRows Number of rows.
		 *
		 */
		public function set numRows(numRows:int):void {
			setGridSize(_numCols, numRows);
		}
		
		/**
		 * Gets the number of grid columns in the scene.
		 *
		 * @return Number of columns.
		 *
		 */
		public function get numCols():int {
			return _numCols;
		}
		
		/**
		 * Sets the number of grid columns in the scene.
		 *
		 * @param numCols Number of columns.
		 *
		 */
		public function set numCols(numCols:int):void {
			setGridSize(numCols, _numRows);
		}
		
		/**
		 * Gets the positon of the grid in the scene.
		 *
		 * @return Grid position.
		 *
		 */
		public function get position():Point {
			return _position;
		}
		
		/**
		 * Sets the position of the grid in the scene.
		 *
		 * @param position The position of the grid.
		 *
		 */
		public function set position(position:Point):void {
			this._position = position;
		}
		
		/**
		 * Gets the zoom level of the grid.
		 *
		 * @return Zoom level.
		 *
		 */
		public function get zoomLevel():Number {
			return _zoomLevel;
		}
		
		/**
		 * Sets the zoom level of the grid.
		 *
		 * @param zoomLevel The zoom level of the grid.
		 *
		 */
		public function set zoomLevel(zoomLevel:Number):void {
			this._zoomLevel = zoomLevel;
		}
		
		/**
		 * Gets the current grid array.
		 *
		 * @return Grid Array.
		 *
		 */
		public function get grid():Array {
			return _grid;
		}
		
		// Creates the grid arrays and adds a Tile object
		// to each one.
		public function setGridSize(cols:int, rows:int):void {
			_numCols = cols;
			_numRows = rows;
			_grid = new Array(cols);
			for (var i:int = 0; i < cols; i++) {
				_grid[i] = new Array(rows);
				for (var j:int = 0; j < rows;  j++) {
					_grid[i][j] = new Tile();
				}
			}
		}
		
		
	}
}