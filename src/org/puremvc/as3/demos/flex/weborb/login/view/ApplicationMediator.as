/* 
 PureMVC Flex/WebORB Demo – Login 
 Copyright (c) 2007 Jens Krause <jens.krause@puremvc.org> <www.websector.de>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.demos.flex.weborb.login.view
{
	
	import mx.core.Container;
	
	import org.puremvc.as3.demos.flex.weborb.login.ApplicationFacade;
	import org.puremvc.as3.demos.flex.weborb.login.model.ApplicationProxy;
	import org.puremvc.as3.demos.flex.weborb.login.model.LoginProxy;
	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.mediator.Mediator;
	
	/**
	 * A Mediator for interacting with the top level Application.
	 */
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'ApplicationMediator';

		private var appProxy: ApplicationProxy;
		private var loginProxy: LoginProxy;
					
		/**
		 * Constructor. 
		 * 
		 * @param object the viewComponent (the CodePeek instance in this case)
		 */
		public function ApplicationMediator( viewComponent:Object ) 
		{
			super(viewComponent);
				
			facade.registerMediator(new LoginPanelMediator(app.login));
			facade.registerMediator(new LoggedInBoxMediator(app.loggedIn));
			
			appProxy = ApplicationProxy(facade.retrieveProxy(ApplicationProxy.NAME));
			loginProxy = LoginProxy(facade.retrieveProxy(LoginProxy.NAME));
		}

		/**
		 * Get the Mediator name.
		 * 
		 * @return String the Mediator name
		 */
		override public function getMediatorName():String
		{
			return ApplicationMediator.NAME;
		}

		/**
		 * List all notifications this Mediator is interested in.
		 * 
		 * @return Array the list of Nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			
			return [ 	ApplicationFacade.APP_STARTUP,
						ApplicationFacade.APP_STATE,
						ApplicationFacade.LOGIN_FAILED,
						ApplicationFacade.LOGIN_SUCCES ];
		}

		/**
		 * Handle all notifications this Mediator is interested in.
		 * 
		 * @param INotification a notification 
		 */
		override public function handleNotification( note:INotification ):void 
		{
			switch (note.getName()) 
			{
				case ApplicationFacade.APP_STARTUP:
					appProxy.workflowState = ApplicationProxy.VIEWING_LOGIN_SCREEN;
				break;
				case ApplicationFacade.LOGIN_FAILED:
					appProxy.workflowState = ApplicationProxy.VIEWING_ERROR_SCREEN;
				break;
				case ApplicationFacade.LOGIN_SUCCES:
					appProxy.workflowState = ApplicationProxy.VIEWING_LOGGED_IN_SCREEN;
				break;
				case ApplicationFacade.APP_STATE:
					changeViewState();
				break;
				default:

			}
		}	

		/**
		 * Handles the applications view state based on the workflow state defined in Application Proxy
		 */	
		private function changeViewState():void
		{
			var child: Container;
			
			switch (appProxy.workflowState) 
			{
				case ApplicationProxy.VIEWING_LOGIN_SCREEN:
					child = app.login;
				break;
				case ApplicationProxy.VIEWING_ERROR_SCREEN:
					showError();
					child = app.login;
				break;
				case ApplicationProxy.VIEWING_LOGGED_IN_SCREEN:
					child = app.loggedIn;
				break;
				default:
					child = app.login;
			}			
			
			app.appView.selectedChild = child;
		}

		/**
		 * Shows an error effect on app
		 * @param message
		 */		
	   private function showError():void
	   {
	   		app.faultEffect.end();
	   		app.faultEffect.play();
	   		
	   		appProxy.workflowState = ApplicationProxy.VIEWING_LOGIN_SCREEN;
	   }
		
		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * @return app the viewComponent cast to DemoAS3FlexWebORBLogin
		 */
		protected function get app(): DemoAS3FlexWebORBLogin
		{
			return viewComponent as DemoAS3FlexWebORBLogin;
		}
	}
}