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
				var tAsset:DisplayObject = new tClass() as DisplayObject;
				
				var tItem:Sprite = new Sprite(); //list item
				// item bg
				tItem.graphics.lineStyle(.5, 0x000000);
				tItem.graphics.beginFill(0xdddddd);
				tItem.graphics.drawRect(0, 0, item_width, item_height);
				tItem.graphics.endFill();
				// generate thumbnail
				var tBmd:BitmapData = new BitmapData(32, 32, true, 0x00000000);
				// since image data can be off stage (positioned less than 0,0)
				// we need to translate and then scale bitmaps using Matrix transforms
				var imgArea:Rectangle = tAsset.getBounds(tAsset); // gets full extent of image even if off stage
				var transform:Matrix = new Matrix(1,0,0,1, -imgArea.x, -imgArea.y);
				// scale and constraint proportions
				var tScaleX:Number = 32/imgArea.width;
				var tScaleY:Number = 32/imgArea.height;
				if (tScaleX > tScaleY) {
					tScaleX = tScaleY;
				} else {
					tScaleY = tScaleX;
				}
				transform.scale(tScaleX, tScaleY);
				
				tBmd.draw(tAsset, transform, null, null, null, true);
				var thumb:Bitmap = new Bitmap(tBmd);
				thumb.name = "thumb";
				thumb.x = thumb.y = 4;
				tItem.addChild(thumb);
				// title
				var itemLabel:Label = new Label(tItem, 40, 5, tLabel);
				itemLabel.name = "label";
				tItem.y = tItem.height * i;
				assetHolder.addChild(tItem);
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