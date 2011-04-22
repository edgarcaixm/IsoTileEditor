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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AssetViewComponent extends Sprite {
		
		private const panel_width:int = 344;
		private const panel_height:int = 320;
		
		private const item_width:int = 344;
		private const item_height:int = 40;
		
		private var assetHolder:Panel;
		private var scroller:ScrollBar;
		private var browserBtn:PushButton;
		
		public function AssetViewComponent() {
			// create UI components
			assetHolder = new Panel();
			assetHolder.width = panel_width;
			assetHolder.height = panel_height - 40;
			addChild(assetHolder);
			
			// populate panel content with items
			for (var i:int; i<20; i++) {
				// generate list items
				var tItem:Sprite = new Sprite();
				// bg
				tItem.graphics.lineStyle(.5, 0x000000);
				tItem.graphics.beginFill(0xaaaaaa);
				tItem.graphics.drawRect(0, 0, item_width, item_height);
				tItem.graphics.endFill();
				// thumbnail
				var bmd:BitmapData = new BitmapData(32, 32, false, 0x0000ff);
				var thumb:Bitmap = new Bitmap(bmd);
				thumb.name = "thumbBmp";
				thumb.x = thumb.y = 4;
				tItem.addChild(thumb);
				// title
				var itemLabel:Label = new Label(tItem, 40, 5, "Asset"+i);
				itemLabel.name = "label";
				tItem.y = tItem.height * i;
				assetHolder.addChild(tItem);
			}
			
			scroller = new ScrollBar(Slider.VERTICAL, this, 0, 0, onScroll);
			scroller.height = panel_height - 40;
			scroller.x = panel_width - scroller.width;
			scroller.autoHide = false;
			scroller.setThumbPercent(assetHolder.height / assetHolder.content.height);
			scroller.maximum = assetHolder.content.height - assetHolder.height;
			scroller.pageSize = assetHolder.height;
			scroller.lineSize = item_height;
			addChild(scroller);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			browserBtn = new PushButton();
			browserBtn.x = 10;
			browserBtn.y = panel_height - 30;
			browserBtn.label = "Load Asset Library";
			addChild(browserBtn);
		}
		
		private function onScroll(e:Event):void {
			assetHolder.content.y = -scroller.value;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			scroller.value = scroller.value - (e.delta * 4);
		}
	}
}