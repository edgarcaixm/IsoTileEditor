package la.diversion.levelView
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPrimitive;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import caurina.transitions.Tweener;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class LevelViewComponent extends Sprite {
		protected var cellSize:int = 50;
		protected var pathGrid:Grid;
		protected var playerHelper:IsoPrimitive;
		protected var path:Array;
		protected var isoSprite:IsoSprite;
		protected var isoView:IsoView;
		protected var isoScene:IsoScene;
		protected var isoGrid:IsoGrid;
		protected var highlight:IsoBox;
		protected var zoomFactor:Number = 1;
		
		private var _isPanning:Boolean = false;
		private var _panX:Number = 0;
		private var _panY:Number = 0;
		private var _panOriginX:Number = 0;
		private var _panOriginY:Number = 0;
		
		public function LevelViewComponent(){
			super();
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x00FFFF);
			bg.graphics.drawRect(0,0,760,760);
			bg.graphics.endFill();
			bg.x = 3;
			bg.y = 3;
			this.addChild(bg);
			
			
			makeGrid(40,40);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseEventMouseWheel);
			this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEventMouseDown);
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
			this.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
			this.addEventListener(MouseEvent.ROLL_OUT, handleMouseEventMouseStop);
		}
		
		private function handleMouseEventMouseStop(event:MouseEvent):void{
			_isPanning = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, handleMouseEventMouseStop);
			this.removeEventListener(MouseEvent.ROLL_OUT, handleMouseEventMouseStop);
		}
		
		private function handleMouseEventMouseMove(event:MouseEvent):void{
			if(_isPanning){			
				isoView.panTo(_panOriginX - (event.stageX - _panX), _panOriginY - (event.stageY - _panY));
			}

		}
		
		private function handleMouseEventMouseMoveOnGrid(e:ProxyEvent):void{
			var event:MouseEvent = e.targetEvent as MouseEvent;
			if (isoGrid){
				var isoPt:Pt = IsoMath.screenToIso(new Pt(event.localX, event.localY));
				var col:Number = Math.floor(isoPt.x / cellSize);
				if (col < 0)
				{
					return;
				}
				var row:Number = Math.floor(isoPt.y / cellSize);
				if (row < 0)
				{
					return;
				}
				
				highlight.moveTo(col * cellSize,row * cellSize,0);
				highlight.fills = [	new SolidColorFill(0x000000, .5) ];
				isoScene.render();
			}
		}
		
		private function handleMouseEventMouseClickOnGrid(e:ProxyEvent):void{
			var event:MouseEvent = e.targetEvent as MouseEvent;
			var isoPt:Pt = IsoMath.screenToIso(new Pt(event.localX, event.localY));
			var col:Number = Math.floor(isoPt.x / cellSize);
			if (col < 0)
			{
				return;
			}
			var row:Number = Math.floor(isoPt.y / cellSize);
			if (row < 0)
			{
				return;
			}
			
			trace("CLICK AT row=" + row + ", col=" + col);
		}
		
		public function makeGrid(cols:int, rows:int):void {
			//TODO: Refactor this not to do full recreate
			
			if (pathGrid && this.contains(isoView)) {
				if( isoView.getChildAt(1)){
					isoView.removeChildAt(1);
					highlight = null;
				}
				this.removeChild(isoView);
				isoGrid.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMoveOnGrid);
				isoGrid.removeEventListener(MouseEvent.CLICK, handleMouseEventMouseClickOnGrid);
				
				pathGrid = null;
				isoView = null;
				isoSprite = null;
				isoScene = null;
			}
			
			pathGrid = new Grid(cols, rows);

			drawGrid();
		}
		
		protected function drawGrid():void {
			isoScene 		= new IsoScene();
			playerHelper	= new IsoPrimitive();
			isoSprite 		= new IsoSprite();
			isoView 		= new IsoView();
			isoGrid 		= new IsoGrid();
			highlight	    = new IsoBox();
			
			highlight.setSize(cellSize, cellSize, 0);
			highlight.fills = [ ];
			isoScene.addChildAt(highlight,1);
			//.addChild(highlight);
			
			isoGrid.cellSize = cellSize;
			isoGrid.setGridSize(pathGrid.numCols, pathGrid.numRows);
			isoGrid.stroke = new Stroke(1, 0x000000,1);
			isoGrid.showOrigin = false;
			isoScene.addChild(isoGrid);
			
			isoGrid.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseEventMouseMoveOnGrid);
			isoGrid.addEventListener(MouseEvent.CLICK, handleMouseEventMouseClickOnGrid);
			//Set properties for player helper
			playerHelper.setSize(cellSize, cellSize, 10);
			
			//Set properties for isoView
			isoView.setSize(760, 760);
			
			//Add the isoSprite and playerHelper to the isoScene
			isoScene.addChild(isoSprite);
			isoScene.addChild(playerHelper);
			
			//Add the isoScene to the isoView
			isoView.addScene(isoScene);
			
			isoScene.render();
			
			//Add the isoView to the stage
			isoView.x = 3;
			isoView.y = 3;
			this.addChild(isoView);
			isoView.panTo( int(pathGrid.numRows * cellSize / 2) ,int(pathGrid.numRows * cellSize / 2) );
		}
		
		protected function onGridItemClick(event:ProxyEvent):void{
			var box:IsoBox = event.target as IsoBox;
			
			trace("Box Click at x:" + box.x + ", y:" + box.y);
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
		*/
		
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
	}
}