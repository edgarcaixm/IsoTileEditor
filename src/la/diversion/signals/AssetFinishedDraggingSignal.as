/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 30, 2011
 *
 */

package la.diversion.signals {
	import org.osflash.signals.Signal;
	
	import la.diversion.models.vo.MapAsset;
	import flash.events.MouseEvent;
	
	public class AssetFinishedDraggingSignal extends Signal {
		public function AssetFinishedDraggingSignal(...parameters)
		{
			super(MapAsset, MouseEvent);
		}
	}
}