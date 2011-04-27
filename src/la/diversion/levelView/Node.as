package la.diversion.levelView
{
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.graphics.SolidColorFill;

	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;
		public var tile:IsoRectangle;
		
		private var _walkable:Boolean = true;
		
		public function Node(x:int, y:int, cellSize:Number)	{
			this.x = x;
			this.y = y;
			
			this.tile = new IsoRectangle();
			this.tile.setSize(cellSize, cellSize, 0);
			this.tile.moveTo(x * cellSize, y * cellSize, 0);
			this.tile.fills = [ new SolidColorFill(0xFF0000,.75) ];
		}

		public function get walkable():Boolean
		{
			return _walkable;
		}

		public function set walkable(value:Boolean):void
		{
			_walkable = value;
		}

	}
}