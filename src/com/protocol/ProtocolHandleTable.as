package com.protocol
{
	import com.commands.ConnectAuthServer;
	import com.commands.ConnectLbsServerCmd;
	import com.commands.ConnectMediaServer;
	import com.commands.GetUserInfoCommand;
	import com.commands.SendDataCommand;
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
				cmd: NetProtocol.CMD_CONNECT_LBS_SERVER,
				handle: function (data:Object):void {
					if (data.ResCode != 0) {
						Logger.consoleLog("connect to LBS error,reconnect lbs server " + data.ResCode, Logger.ERROR_LEVEL);
						sendNotification(ConnectLbsServerCmd.BEGIN_CONNECT_LBS_SERVER, data);
						return;
					}
					Logger.consoleLog("connect to LBS success,begin connect auth server");
					sendNotification(ConnectMediaServer.CONNECT_MEDIA_SERVER, data)
				}
			},
			{
				//recive as connect authserver confrim message, 
				//if failure reconnect it ,if connect ok send a RECIEVE_AS_SERVER_CONNECT_CONFRIM notification
				cmd: NetProtocol.CMD_CONNECT_AUTH_SERVER,
				handle: function (data:Object):void {
					Logger.consoleLog(data.ResCode != 0 ? "AS server connect error !" + data.ResCode.toString() : "AS server connect success!");
					if (data.ResCode != 0) {
						sendNotification(ConnectAuthServer.CONNECT_AUTH_SERVER, data);
						return;
					}
					sendNotification(ConnectAuthServer.RECIEVE_AUTH_SERVER_CONNECT_CONFRIM, data)
				}
			},{
				cmd: NetProtocol.CMD_USER_LOGIN,
				handle: function (data:Object):void {
					Logger.consoleLog(data.ResCode != 0 ? "Login error !" + data.ResCode.toString() : "Login ok!");
					if (data.ResCode != 0)
						return;
					//get user id or other user info 
					var UID:uint = data.UID;
					ApplicationModelocator.getInstance().UID = UID;
					
					//notify before login complete.
					sendNotification(GetUserInfoCommand.GET_USER_INFO, UID);
					//notify server, login ok.
					var sendObj:Object = {
						cmd: NetProtocol.CMD_LOGIN_SUCCESS,
						sourceID: UID
					};
					sendNotification(SendDataCommand.SEND_DATA_COMMAND, sendObj);
				}
				
			}
		]
			
		private static function sendNotification(name:String, body:Object = null, notificationType:String = null):void {
			Facade.getInstance().sendNotification(name, body, notificationType);
		}
	}
}