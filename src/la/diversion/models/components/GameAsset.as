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
	
	import mx.collections.ArrayCollection;
	import mx.managers.SystemManager;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class GameAsset extends IsoSprite implements IAsset{
		
		private var _rows:int;
		private var _cols:int;
		private var _displayClass:Class;
		private var _displayClassId:String;
		private var _displayClassType:String;
		private var _stageRow:int;
		private var _stageCol:int;
		private var _descriptor:Object;
		private var _stage:DisplayObject;
		private var _fileUrl:String;
		private var _isInteractive:int;
		private var _editProperitiesList:ArrayCollection;
		private var _actorId:String;
		private var _classRef:String;
		
		private var _addedToStage:NativeSignal;
		public var mouseDown:NativeSignal;
		public var mouseUp:NativeSignal;
		public var rollOver:NativeSignal;
		public var rollOut:NativeSignal;
		
		public function GameAsset(displayClassId:String, displayClass:Class, displayClassType:String, rows:int, cols:int, height:Number, fileUrl:String = "", stageRow:int = -1, stageCol:int = -1, isInteractive:int = 0, classRef:String = "", descriptor:Object = null){
			super(descriptor);
			this._displayClassId = displayClassId;
			this._actorId = id;
			this._displayClass = displayClass;
			this._displayClassType = displayClassType;
			this._rows = rows;
			this._cols = cols;
			this._stageCol = stageCol;
			this._stageRow = stageRow;
			this.height = height;
			this._descriptor = descriptor;
			this.sprites = [displayClass];
			this._fileUrl = fileUrl;
			this._isInteractive = isInteractive;
			this._classRef = classRef;
			
			_addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_addedToStage.add(handleAddedToStage);
			mouseDown = new NativeSignal(this, MouseEvent.MOUSE_DOWN, ProxyEvent);
			rollOver = new NativeSignal(this, MouseEvent.ROLL_OVER, ProxyEvent);
			rollOut = new NativeSignal(this, MouseEvent.ROLL_OUT, ProxyEvent);
		}
		
		public function get classRef():String {
			return _classRef;
		}

		public function set classRef(value:String):void {
			_classRef = value;
		}

		public function get actorId():String {
			return _actorId;
		}

		public function set actorId(value:String):void {
			_actorId = value;
		}

		public function get fileUrl():String {
			return _fileUrl;
		}

		public function set fileUrl(value:String):void {
			_fileUrl = value;
		}

		public function get isInteractive():int {
			return _isInteractive;
		}

		public function set isInteractive(value:int):void {
			_isInteractive = value;
		}

		public function get editProperitiesList():ArrayCollection {
			_editProperitiesList = new ArrayCollection([
				{property:"Id", value:this.id, canEdit:false, editProperty:""},
				{property:"Cols", value:this.cols, canEdit:true, editProperty:"cols"},
				{property:"Rows", value:this.rows, canEdit:true, editProperty:"rows"},
				{property:"Height", value:this.height, canEdit:true, editProperty:"height"},
				{property:"Stage Col", value:this.stageCol, canEdit:false, editProperty:"stageCol"},
				{property:"Stage Row", value:this.stageRow, canEdit:false, editProperty:"stageRow"},
				{property:"Is Interactive", value:this.isInteractive, canEdit:true, editProperty:"isInteractive"},			
				{property:"Actor Id", value:this.actorId, canEdit:true, editProperty:"actorId"}				
			]); 
			return _editProperitiesList;
		}

		public function get displayClassType():String {
			return _displayClassType;
		}

		public function set displayClassType(value:String):void {
			_displayClassType = value;
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
			result.isInteractive = _isInteractive;
			result.actorId = _actorId;
			result.classRef = _classRef;
			return DiversionJSON.encode(result);
		}
		
		override public function clone():*{
			return new GameAsset(_displayClassId, _displayClass, _displayClassType, _rows, _cols, height, _fileUrl, _stageRow, _stageCol, _isInteractive, _classRef, _descriptor);
		}
	}
}