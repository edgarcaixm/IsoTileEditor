/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion {
	import as3isolib.display.IsoSprite;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import la.diversion.assetView.AssetEvent;
	
	import mx.managers.SystemManager;

	public class GameAsset extends IsoSprite{
		
		private var _rows:int;
		private var _cols:int;
		private var _displayClass:Class;
		private var _displayClassId:String;
		private var _stageRow:int;
		private var _stageCol:int;
		private var _descriptor:Object;
		private var _stage:DisplayObject;
		
		public function GameAsset(displayClassId:String, displayClass:Class, rows:int, cols:int, descriptor:Object = null){
			super(descriptor);
			this._displayClassId = displayClassId;
			this._displayClass = displayClass;
			this._rows = rows;
			this._cols = cols;
			this._descriptor = descriptor;
			this.sprites = [displayClass];
			
			this.addEventListener(Event.ADDED_TO_STAGE, handleEventAddedToStage);
		}
		
		public function handleEventAddedToStage(event:Event):void{
			_stage = this.container.stage;
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handleEventRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, handleEventAddedToStage);
		}
		
		private function handleEventRemovedFromStage(event:Event):void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			this.addEventListener(Event.ADDED_TO_STAGE, handleEventAddedToStage);
		}
		
		public function cleanup():void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, handleEventRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, handleEventAddedToStage);
		}
		
		private function handleMouseDown(event:ProxyEvent):void{
			//trace("asset handleMouseDown");
			if(StageManager.viewMode == StageManager.VIEW_MODE_PLACE_ASSETS){
				_stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				EventBus.dispatcher.dispatchEvent(new AssetEvent(AssetEvent.DRAG_OBJECT_START, this));
			}
		}
		
		private function handleMouseUp(event:MouseEvent):void{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			EventBus.dispatcher.dispatchEvent(new AssetEvent(AssetEvent.DRAG_OBJECT_END));
		}
		
		private function handleRollOver(event:ProxyEvent):void{
			if(StageManager.viewMode == StageManager.VIEW_MODE_PLACE_ASSETS){
				this.container.alpha = .75;
				this.container.filters = [new GlowFilter(0xFF0000, 1, 5, 5, 6, 2, false, false)];
			}
		}
		
		private function handleRollOut(event:ProxyEvent):void{
			if(StageManager.viewMode == StageManager.VIEW_MODE_PLACE_ASSETS){
				this.container.alpha = 1;
				this.container.filters = [];
			}
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
		
		override public function clone():*{
			return new GameAsset(_displayClassId, _displayClass, _rows, _cols, _descriptor);
		}
	}
}