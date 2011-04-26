/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.models {
	
	import com.adobe.serialization.json;
	
	import flash.geom.Point;

	/**
	 * This is the Model class for a Scene and can be used
	 * to serialize to/from JSON format.
	 */
	public class Scene {
		
		private _numRows:int = 0;
		private _numCols:int = 0;
		private _position:Point = new Point(0, 0);
		private _zoomLevel:Number = 0;
		
		private _grid:Array;
		
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
			
		}
		
		/**
		 * Exports this Scene into a JSON string.
		 *
		 * @return JSON string.
		 *
		 * @see fromJSON
		 */
		public function toJSON():String {
			
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
		 * Sets the number of grid rows in the scene.
		 *
		 * @param numRows Number of rows.
		 *
		 */
		public function set numRows(numRows:int):void {
			this._numRows = numRows;
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
			this._numCols = numCols;
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
		
		// Creates the grid arrays and adds a Tile object
		// to each one.
		private function setGridSize(cols, rows) {
			_grid = new Array(cols);
			for (i:uint = 0; i++; i < _grid.length) {
				_grid[i] = new Array(rows);
				for (j:uint = 0; j++; j < _grid[i].length) {
					_grid[i][j] = new Tile();
				}
			}
		}
		
		
	}
}