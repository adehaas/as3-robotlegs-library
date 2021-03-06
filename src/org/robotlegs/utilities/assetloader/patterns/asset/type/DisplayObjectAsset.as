package org.robotlegs.utilities.assetloader.patterns.asset.type
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	
	import org.robotlegs.utilities.assetloader.patterns.asset.Asset;
	import flash.system.LoaderContext;

	/**
	 * Automatic assigned type of <code>Asset</code> for loading <code>Bitmaps</code> (swf).
	 * 
	 * @author r.moorman
	 */
	public class DisplayObjectAsset extends Asset
	{
		/**
		 * @iheritDoc
		 */
		override public function set url( value: String ): void {
			super.url = value;
			
			_loader = new Loader;
 		}
		
		/**
		 * The loaded <code>DisplayObject</code>.
		 */
		public function get displayObject(): DisplayObject {
			return _displayObject;
		}
		
		/**
		 * @private
		 */
		private var _displayObject: DisplayObject;
		
		/**
		 * @iheritDoc
		 */
		public function DisplayObjectAsset( id: String, url: String, loaderContext: LoaderContext = null )
		{
			super( id, url, loaderContext );
		}
		
		/**
		 * @iheritDoc
		 */
		override protected function onComplete( evt: Event ): void
		{
			super.onComplete( evt );
			
			_displayObject = evt.target.content as DisplayObject;
		}
	}
}