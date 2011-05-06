/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: chris
 * Created: Apr 26, 2011
 *
 */

package la.diversion.models {
	
	import com.adobe.serialization.json.DiversionJSON;
	import com.adobe.serialization.json.JSON;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import la.diversion.enums.IsoSceneViewModes;
	import la.diversion.models.components.AssetManager;
	import la.diversion.models.components.GameAsset;
	import la.diversion.models.components.Tile;
	import la.diversion.signals.AssetAddedToSceneSignal;
	import la.diversion.signals.AssetRemovedFromSceneSignal;
	import la.diversion.signals.AssetViewModeUpdatedSignal;
	import la.diversion.signals.SceneGridSizeUpdatedSignal;
	import la.diversion.signals.TileWalkableUpdatedSignal;
	
	import org.robotlegs.mvcs.Actor;

	/**
	 * This is the Model class for a Scene and can be used
	 * to serialize to/from JSON format.
	 */
	public class SceneModel extends Actor{
		
		[Transient]
		[Inject]
		public var assetViewModeUpdated:AssetViewModeUpdatedSignal;
		
		[Transient]
		[Inject]
		public var assetRemovedFromScene:AssetRemovedFromSceneSignal;
		
		[Transient]
		[Inject]
		public var tileWalkableUpdated:TileWalkableUpdatedSignal;
		
		[Transient]
		[Inject]
		public var assetAddedToScene:AssetAddedToSceneSignal;
		
		[Transient]
		[Inject]
		public var sceneGridSizeUpdated:SceneGridSizeUpdatedSignal;
		
		private var _cellSize:int = 64;
		private var _numRows:int = 0;
		private var _numCols:int = 0;
		private var _position:Point = new Point(0, 0);
		private var _zoomLevel:Number = 0;
		private var _assetBeingDragged:GameAsset;
		private var _assetManager:AssetManager = new AssetManager();
		private var _viewMode:String;
		private var _grid:Array;
		
		public function SceneModel(json:String = null) {
			super();
			
			// Default Grid Size
			//setGridSize(40, 40);
			
			// Default Mode
			_viewMode = IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS;
			
			if (json) {
				this.fromJSON(json);
			}
		}
		
		[Transient]
		public function get assetBeingDragged():GameAsset
		{
			return _assetBeingDragged;
		}

		public function set assetBeingDragged(value:GameAsset):void
		{
			_assetBeingDragged = value;
		}

		/**
		 * loads data from a JSON formated representation.
		 *
		 * @param1 json A JSON formated string.
		 *
		 * @see toJSON
		 */
		public function fromJSON(json:String):void {
			var obj:Object = JSON.decode(json);
			this._cellSize = obj.map.cellSize;
			this._numCols = obj.map.numCols;
			this._numRows = obj.map.numRows;
			this._zoomLevel = obj.zoomLevel;
			this.position = new Point(obj.position.x, obj.position.y);
			
			setGridSize(_numCols, _numRows);
			
			var jsonGrid:Array = obj.grid;
			
			var tile1:Tile;
			var tile2:Object;
			for (var i:int = 0; i < jsonGrid.length; i++) {
				for (var j:int = 0; j < jsonGrid[i].length; j++) {
					tile1 = _grid[i][j];
					tile2 = jsonGrid[i][j];
					_grid[i][j].isWalkable = jsonGrid[i][j].isWalkable;
				}
			}
		}
		
		/**
		 * Returns the current viewMode
		 * 
		 * @return view mode String
		 * 
		 */
		[Transient]
		public function get viewMode():String
		{
			return _viewMode;
		}
		
		/**
		 * Sets the current view mode and dispatches a signal
		 * 
		 * @param view mode
		 *
		 */
		public function set viewMode(value:String):void
		{
			//trace("SceneModel viewMode=" + value);
			switch(value){
				case IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS:
					_viewMode = value;
					for each(var paAsset:GameAsset in this.assetManager.assets){
						paAsset.container.alpha = 1;
					}
					assetViewModeUpdated.dispatch(_viewMode);
					break;
				case IsoSceneViewModes.VIEW_MODE_SET_WALKABLE_TILES:
					_viewMode = value;
					for each(var swtAsset:GameAsset in this.assetManager.assets){
						swtAsset.container.alpha = 0.5;
					}
					assetViewModeUpdated.dispatch(_viewMode);
					break;
			}
		}
		
		/**
		 * Add an asset 
		 * 
		 * @param GameAsset
		 * 
		 */
		public function addAsset(asset:GameAsset):void{
			if(viewMode == IsoSceneViewModes.VIEW_MODE_PLACE_ASSETS){
				asset.container.alpha = 1;
			}else{
				asset.container.alpha = .5;
			}
			_assetManager.addAsset(asset);
			assetAddedToScene.dispatch(asset);
		}
		
		/**
		 * Retreive an asset by assetId
		 * 
		 * @param assetId String
		 * @return GameAsset
		 * 
		 */
		public function getAsset(assetId:String):GameAsset{
			return _assetManager.getAsset(assetId);
		}
		
		/**
		 * Delete an asset
		 * 
		 * @param assetId String
		 * 
		 */
		public function removeAsset(assetId:String):void{
			if(_assetManager.getAsset(assetId)){
				assetRemovedFromScene.dispatch(_assetManager.getAsset(assetId));
				_assetManager.removeAsset(assetId);
			}
		}
		
		/**
		 * Returns the dictionary of all game assets
		 * 
		 * @return Dictionary of game assets
		 * 
		 */
		public function get assetManager():AssetManager{
			return _assetManager;
		}
		
		
		/**
		 * Gets the number of grid rows in the scene.
		 *
		 * @return Number of rows.
		 *
		 */
		public function get numRows():int {
			return _numRows;
		}
		
		/**
		 * Sets the size of all the grid cells.
		 *
		 * @param size Size of cell in pixels.
		 *
		 */
		public function set cellSize(size:int):void {
			this._cellSize = size;
		}
		
		/**
		 * Gets the cell size in pixels.
		 *
		 * @return Size of grid cells.
		 *
		 */
		public function get cellSize():int {
			return _cellSize;
		}
		
		/**
		 * Sets the number of grid rows in the scene.
		 *
		 * @param numRows Number of rows.
		 *
		 */
		public function set numRows(numRows:int):void {
			setGridSize(_numCols, numRows);
		}
		
		/**
		 * Gets the number of grid columns in the scene.
		 *
		 * @return Number of columns.
		 *
		 */
		public function get numCols():int {
			return _numCols;
		}
		
		/**
		 * Sets the number of grid columns in the scene.
		 *
		 * @param numCols Number of columns.
		 *
		 */
		public function set numCols(numCols:int):void {
			setGridSize(numCols, _numRows);
		}
		
		/**
		 * Gets the positon of the grid in the scene.
		 *
		 * @return Grid position.
		 *
		 */
		public function get position():Point {
			return _position;
		}
		
		/**
		 * Sets the position of the grid in the scene.
		 *
		 * @param position The position of the grid.
		 *
		 */
		public function set position(position:Point):void {
			this._position = position;
		}
		
		/**
		 * Gets the zoom level of the grid.
		 *
		 * @return Zoom level.
		 *
		 */
		public function get zoomLevel():Number {
			return _zoomLevel;
		}
		
		/**
		 * Sets the zoom level of the grid.
		 *
		 * @param zoomLevel The zoom level of the grid.
		 *
		 */
		public function set zoomLevel(zoomLevel:Number):void {
			this._zoomLevel = zoomLevel;
		}
		
		/**
		 * Gets the current grid array.
		 *
		 * @return Grid Array.
		 *
		 */
		[Transient]
		public function get grid():Array {
			return _grid;
		}
		
		/**
		 * Gets and array of the tiles where isWalkable = false
		 * 
		 * @return Array of tiles
		 */
		public function get unwalkableGridTiles():Array{
			var result:Array = new Array();
			for (var i:int = 0; i < _grid.length; i++) {
				for (var j:int = 0; j < _grid[i].length; j++) {
					if (!_grid[i][j].isWalkable) {
						result.push(_grid[i][j]);
					}
				}
			}
			return result;
		}
		
		/**
		 * Gets a specific tile in the current grid array
		 * 
		 * @return Tile
		 * 
		 */
		public function getTile(col:int, row:int):Tile{
			if(_grid[col][row]){
				return _grid[col][row];
			}
			return null;
		}
		
		// Creates the grid arrays and adds a Tile object
		// to each one.
		public function setGridSize(cols:int, rows:int):void {
			_numCols = cols;
			_numRows = rows;
			_grid = new Array(cols);
			for (var i:int = 0; i < cols; i++) {
				_grid[i] = new Array(rows);
				for (var j:int = 0; j < rows;  j++) {
					var newTile:Tile = new Tile(i,j,_cellSize);
					newTile.walkableUpdated.add(handleTileWalkableUpdated);
					_grid[i][j] = newTile;
				}
			}
			sceneGridSizeUpdated.dispatch();
		}
		
		private function handleTileWalkableUpdated(tile:Tile):void{
			tileWalkableUpdated.dispatch(tile);
		}
	}
}