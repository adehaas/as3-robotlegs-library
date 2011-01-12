package org.robotlegs.utilities.navigator.core
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.utilities.navigator.error.NavigatorError;
	import org.robotlegs.utilities.navigator.events.NavigatorEvent;
	import org.robotlegs.utilities.navigator.patterns.page.IPage;
	import org.robotlegs.utilities.navigator.patterns.transition.ITransition;

	/**
	 * Abstract <code>Navigator</code> implementation.
	 * 
	 * @author r.moorman
	 */
	public class Navigator extends Actor implements INavigator
	{
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.transitioning
		 */
		public function get transitioning(): Boolean {
			return _navigating;
		}

		/**
		 * @private
		 */
		public function set transitioning( value: Boolean ): void {
			_navigating = value;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.currentPage 
		 */
		public function get currentPage(): IPage {
			return _currentPage;
		}
		
		/**
		 * @private
		 */
		public function set currentPage( value: IPage ): void {
			_currentPage = value;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.choosenPage 
		 */
		public function get choosenPage(): IPage {
			return _choosenPage;
		}
		
		/**
		 * @private
		 */
		public function set choosenPage( value: IPage ): void {
			_choosenPage = value;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.defaultTransition
		 */
		public function get defaultTransition(): ITransition {
			return _defaultTransition;
		}
		
		/**
		 * @private
		 */
		public function set defaultTransition( value: ITransition ): void {
			_defaultTransition = value;
		}
		
		/**
		 * @private
		 */
		private var _navigating: Boolean;
		
		/**
		 * @private
		 */
		private var _currentPage: IPage;
		
		/**
		 * @private
		 */
		private var _choosenPage: IPage;
		
		/**
		 * @private
		 */
		private var _defaultTransition: ITransition;
		
		/**
		 * @private
		 */
		private var _pageMap: Dictionary;
		
		/**
		 * @private
		 */
		private var _transitionMap: Dictionary;
		
		/**
		 * @private
		 */
		private var _transitionMapByPageName: Dictionary;
		
		/**
		 * Constructor.
		 */
		public function Navigator()
		{
			super();
			
			_navigating = false;
			_pageMap = new Dictionary;
			_transitionMap = new Dictionary;
			_transitionMapByPageName = new Dictionary;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.addPage()
		 */
		public function addPage( page: IPage, transitionId: String = null ): void
		{
			if( !hasPage( page.name )) {
				if( page is IEventDispatcher )
					_pageMap[ page.name ] = page;
				else
					throw new NavigatorError( 'Page is not of type IEventDispatcher!' ); 
			}
			else
				throw new NavigatorError( 'Page already added under the name ' + page.name + '!' );
			
			if( transitionId )
				_transitionMapByPageName[ page.name ] = transitionId;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.hasPage()
		 */
		public function hasPage( name: String ): Boolean
		{
			return _pageMap[ name ] != null;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.getPage()
		 */
		public function getPage( name: String ): IPage
		{
			return _pageMap[ name ];
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.removePage()
		 */
		public function removePage( name: String ): IPage
		{
			var page: IPage;
			
			if( hasPage( name )) {
				page = getPage( name );
				
				_transitionMapByPageName[ name ] = null;
			}
			
			_pageMap[ name ] = null;
			
			return page;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.addTransition()
		 */
		public function addTransition( id: String, transition: ITransition, isDefaultTransition: Boolean = false ): void
		{
			if( !hasTransition( id )) {
				_transitionMap[ id ] = transition;
			}
			else
				throw new NavigatorError( 'Transition already added under the id ' + id + '!' );
			
			if( isDefaultTransition )
				_defaultTransition = transition;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.hasTransition()
		 */
		public function hasTransition( id: String ): Boolean
		{
			return _transitionMap[ id ] != null;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.getTransition()
		 */
		public function getTransition( id: String ): ITransition
		{
			return _transitionMap[ id ];
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.removeTransition()
		 */
		public function removeTransition( id: String ): ITransition
		{
			var transition: ITransition;
			
			if( hasTransition( id ))
				transition = getTransition( id );
			
			_transitionMap[ id ] = null;
			
			return transition;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.hasTransitionByPageName()
		 */
		public function hasTransitionByPageName( name: String ): Boolean
		{
			return _transitionMap[ _transitionMapByPageName[ name ]] != null;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.getTransitionByPageName()
		 */
		public function getTransitionByPageName( name: String ): ITransition
		{
			return _transitionMap[ _transitionMapByPageName[ name ]] as ITransition;
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.removeTransitionByPageName()
		 */
		public function removeTransitionByPageName( name: String ): ITransition
		{
			return removeTransition( _transitionMapByPageName[ name ]);
		}
		
		/**
		 * @copy org.robotlegs.utilities.navigator.core.INavigator.navigate()
		 */
		public function navigate( name: String ): Boolean
		{
			if( hasPage( name ) && !_navigating ) {
				var page: IPage = getPage( name );
				
				dispatch( new NavigatorEvent( NavigatorEvent.NAVIGATE, page ));
				
				return true;
			}
			else
				return false;
		}
	}
}