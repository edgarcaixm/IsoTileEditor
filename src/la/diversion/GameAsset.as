/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion {
	public class GameAsset {
		
		private var _id:String;
		private var _rows:int;
		private var _cols:int;
		private var _displayClass:Class;
		
		public function GameAsset(id:String, displayClass:Class, rows:int, cols:int){
			this._id = id;
			this._displayClass = displayClass;
			this._rows = rows;
			this._cols = cols;
		}

		public function get id():String{
			return _id;
		}

		public function set id(value:String):void{
			_id = value;
		}

		public function get displayClass():Class{
			return _displayClass;
		}

		public function set displayClass(value:Class):void{
			_displayClass = value;
		}

		public function get cols():int{
			return _cols;
		}

		public function set cols(value:int):void{
			_cols = value;
		}

		public function get rows():int{
			return _rows;
		}

		public function set rows(value:int):void{
			_rows = value;
		}
		
		public function clone():GameAsset{
			return new GameAsset(_id, _displayClass, _rows, _cols);
		}
	}
}