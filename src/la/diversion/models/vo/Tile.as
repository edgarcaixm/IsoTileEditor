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
	
	import la.diversion.enums.TerrainTypes;
	import la.diversion.signals.TileWalkableUpdatedSignal;
	
	import org.osflash.signals.Signal;
	
	/**
	 * The Model for Tiles on a grid.
	 */
	public class Tile {
		
		public var col:int;
		public var row:int;
		
		private var _terrain_type:String = TerrainTypes.GROUND;
		private var _isWalkable:Boolean = true;
		private var _cellSize:Number;
		private var _isoTile:IsoRectangle;
		
		public function Tile(col:int, row:int, cellSize:Number) {
			this.col = col;
			this.row = row;
			this._cellSize = cellSize;
		}

		public function get terrain_type():String {
			return _terrain_type;
		}

		public function set terrain_type(value:String):void {
			if(!this.isoTile){
				this.isoTile = new IsoRectangle();
				this.isoTile.setSize(_cellSize, _cellSize, 0);
				this.isoTile.moveTo(col * _cellSize, row * _cellSize, 0);
				this.isoTile.fills = [ new SolidColorFill(0xFF0000,.75) ];
			}
			_terrain_type = value;
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
				this.isoTile.moveTo(col * _cellSize, row * _cellSize, 0);
				this.isoTile.fills = [ new SolidColorFill(0xFF0000,.75) ];
			}
			this._isWalkable = isWalkable;
		}
	}
}