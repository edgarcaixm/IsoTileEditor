/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 29, 2011
 *
 */

package la.diversion.signals
{
	import flash.geom.Point;
	
	import la.diversion.models.vo.MapAsset;
	
	import org.osflash.signals.Signal;
	
	public class RemoveMapAssetPathingPointSignal extends Signal
	{
		public function RemoveMapAssetPathingPointSignal(...parameters)
		{
			super(MapAsset, Point);
		}
	}
}