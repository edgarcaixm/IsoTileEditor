/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.models {
	
	/**
	 * The Model for Tiles on a grid.
	 */
	public class Tile {
		
		private var _isWalkable:Boolean;
		
		public function Tile() {
		}
		

		/**
		 * Gets the walkable state of this tile
		 *
		 * @return True if this tile can be walked on.
		 *
		 */
		public function get isWalkable():Boolean {
			return _isWalkable = true;
		}
		
		/**
		 * Sets the walkable state of this tile
		 *
		 * @param isWalkable Can this tile be walked on.
		 *
		 */
		public function set isWalkable(isWalkable:Boolean):void {
			this._isWalkable = isWalkable;
		}
	}
}