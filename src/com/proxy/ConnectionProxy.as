package com.proxy
{
	import com.protocol.NetProtocol;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;

	public class ConnectionProxy
	{
		private var ConnectionService:SocketService
		public function ConnectionProxy()
		{
		}
		private function get connectionService():SocketService{
			if(!ConnectionService)
				ConnectionService = SocketFactory.getLbsSocket();
			return ConnectionService;
		}
		public function connectServer(ip:String,ports:Array,responder:IResponder):void
		{
			connectionService.connectSocket(ip,ports,responder);
		}
		public function login(userName:String, password:String,isMd5:Boolean = true):void{
			if (userName.length == 0 || password.length == 0)
				return ConnectionService.destory();
			//start login now.
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_USER_LOGIN;
			sendObj.username = userName;
			sendObj.ExternPassword = password;
			
			Logger.consoleLog("Begin login,username="+userName+" password="+password);
			connectionService.sendData(sendObj);
		}
		public function sendData(data:Object):void
		{
			connectionService.sendData(data);
		}
		public function stopConnectionTimer():void
		{
			connectionService.stopConnectTimer()
		}
	}
}