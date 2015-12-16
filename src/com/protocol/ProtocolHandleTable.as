package com.protocol
{
	import com.commands.ConnectMediaServer;
	import com.commands.ConnectSignalServerCmd;
	import com.commands.GetClassInfoCmd;
	import com.commands.GetUserInfoCommand;
	import com.commands.LoginCommand;
	import com.commands.SendDataCommand;
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.utils.Logger;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ProtocolHandleTable
	{
		public function ProtocolHandleTable()
		{
		}
		private static var protocolCmdHandleTable:Dictionary;
		public static function getProtocolCmdHandleTabel():Dictionary {
			if (!protocolCmdHandleTable)
				protocolCmdHandleTable = new Dictionary();
			for each(var item:* in cmdHandle) {
				if (!protocolCmdHandleTable.hasOwnProperty(item.cmd))
					protocolCmdHandleTable[item.cmd] = item.handle;
			}
			return protocolCmdHandleTable;
		}
		private static var cmdHandle:Array = [
			{
				//recive lbs connect confrim message,
				//if failure reconnectit ,else ,get auth server config,send CONNECT_MEDIA_SERVER notification to begin connect auth server
				cmd: NetProtocol.CMD_CONNECT_SIGNAL_SERVER,
				handle: function (data:Object):void {
					if (data.ResCode != 0) {
						Logger.consoleLog("connect to signal error,reconnect lbs server " + data.ResCode, Logger.ERROR_LEVEL);
						sendNotification(ConnectSignalServerCmd.BEGIN_CONNECT_SIGNAL_SERVER, data);
						return;
					}
					Logger.consoleLog("connect to signal success,begin connect auth server");
					sendNotification(ConnectMediaServer.CONNECT_MEDIA_SERVER, data)
				}
			},
			{
				//recive as connect mediaserver confrim message, 
				//if failure reconnect it ,if connect ok send a LOGIM_COMMAND notification
				cmd: NetProtocol.CMD_CONNECT_MEDIA_SERVER,
				handle: function (data:Object):void {
					Logger.consoleLog(data.ResCode != 0 ? "media server connect error !" + data.ResCode.toString() : "media server connect success!");
					if (data.ResCode != 0) {
						sendNotification(ConnectMediaServer.CONNECT_MEDIA_SERVER, data);
						return;
					}
					sendNotification(LoginCommand.LOGIM_COMMAND, data);
				}
			},{
				cmd: NetProtocol.CMD_USER_LOGIN,
				handle: function (data:Object):void {
					Logger.consoleLog(data.ResCode != 0 ? "Login error !" + data.ResCode.toString() : "Login ok!");
					if (data.ResCode != 0){
						return;
					}
					//get user id
					var uid:uint = data.uid;
					ApplicationModelocator.getInstance().uid = uid;
					sendNotification(NotificationType.CLASS_STATUS_CHANGE,"登陆成功")
					//get user info
					sendNotification(GetUserInfoCommand.GET_USER_INFO, uid);
					sendNotification(GetClassInfoCmd.GET_CLASS_INFO, ApplicationModelocator.getInstance().classId);
				}
				
			}
		]
			
		private static function sendNotification(name:String, body:Object = null, notificationType:String = null):void {
			Facade.getInstance().sendNotification(name, body, notificationType);
		}
	}
}