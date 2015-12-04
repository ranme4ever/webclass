package com.commands
{
	import com.model.ApplicationModelocator;
	import com.proxy.ConnectionProxy;
	
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoginCommand extends SimpleCommand
	{
		public static const LOGIM_COMMAND:String = "loginCommand";
		public function LoginCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			var body:Object = notification.getBody();
			var app:Object = FlexGlobals.topLevelApplication;
			var param:Object = app.parameters;//获取flexvars
			
			var username:String = param.username;
			ApplicationModelocator.getInstance().classId = uint(param.classid);
			var password:String = param.password;
			
			var ba:ByteArray = new ByteArray;
			
			new ConnectionProxy().login(username, password, false);
		}
		
	}
}