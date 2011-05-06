/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion.models.components {
	import as3isolib.display.IsoSprite;
	
	import com.adobe.serialization.json.DiversionJSON;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import mx.managers.SystemManager;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class GameAsset extends IsoSprite{
		
		private var _rows:int;
		private var _cols:int;
		private var _displayClass:Class;
		private var _displayClassId:String;
		private var _stageRow:int;
		private var _stageCol:int;
		private var _descriptor:Object;
		private var _stage:DisplayObject;
		private var _fileUrl:String;
		
		private var _addedToStage:NativeSignal;
		public var mouseDown:NativeSignal;
		public var mouseUp:NativeSignal;
		public var rollOver:NativeSignal;
		public var rollOut:NativeSignal;
		
		public function GameAsset(displayClassId:String, displayClass:Class, rows:int, cols:int, height:Number, fileUrl:String = "", stageRow:int = -1, stageCol:int = -1, descriptor:Object = null){
			super(descriptor);
			this._displayClassId = displayClassId;
			this._displayClass = displayClass;
			this._rows = rows;
			this._cols = cols;
			this._stageCol = stageCol;
			this._stageRow = stageRow;
			this.height = height;
			this._descriptor = descriptor;
			this.sprites = [displayClass];
			this._fileUrl = fileUrl;
			
			_addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_addedToStage.add(handleAddedToStage);
			mouseDown = new NativeSignal(this, MouseEvent.MOUSE_DOWN, ProxyEvent);
			rollOver = new NativeSignal(this, MouseEvent.ROLL_OVER, ProxyEvent);
			rollOut = new NativeSignal(this, MouseEvent.ROLL_OUT, ProxyEvent);
		}
		
		private function handleAddedToStage(event:Event):void{
			mouseUp = new NativeSignal(this.container.stage,MouseEvent.MOUSE_UP, MouseEvent);
			_stage = this.container.stage;
		}
		
		
		public function cleanup():void{
			_addedToStage.removeAll();
			mouseDown.removeAll();
			if(mouseUp){
				mouseUp.removeAll();
			}
			rollOver.removeAll();
			rollOut.removeAll();
		}

		public function get stageCol():int{
			return _stageCol;
		}

		public function set stageCol(value:int):void{
			_stageCol = value;
		}

		public function get stageRow():int{
			return _stageRow;
		}

		public function set stageRow(value:int):void{
			_stageRow = value;
		}

		public function get displayClassId():String{
			return _displayClassId;
		}

		public function set displayClassId(value:String):void{
			_displayClassId = value;
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
		
		public function toJSON():String{
			var result:Object = new Object();
			
			result.rows = _rows;
			result.cols = _cols;
			result.height = height;
			result.displayClassId = _displayClassId;
			result.stageRow = _stageRow;
			result.stageCol = _stageCol;
			result.fileUrl = _fileUrl;
			result.id = this.id;
			return DiversionJSON.encode(result);
		}
		
		override public function clone():*{
			return new GameAsset(_displayClassId, _displayClass, _rows, _cols, height, _fileUrl, _stageRow, _stageCol, _descriptor);
		}
	}
}