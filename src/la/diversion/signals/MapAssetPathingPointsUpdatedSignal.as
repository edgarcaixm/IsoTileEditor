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
	import org.osflash.signals.Signal;
	
	import la.diversion.models.vo.MapAsset;
	
	public class MapAssetPathingPointsUpdatedSignal extends Signal
	{
		public function MapAssetPathingPointsUpdatedSignal(...parameters)
		{
			super(MapAsset);
		}
	}
}