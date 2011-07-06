/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion.models.vo {
	import as3isolib.display.IsoSprite;
	
	import com.adobe.serialization.json.DiversionJSON;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import la.diversion.enums.AssetTypes;
	
	import mx.collections.ArrayCollection;
	import mx.managers.SystemManager;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class MapAsset extends IsoSprite implements IAsset{
		
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
		private var _interactiveRow:int;
		private var _interactiveCol:int;
		private var _editProperitiesList:ArrayCollection;
		private var _actorId:String;
		private var _classRef:String;
		private var _frameWidth:Number;
		private var _frameHeight:Number;
		private var _spriteSheet:SpriteSheet;
		private var _spriteSheetOffset_x:Number
		private var _spriteSheetOffset_y:Number
		private var _moveSpeed:Number;
		private var _pathingPoints:Array;
		private var _pathingType:int;
		private var _pathingIdleChance:int;
		private var _pathingIdleTime:int;
		private var _walkType:int;
		
		private var _addedToStage:NativeSignal;
		public var mouseDown:NativeSignal;
		public var mouseUp:NativeSignal;
		public var mouseMove:NativeSignal;
		public var rollOver:NativeSignal;
		public var rollOut:NativeSignal;
		
		public function MapAsset(displayClassId:String = "", 
								  displayClass:Class = null, 
								  displayClassType:String = "", 
								  rows:int = 0, 
								  cols:int = 0, 
								  height:Number = 0, 
								  fileUrl:String = "", 
								  stageRow:int = -1, 
								  stageCol:int = -1, 
								  isInteractive:int = 0, 
								  interactiveCol:int = 0,
								  interactiveRow:int = 0,
								  classRef:String = "", 
								  descriptor:Object = null){
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
			if(displayClassType != AssetTypes.SPRITE_SHEET){
				this.sprites = [displayClass];
			}
			this._fileUrl = fileUrl;
			this._isInteractive = isInteractive;
			this._interactiveCol = interactiveCol;
			this._interactiveRow = interactiveRow;
			this._classRef = classRef;
			this._frameWidth = 78;
			this._frameHeight = 150;
			this._spriteSheetOffset_x = -39;
			this._spriteSheetOffset_y = -150;
			this._pathingPoints = [];
			this._pathingType = 0;
			this._moveSpeed = 0.3;
			this._pathingIdleChance = 10;
			this._pathingIdleTime = 10000;
			this._walkType = 0;
			
			_addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_addedToStage.add(handleAddedToStage);
			mouseDown = new NativeSignal(this, MouseEvent.MOUSE_DOWN, ProxyEvent);
			mouseMove = new NativeSignal(this, MouseEvent.MOUSE_MOVE, ProxyEvent);
			rollOver = new NativeSignal(this, MouseEvent.ROLL_OVER, ProxyEvent);
			rollOut = new NativeSignal(this, MouseEvent.ROLL_OUT, ProxyEvent);
		}
		
		public function get walkType():int {
			return _walkType;
		}

		public function set walkType(value:int):void {
			_walkType = value;
		}

		public function get pathingIdleTime():int {
			return _pathingIdleTime;
		}

		public function set pathingIdleTime(value:int):void {
			_pathingIdleTime = value;
		}

		public function get pathingIdleChance():int {
			return _pathingIdleChance;
		}

		public function set pathingIdleChance(value:int):void {
			_pathingIdleChance = value;
		}

		public function get pathingType():int {
			return _pathingType;
		}

		public function set pathingType(value:int):void {
			_pathingType = value;
		}

		public function removeNodeFromPathingPoints(node:Point):void{
			for (var i:int = 0; i < _pathingPoints.length; i++) {
				if(_pathingPoints[i].x == node.x && _pathingPoints[i].y == node.y){
					_pathingPoints.splice(i, 1);
					trace("MapAsset removeNodeFromPathingPoints");
					return;
				}
			}
		}
		
		public function addNodeToPathingPoints(node:Point):void{
			_pathingPoints.push(node);
			trace("MapAsset addNodeToPathingPoints");
		}
		
		public function get pathingPoints():Array {
			return _pathingPoints;
		}

		public function set pathingPoints(value:Array):void {
			_pathingPoints = value;
		}

		public function get spriteSheetOffset_y():Number {
			return _spriteSheetOffset_y;
		}

		public function set spriteSheetOffset_y(value:Number):void {
			_spriteSheetOffset_y = value;
		}

		public function get spriteSheetOffset_x():Number {
			return _spriteSheetOffset_x;
		}

		public function set spriteSheetOffset_x(value:Number):void {
			_spriteSheetOffset_x = value;
		}

		public function get moveSpeed():Number {
			return _moveSpeed;
		}

		public function set moveSpeed(value:Number):void {
			_moveSpeed = value;
		}

		public function get spriteSheet():SpriteSheet {
			return _spriteSheet;
		}

		public function set spriteSheet(value:SpriteSheet):void {
			_spriteSheet = value;
		}

		public function get frameHeight():Number {
			return _frameHeight;
		}

		public function set frameHeight(value:Number):void {
			_frameHeight = value;
		}

		public function get frameWidth():Number {
			return _frameWidth;
		}

		public function set frameWidth(value:Number):void {
			_frameWidth = value;
		}

		public function get interactiveCol():int {
			return _interactiveCol;
		}

		public function set interactiveCol(value:int):void {
			_interactiveCol = value;
		}

		public function get interactiveRow():int {
			return _interactiveRow;
		}

		public function set interactiveRow(value:int):void {
			_interactiveRow = value;
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
			switch(this.displayClassType) {
				case AssetTypes.SPRITE_SHEET:
					_editProperitiesList = new ArrayCollection([
						{property:"Id", value:this.id, canEdit:false, editProperty:""},
						{property:"DisplayClassId", value:this.displayClassId, canEdit:false, editProperty:""},
						{property:"DisplayClassType", value:this.displayClassType, canEdit:false, editProperty:""},
						{property:"Cols", value:this.cols, canEdit:true, editProperty:"cols"},
						{property:"Rows", value:this.rows, canEdit:true, editProperty:"rows"},
						{property:"Is Interactive", value:this.isInteractive, canEdit:true, editProperty:"isInteractive"},			
						{property:"Interactive Col", value:this.interactiveCol, canEdit:true, editProperty:"interactiveCol"},			
						{property:"Interactive Row", value:this.interactiveRow, canEdit:true, editProperty:"interactiveRow"},			
						{property:"Actor Id", value:this.actorId, canEdit:true, editProperty:"actorId"},		
						{property:"Frame Width", value:this.frameWidth, canEdit:true, editProperty:"frameWidth"},		
						{property:"Frame Height", value:this.frameHeight, canEdit:true, editProperty:"frameHeight"},
						{property:"Offset X", value:this.spriteSheetOffset_x, canEdit:true, editProperty:"spriteSheetOffset_x"},
						{property:"Offset Y", value:this.spriteSheetOffset_y, canEdit:true, editProperty:"spriteSheetOffset_y"},
						{property:"Pathing Type", value:this.pathingType, canEdit:true, editProperty:"pathingType"},
						{property:"Move Speed", value:this.moveSpeed, canEdit:true, editProperty:"moveSpeed"},
						{property:"Pathing Idle Chance", value:this.pathingIdleChance, canEdit:true, editProperty:"pathingIdleChance"},
						{property:"Pathing Idle Time", value:this.pathingIdleTime, canEdit:true, editProperty:"pathingIdleTime"},
						{property:"Walk Type", value:this.walkType, canEdit:true, editProperty:"walkType"}
					]); 
					break;
				
				default:
					_editProperitiesList = new ArrayCollection([
						{property:"Id", value:this.id, canEdit:false, editProperty:""},
						{property:"DisplayClassId", value:this.displayClassId, canEdit:false, editProperty:""},
						{property:"DisplayClassType", value:this.displayClassType, canEdit:false, editProperty:""},
						{property:"Cols", value:this.cols, canEdit:true, editProperty:"cols"},
						{property:"Rows", value:this.rows, canEdit:true, editProperty:"rows"},
						{property:"Height", value:this.height, canEdit:true, editProperty:"height"},
						{property:"Stage Col", value:this.stageCol, canEdit:false, editProperty:"stageCol"},
						{property:"Stage Row", value:this.stageRow, canEdit:false, editProperty:"stageRow"},
						{property:"Is Interactive", value:this.isInteractive, canEdit:true, editProperty:"isInteractive"},			
						{property:"Interactive Col", value:this.interactiveCol, canEdit:true, editProperty:"interactiveCol"},			
						{property:"Interactive Row", value:this.interactiveRow, canEdit:true, editProperty:"interactiveRow"},			
						{property:"Actor Id", value:this.actorId, canEdit:true, editProperty:"actorId"},
						{property:"Pathing Type", value:this.pathingType, canEdit:true, editProperty:"pathingType"},
						{property:"Move Speed", value:this.moveSpeed, canEdit:true, editProperty:"moveSpeed"},
						{property:"Pathing Idle Chance", value:this.pathingIdleChance, canEdit:true, editProperty:"pathingIdleChance"},
						{property:"Pathing Idle Time", value:this.pathingIdleTime, canEdit:true, editProperty:"pathingIdleTime"},
						{property:"Walk Type", value:this.walkType, canEdit:true, editProperty:"walkType"}
					]); 
					break;
			}
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
			this.sprites = [value];
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
			result.displayClassType = _displayClassType;
			result.stageRow = _stageRow;
			result.stageCol = _stageCol;
			result.fileUrl = _fileUrl;
			result.id = this.id;
			result.isInteractive = _isInteractive;
			result.interactiveCol = _interactiveCol;
			result.interactiveRow = _interactiveRow;
			result.actorId = _actorId;
			result.classRef = _classRef;
			result.pathingType = _pathingType;
			result.frameWidth = _frameWidth;
			result.frameHeight = _frameHeight;
			result.spriteSheetOffset_x = _spriteSheetOffset_x;
			result.spriteSheetOffset_y = _spriteSheetOffset_y;
			result.moveSpeed = _moveSpeed;
			result.pathingPoints = pathingPoints;
			result.pathingIdleChance = _pathingIdleChance;
			result.pathingIdleTime = _pathingIdleTime;
			result.walkType = _walkType;
			
			return DiversionJSON.encode(result);
		}
		
		override public function clone():*{
			var ass:MapAsset = new MapAsset(_displayClassId, _displayClass, _displayClassType, _rows, _cols, height, _fileUrl, _stageRow, _stageCol, _isInteractive, _interactiveCol, _interactiveRow, _classRef, _descriptor);
			ass.frameWidth = _frameWidth;
			ass.frameHeight = _frameHeight;
			ass.moveSpeed = _moveSpeed;
			ass.walkType = _walkType;
			if (this._pathingPoints.length > 0){
				var pp:Array = new Array();
				for (var i:int = 0; i < _pathingPoints.length; i++) {
					var newPoint:Point = new Point(_pathingPoints[i].x, _pathingPoints[i].y);
					pp[i] = newPoint;
				}
				ass._pathingPoints = pp;
			}
			if (_displayClassType == AssetTypes.SPRITE_SHEET){
				ass.spriteSheet = _spriteSheet.clone();
				ass.sprites = [ass.spriteSheet];
			}
			if(_displayClassType == AssetTypes.MOVIECLIP){
				//create a wrapper for the remotely loaded clip because adobe hates developers
				var wrapper:Sprite = new ass.displayClass as Sprite;
				wrapper.addChild(new ass.displayClass as MovieClip);
				wrapper.mouseChildren = false;
				ass.sprites = [wrapper];
			}
			return ass;
		}
	}
}