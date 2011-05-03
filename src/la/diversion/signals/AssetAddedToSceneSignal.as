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
	
	import la.diversion.models.components.GameAsset;
	
	public class AssetAddedToSceneSignal extends Signal {
		public function AssetAddedToSceneSignal(...parameters)
		{
			super(GameAsset);
		}
	}
}