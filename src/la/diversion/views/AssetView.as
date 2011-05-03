/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.views {
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.Slider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import la.diversion.models.components.GameAsset;
	import la.diversion.views.components.AssetListItem;
	
	import org.bytearray.explorer.SWFExplorer;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.osflash.signals.Signal;
	
	public class AssetView extends Sprite {
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		
		public const panel_width:int = 343;
		public const panel_height:int = 320;
		
		public const item_width:int = 343;
		public const item_height:int = 40;
		
		private var file:File;
		private var fstream:FileStream;
		
		private var swfLib:SWFExplorer;
		private var swfDefs:Array = new Array();
		
		public var assetHolder:Panel;
		public var scroller:ScrollBar;
		public var browserBtn:PushButton;
		public var walkableModeBtn:PushButton;
		
		protected var _viewAddNewAsset:Signal;
		protected var _setWalkableModeClicked:Signal;
		
		private var listCount:int = 0;
		private var _assetBeingDragged:GameAsset;
		
		public function AssetView()
		{
			file = new File();
			fstream = new FileStream();
			
			assetHolder = new Panel();
			assetHolder.width = panel_width;
			assetHolder.height = panel_height - 40;
			addChild(assetHolder);
			
			browserBtn = new PushButton();
			browserBtn.x = 10;
			browserBtn.y = panel_height - 30;
			browserBtn.label = "Load Asset Library";
			browserBtn.addEventListener(MouseEvent.CLICK, onBrowseFilesystem);
			addChild(browserBtn);
			
			walkableModeBtn = new PushButton();
			walkableModeBtn.x = 150;
			walkableModeBtn.y = panel_height - 30;
			walkableModeBtn.label = "Set Walkable";
			walkableModeBtn.addEventListener(MouseEvent.CLICK, onWalkableModeBtnClick);
			addChild(walkableModeBtn);
		}
		
		public function get viewAddNewAsset():Signal{
			return _viewAddNewAsset ||= new Signal();
		}
		
		public function get setWalkableModeClicked():Signal{
			return _setWalkableModeClicked ||= new Signal();
		}
		
		private function onWalkableModeBtnClick(event:MouseEvent):void{
			setWalkableModeClicked.dispatch();
		}
		
		public function initScroller():void {
			if(scroller){
				removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			scroller = new ScrollBar(Slider.VERTICAL, this, 0, 0, onScroll);
			scroller.height = panel_height - 40;
			scroller.x = panel_width - scroller.width;
			scroller.autoHide = true;
			scroller.setThumbPercent(assetHolder.height / assetHolder.content.height);
			scroller.maximum = assetHolder.content.height - assetHolder.height;
			scroller.pageSize = assetHolder.height;
			scroller.lineSize = item_height;
			addChild(scroller);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onBrowseFilesystem(e:MouseEvent):void {
			file.addEventListener(Event.SELECT, onFileSelected);
			file.browse();
		}
		
		private function onFileSelected(e:Event):void {
			swfLib = new SWFExplorer();
			swfLib.addEventListener (SWFExplorerEvent.COMPLETE, onAssetsReady);
			swfLib.load(new URLRequest(file.url));
			
		}
		
		private function onAssetsReady(e:SWFExplorerEvent):void {
			swfDefs = e.target.getDefinitions();
			var swfLoader:Loader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
			swfLoader.load(new URLRequest(file.url));
		}
		
		private function onSWFLoadComplete(e:Event):void {
			// populate panel content with items
			
			//TODO - Move this out of the view!			
			for (var i:int=0; i<swfDefs.length; i++) {
				// asset info
				var tClass:Class = e.target.applicationDomain.getDefinition(swfDefs[i]) as Class;
				var gameAsset:GameAsset = new GameAsset(swfDefs[i],tClass,1,1);
				viewAddNewAsset.dispatch(gameAsset);
			}
		}
		
		private function onScroll(e:Event):void {
			assetHolder.content.y = -scroller.value;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			if (assetHolder.content.height > assetHolder.height) {
				scroller.value = scroller.value - (e.delta * 4);
			}
		}
	}
}