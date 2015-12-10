package com.commands
{
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxyFactory;
	import com.proxy.IConnectionProxy;
	import com.utils.Logger;
	
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
			
			sendNotification(NotificationType.CLASS_STATUS_CHANGE,"正在登录...");
			var body:Object = notification.getBody();
			
			var app:Object = FlexGlobals.topLevelApplication;
			var param:Object = app.parameters;//获取flexvars
			
			var username:String = param.username;
			var password:String = param.password;
			CONFIG::debug{
				username = 'tom';
				password = "123456";
				param.classid = 100001;
				
			}
			ApplicationModelocator.getInstance().classId = uint(param.classid);
			login(username, password, false);
		}
		
		public function login(userName:String, password:String,isMd5:Boolean = true):void{
			//start login now.
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_USER_LOGIN;
			sendObj.username = userName;
			sendObj.password = password;
			
			var proxy:IConnectionProxy = ConnectionProxyFactory.getConnectionProxy();
			Logger.consoleLog("Begin login,username="+userName+" password="+password);
			proxy.sendSignalData(sendObj);
		}
	}
}