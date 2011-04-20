package la.diversion
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPrimitive;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.graphics.SolidColorFill;
	
	import caurina.transitions.Tweener;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LevelViewComponent extends Sprite
	{
		protected var cellSize:int = 50;
		protected var pathGrid:Grid;
		protected var playerHelper:IsoPrimitive;
		protected var path:Array;
		protected var isoSprite:IsoSprite;
		protected var isoView:IsoView;
		protected var isoScene:IsoScene;
		
		public function LevelViewComponent()
		{
			super();
			
			makeGrid(40,40);
		}
		
		public function makeGrid(cols:int, rows:int):void{
			pathGrid = new Grid(cols, rows);
			
			for(var i:int = 0; i < 20; i++)
			{
				pathGrid.setWalkable(Math.floor(Math.random() * 8) + 2,
					Math.floor(Math.random() * 8)+ 2,
					false);
			}
			drawGrid();
		}
		
		protected function drawGrid():void
		{
			isoScene 		= new IsoScene();
			playerHelper	= new IsoPrimitive();
			isoSprite 		= new IsoSprite();
			isoView 		= new IsoView();
			
			for(var i:int = 0; i < pathGrid.numCols; i++)
			{
				for(var j:int = 0; j < pathGrid.numRows; j++)
				{
					var node:Node = pathGrid.getNode(i, j);
					var box:IsoBox = new IsoBox();
					
					if (node.walkable)
					{
						box.setSize(cellSize, cellSize, 0);
						box.addEventListener(MouseEvent.CLICK, onGridItemClick);
						box.fills = [
							new SolidColorFill(0x00ff00, .5)
						];
					}
					else
					{
						box.setSize(cellSize, cellSize, 0);
						box.addEventListener(MouseEvent.CLICK, onGridItemClick);
						box.fills = [
							new SolidColorFill(0xff0000, .5)
						];
					}
					
					box.moveTo(i * cellSize, j * cellSize, 0);
					isoScene.addChild(box);
				}
			}
			
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
			this.addChild(isoView);
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
		
		protected function findPath():void
		{
			var astar:AStar = new AStar();
			var speed:Number = .3;
			if(astar.findPath(pathGrid))
			{
				path = astar.path;
			}
			
			for (var i:int = 0; i < path.length; i++)
			{
				var targetX:Number = path[i].x * cellSize;
				var targetY:Number = path[i].y * cellSize;
				
				Tweener.addTween(playerHelper, { x:targetX, y:targetY, delay:speed * i , time:speed, transition:"linear" } );
			}
		}
	}
}