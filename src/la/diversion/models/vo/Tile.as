/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.models.vo {
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.graphics.SolidColorFill;
	
	import la.diversion.signals.TileWalkableUpdatedSignal;
	
	import org.osflash.signals.Signal;
	
	/**
	 * The Model for Tiles on a grid.
	 */
	public class Tile {
		
		private var _col:int;
		private var _row:int;
		private var _isWalkable:Boolean = true;
		private var _cellSize:Number;
		private var _isoTile:IsoRectangle;
		private var _walkableUpdated:Signal;
		
		public function Tile(col:int, row:int, cellSize:Number) {
			this._col = col;
			this._row = row;
			this._cellSize = cellSize;
			//this.isoTile = new IsoRectangle();
			//this.isoTile.setSize(cellSize, cellSize, 0);
			//this.isoTile.moveTo(_col * cellSize, _row * cellSize, 0);
			//this.isoTile.fills = [ new SolidColorFill(0xFF0000,.75) ];
		}
		
		[Transient]
		public function get walkableUpdated():Signal{
			return _walkableUpdated ||= new Signal();
		}
		
		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			_row = value;
		}

		public function get col():int
		{
			return _col;
		}

		public function set col(value:int):void
		{
			_col = value;
		}

		/**
		 * Gets the isoTile for this Tile
		 * 
		 * @return 
		 * 
		 */
		[Transient]
		public function get isoTile():IsoRectangle {
			return _isoTile;
		}

		/**
		 * Set the isoTIle for this Tile
		 * 
		 * @param IsoRectangle
		 *
		 */
		public function set isoTile(value:IsoRectangle):void {
			_isoTile = value;
		}

		/**
		 * Gets the walkable state of this tile
		 *
		 * @return True if this tile can be walked on.
		 *
		 */
		public function get isWalkable():Boolean {
			return _isWalkable;
		}
		
		/**
		 * Sets the walkable state of this tile
		 *
		 * @param isWalkable Can this tile be walked on.
		 *
		 */
		public function set isWalkable(isWalkable:Boolean):void {
			if(!this.isoTile){
				this.isoTile = new IsoRectangle();
				this.isoTile.setSize(_cellSize, _cellSize, 0);
				this.isoTile.moveTo(_col * _cellSize, _row * _cellSize, 0);
				this.isoTile.fills = [ new SolidColorFill(0xFF0000,.75) ];
			}
			this._isWalkable = isWalkable;
			walkableUpdated.dispatch(this);
		}
	}
}