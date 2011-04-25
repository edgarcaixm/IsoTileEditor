/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: Ryan Hunt
 * Created: Apr 21, 2011
 *
 */

package la.diversion.assetView {
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
	
	import la.diversion.GameAsset;
	import la.diversion.AssetManager;
	
	import org.bytearray.explorer.SWFExplorer;
	import org.bytearray.explorer.events.SWFExplorerEvent;

	public class AssetViewComponent extends Sprite {
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		
		private const panel_width:int = 343;
		private const panel_height:int = 320;
		
		private const item_width:int = 343;
		private const item_height:int = 40;
		
		private var file:File;
		private var fstream:FileStream;
		
		private var swfLib:SWFExplorer;
		private var swfDefs:Array = new Array();
		
		private var assetHolder:Panel;
		private var scroller:ScrollBar;
		private var browserBtn:PushButton;
		
		public function AssetViewComponent() {
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
		}
		
		private function initScroller():void {
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
			for (var i:int=0; i<swfDefs.length; i++) {
				// asset info
				var tLabel:String = swfDefs[i];
				var tClass:Class = e.target.applicationDomain.getDefinition(tLabel) as Class;
				var gameAsset:GameAsset = new GameAsset(swfDefs[i],tClass,1,1);
				AssetManager.addAsset(gameAsset);
				var listItem:AssetViewComponentListItem = new AssetViewComponentListItem(gameAsset, item_width, item_height, swfDefs[i]);
				listItem.y = item_height * i;
				assetHolder.addChild(listItem);
			}
			initScroller();
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