package com.commands
{
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxy;
	import com.utils.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class GetUserInfoCommand extends SimpleCommand
	{
		public static const GET_USER_INFO:String="getUserInfo";
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			var body:Object = notification.getBody();
			switch (notification.getName()) {
				case GET_USER_INFO:
					//login success .begin connect media server
					var uid:uint = body as uint;
					facade.sendNotification(GetMediaServerInfoCmd.GET_MEDIA_SERVER_INFO, uid);
					getUserInfo(uid);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_GET_USER_INFO:
					Logger.consoleLog("user info got");
					ApplicationModelocator.getInstance().nickName = body.nickName;
					break;
			}
		}
		
		public function getUserInfo(uid:uint):void
		{
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_GET_USER_INFO;
			sendObj.sourceID = uid;
			Facade.getInstance().registerCommand(NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_GET_USER_INFO, GetUserInfoCommand);
			new ConnectionProxy().sendData(sendObj);
		}
		public function GetUserInfoCommand()
		{
			super();
			
		}
	}
}