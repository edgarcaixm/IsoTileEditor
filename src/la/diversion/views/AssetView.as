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
	
	import la.diversion.models.vo.MapAsset;
	import la.diversion.views.components.AssetListItem;
	
	import org.bytearray.explorer.SWFExplorer;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class AssetView extends Sprite {
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		
		public const panel_width:int = 343;
		public const panel_height:int = 370;
		
		public const item_width:int = 343;
		public const item_height:int = 40;
		
		private var file:File;
		private var fstream:FileStream;
		
		private var swfLib:SWFExplorer;
		private var swfDefs:Array = new Array();
		
		public var assetHolder:Panel;
		public var assetHolderScroller:ScrollBar;
		public var backgroundHolder:Panel;
		public var backgroundHolderScroller:ScrollBar;
		
		public var mouseEventMouseWheel:NativeSignal;
		
		private var listCount:int = 0;
		private var _assetBeingDragged:MapAsset;
		
		public function AssetView()
		{
			file = new File();
			fstream = new FileStream();
			
			assetHolder = new Panel();
			assetHolder.width = panel_width;
			assetHolder.height = panel_height;
			addChild(assetHolder);
			
			backgroundHolder = new Panel();
			backgroundHolder.width = panel_width;
			backgroundHolder.height = panel_height;
			backgroundHolder.visible = false;
			addChild(backgroundHolder);
			
			mouseEventMouseWheel = new NativeSignal(this, MouseEvent.MOUSE_WHEEL, MouseEvent);
		}
		
		public function initScroller():void {
			assetHolderScroller = new ScrollBar(Slider.VERTICAL, this, 0, 0, onScroll);
			assetHolderScroller.height = panel_height;
			assetHolderScroller.x = panel_width - assetHolderScroller.width;
			assetHolderScroller.autoHide = true;
			assetHolderScroller.setThumbPercent(assetHolder.height / assetHolder.content.height);
			assetHolderScroller.maximum = assetHolder.content.height - assetHolder.height;
			assetHolderScroller.pageSize = assetHolder.height;
			assetHolderScroller.lineSize = item_height;
			addChild(assetHolderScroller);
			
			backgroundHolderScroller = new ScrollBar(Slider.VERTICAL, this, 0, 0, onScroll);
			backgroundHolderScroller.height = panel_height;
			backgroundHolderScroller.x = panel_width - backgroundHolderScroller.width;
			backgroundHolderScroller.autoHide = true;
			backgroundHolderScroller.setThumbPercent(backgroundHolder.height / backgroundHolder.content.height);
			backgroundHolderScroller.maximum = backgroundHolder.content.height - backgroundHolder.height;
			backgroundHolderScroller.pageSize = backgroundHolder.height;
			backgroundHolderScroller.lineSize = item_height;
			addChild(backgroundHolderScroller);
		}
		
		private function onScroll(e:Event):void {
			assetHolder.content.y = -assetHolderScroller.value;
		}
	}
}