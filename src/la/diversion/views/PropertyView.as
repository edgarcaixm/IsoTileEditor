/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 2, 2011
 *
 */

package la.diversion.views {
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class PropertyView extends Sprite {
		
		public var totalCellsWide:InputText;
		public var totalCellsHigh:InputText;
		
		public var totalCellsWideSignal:NativeSignal;
		public var totalCellsHighSignal:NativeSignal;
		
		public function PropertyView()
		{
			super();
			
			var label1:Label = new Label();
			label1.x = 48;
			label1.y = 40;
			label1.text = "Total Cells Wide:";
			this.addChild(label1);
			
			var label2:Label = new Label();
			label2.x = 48;
			label2.y = 69;
			label2.text = "Total Cells High:";
			this.addChild(label2);
			
			totalCellsWide = new InputText();
			totalCellsWide.x = 146;
			totalCellsWide.y = 34;
			totalCellsWide.height = 20;
			totalCellsWide.width = 38;
			this.addChild(totalCellsWide);
			
			totalCellsHigh = new InputText();
			totalCellsHigh.x = 146;
			totalCellsHigh.y = 63;
			totalCellsHigh.height = 20;
			totalCellsHigh.width = 38;
			this.addChild(totalCellsHigh);
			
			totalCellsWideSignal = new NativeSignal(totalCellsWide, Event.CHANGE, Event);
			totalCellsHighSignal = new NativeSignal(totalCellsHigh, Event.CHANGE, Event);
			
		}
	}
}