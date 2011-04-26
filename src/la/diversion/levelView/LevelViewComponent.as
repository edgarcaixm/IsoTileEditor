package la.diversion.levelView
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPrimitive;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import caurina.transitions.Tweener;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import la.diversion.EventBus;
	import la.diversion.GameAsset;
	import la.diversion.StageManager;
	import la.diversion.assetView.AssetEvent;
	
	public class LevelViewComponent extends Sprite {
		protected var cellSize:int = 64;
		protected var pathGrid:Grid;
		protected var path:Array;
		protected var isoSprite:IsoSprite;
		protected var isoView:IsoView;
		protected var isoScene:IsoScene;
		protected var isoGrid:IsoGrid;
		protected var highlight:IsoRectangle;
		protected var zoomFactor:Number = 1;
		
		private var _isPanning:Boolean = false;
		private var _panX:Number = 0;
		private var _panY:Number = 0;
		private var _panOriginX:Number = 0;
		private var _panOriginY:Number = 0;
		private var _objectBeingDragged:GameAsset;
		private var _isMouseOverGrid:Boolean = false;
		private var _mouseRow:Number;
		private var _mouseCol:Number;
		private var _bg:Sprite;
		private var _isDragging:Boolean;
		private var _dragThumb:Sprite;
		
		public var button1:SimpleButton;
		
		public function LevelViewComponent(){
			super();
			
			_bg = new Sprite();
			_bg.graphics.beginFill(0x00FFFF);
			_bg.graphics.drawRect(0,0,760,760);
			_bg.graphics.endFill();
			this.addChildAt(_bg,0);
			
			_bg.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseEventMouseWheel);
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEventMouseDown);
			_bg.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMove);

			EventBus.dispatcher.addEventListener(AssetEvent.DRAG_OBJECT_START, handleAssetEventDragObjectStart);

			makeGrid(40,40);
		}
		
		private function handleMouseEventMouseOut(event:MouseEvent):void{
			_isMouseOverGrid = false;
		}
		
		private function handleMouseEventMouseMove(event:MouseEvent):void{
			if (isoGrid){
				if(_isPanning){			
					isoView.panTo(_panOriginX - (event.stageX - _panX), _panOriginY - (event.stageY - _panY));
				}
				var isoPt:Pt = isoView.localToIso(new Pt(isoView.mouseX, isoView.mouseY));
				_mouseCol = Math.floor(isoPt.x / cellSize);
				if (_mouseCol < 0 || _mouseCol >= pathGrid.numCols)
				{
					_isMouseOverGrid = false;
					highlight.container.visible = false;
					return;
				}
				_mouseRow = Math.floor(isoPt.y / cellSize);
				if (_mouseRow < 0 || _mouseRow >= pathGrid.numRows)
				{
					_isMouseOverGrid = false;
					highlight.container.visible = false;
					return;
				}
				
				_isMouseOverGrid = true;
				highlight.container.visible = true;
				highlight.moveTo(_mouseCol * cellSize, _mouseRow * cellSize,0);
				isoScene.render();
			}
		}
		
		private function handleAssetEventDragObjectStart(event:AssetEvent):void{
			_isDragging = true;
			_objectBeingDragged = event.data as GameAsset;
			if(StageManager.getAsset(_objectBeingDragged.id)){
				isoScene.removeChild(_objectBeingDragged);
				StageManager.removeAsset(_objectBeingDragged.id);
			}
			highlight.setSize(_objectBeingDragged.cols * cellSize, _objectBeingDragged.rows * cellSize, 0);
			EventBus.dispatcher.addEventListener(AssetEvent.DRAG_OBJECT_END, handleAssetEventDragObjectEnd);
			
			_dragThumb = new _objectBeingDragged.displayClass as Sprite;
			_dragThumb.mouseEnabled = false;
			_dragThumb.alpha = .5;
			_dragThumb.scaleX = isoView.currentZoom;
			_dragThumb.scaleY = isoView.currentZoom;
			_dragThumb.x = stage.mouseX;
			_dragThumb.y = stage.mouseY;
			
			stage.addChild(_dragThumb);
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrameDrag);
		}
		
		private function handleAssetEventDragObjectEnd(event:AssetEvent):void{
			EventBus.dispatcher.removeEventListener(AssetEvent.DRAG_OBJECT_END, handleAssetEventDragObjectEnd);
			stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrameDrag);
			stage.removeChild(_dragThumb);
			_dragThumb = null;
			_isDragging = false;
			highlight.setSize(cellSize, cellSize, 0);
			
			if(_isMouseOverGrid){
				trace("GOGOGO");
				//if(!_objectBeingDragged.isoSprite){
				//	var newSprite:IsoSprite = new IsoSprite();
				//	_objectBeingDragged.isoSprite = newSprite;
				//	newSprite.sprites = [_objectBeingDragged.displayClass];
				//	newSprite.setSize(_objectBeingDragged.cols * cellSize, _objectBeingDragged.rows * cellSize, 0);
				//}
				//var newAsset:GameAsset = _objectBeingDragged.clone();
				//var newSprite:IsoSprite = new IsoSprite();
				//newAsset.isoSprite = newSprite;
				//newSprite.sprites = [_objectBeingDragged.displayClass];
				//newSprite.setSize(_objectBeingDragged.cols * cellSize, _objectBeingDragged.rows * cellSize, 0);
				_objectBeingDragged.setSize(_objectBeingDragged.cols * cellSize, _objectBeingDragged.rows * cellSize, 0);
				_objectBeingDragged.moveTo(_mouseCol * cellSize, _mouseRow * cellSize, 0);
				isoScene.addChild(_objectBeingDragged);
				StageManager.addAsset(_objectBeingDragged);
				isoScene.render();
			}else{
				//cleanup the asset, it has landed off the stage
				_objectBeingDragged.cleanup();
				_objectBeingDragged = null;
			}
		}
		
		private function handleEnterFrameDrag(e:Event):void{
			if(_isMouseOverGrid){
				var point:Point = isoView.isoToLocal(new Pt(_mouseCol * cellSize, _mouseRow * cellSize, 0));
				point = this.localToGlobal(point);
				_dragThumb.x = point.x;
				_dragThumb.y = point.y;
			}else{
				_dragThumb.x = stage.mouseX;
				_dragThumb.y = stage.mouseY;
			}
		}
		
		public function set rows(num:int):void {
			makeGrid(pathGrid.numCols, num)
		}
		
		public function set cols(num:int):void {
			makeGrid(num, pathGrid.numRows);
		}
		
		private function handleMouseEventMouseWheel(event:MouseEvent):void{
			zoomFactor = zoomFactor + (event.delta / 10);
			if (zoomFactor < 0.3){
				zoomFactor = 0.3;
			}else if(zoomFactor > 2){
				zoomFactor = 2;
			}
			isoView.zoom(zoomFactor);
		}
		
		private function handleMouseEventMouseDown(event:MouseEvent):void{
			_panX = event.stageX;
			_panY = event.stageY;
			_panOriginX = isoView.currentX;
			_panOriginY = isoView.currentY;
			_isPanning = true;
			isoView.addEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
			_bg.addEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
		}
		
		private function handleMouseEventMouseStop(event:MouseEvent):void{
			_isPanning = false;
			isoView.removeEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
			_bg.removeEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
		}
		
		public function makeGrid(cols:int, rows:int):void {
			//TODO: Refactor this not to do full recreate
			
			if (pathGrid && this.contains(isoView)) {
				if( isoView.getChildAt(1)){
					isoView.removeChildAt(1);
					highlight = null;
				}
				isoView.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseEventMouseWheel);
				isoView.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseEventMouseDown);
				isoView.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMove);
				isoView.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseEventMouseOut);
				isoView.removeEventListener(MouseEvent.CLICK, handleIsoViewMouseEventClick);
				this.removeChild(isoView);
				
				pathGrid = null;
				isoView = null;
				isoScene = null;
			}
			
			pathGrid = new Grid(cols, rows);

			drawGrid();
		}
		
		protected function drawGrid():void {
			isoScene 		= new IsoScene();
			isoView 		= new IsoView();
			isoGrid 		= new IsoGrid();
			highlight	    = new IsoRectangle();
			
			highlight.setSize(cellSize, cellSize, 0);
			highlight.fills = [ new SolidColorFill(0xff0000, 1) ];
			isoScene.addChildAt(highlight,1);
			
			isoGrid.cellSize = cellSize;
			isoGrid.setGridSize(pathGrid.numCols, pathGrid.numRows);
			isoGrid.stroke = new Stroke(1, 0x000000,1);
			isoGrid.showOrigin = false;
			isoScene.addChild(isoGrid);
			
			//Set properties for isoView
			isoView.setSize(760, 760);
			
			//Add the isoScene to the isoView
			isoView.addScene(isoScene);
			isoScene.render();
			
			//Add the isoView to the stage
			this.addChildAt(isoView, 1);
			isoView.panTo( int(pathGrid.numRows * cellSize / 2) ,int(pathGrid.numRows * cellSize / 2) );
			
			//isoView Listeners
			isoView.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseEventMouseWheel);
			isoView.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEventMouseDown);
			isoView.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMove);
			isoView.addEventListener(MouseEvent.MOUSE_OUT, handleMouseEventMouseOut);
			isoView.addEventListener(MouseEvent.CLICK, handleIsoViewMouseEventClick);
		}
		
		private function handleIsoViewMouseEventClick(e:MouseEvent):void{
			trace("CLICK MY FACE:" + e.target.parent);
		}
		
		/*
		protected function onGridItemClick(evt:ProxyEvent):void 
		{
		var box:IsoBox = evt.target as IsoBox;
		
		//Get and set End Nodes (where are we going)
		var xpos:int = (box.x)/cellSize
		var ypos:int = Math.floor(box.y / cellSize)
		pathGrid.setEndNode(xpos,ypos );
		
		//Get and set Start Node (where are we now)
		xpos = Math.floor(playerHelper.x / cellSize);
		ypos = Math.floor(playerHelper.y / cellSize);
		pathGrid.setStartNode(xpos, ypos);
		
		//Find our path
		findPath();
		}
		
		protected function findPath():void {
			var astar:AStar = new AStar();
			var speed:Number = .3;
			if(astar.findPath(pathGrid)) {
				path = astar.path;
			}
			
			for (var i:int = 0; i < path.length; i++) {
				var targetX:Number = path[i].x * cellSize;
				var targetY:Number = path[i].y * cellSize;
				
				Tweener.addTween(playerHelper, { x:targetX, y:targetY, delay:speed * i , time:speed, transition:"linear" } );
			}
		}
		*/
	}
}