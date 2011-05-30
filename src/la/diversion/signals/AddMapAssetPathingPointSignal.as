/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 28, 2011
 *
 */

package la.diversion.signals
{
	import flash.geom.Point;
	
	import la.diversion.models.vo.MapAsset;
	
	import org.osflash.signals.Signal;
	
	public class AddMapAssetPathingPointSignal extends Signal
	{
		public function AddMapAssetPathingPointSignal(...parameters)
		{
			super(MapAsset, Point);
		}
	}
}