package com.proxy
{
	import com.protocol.NetProtocol;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;

	public class ConnectionProxy
	{
		private var _connectionService:SocketService
		private var _mediaService:SocketService
		public function ConnectionProxy()
		{
		}
		private function get connectionService():SocketService{
			if(!_connectionService)
				_connectionService = SocketFactory.getLbsSocket();
			return _connectionService;
		}
		public function get mediaService():SocketService{
			if(!_mediaService)
				_mediaService = SocketFactory.getMediaConnection();
			return _mediaService;
		}
		public function connectServer(ip:String,ports:Array,responder:IResponder):void
		{
			connectionService.connectSocket(ip,ports,responder);
		}
		public function login(userName:String, password:String,isMd5:Boolean = true):void{
			if (userName.length == 0 || password.length == 0)
				return _connectionService.destory();
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
		public function connectMediaServer(ip:String,ports:Array,responder:IResponder):void
		{
			mediaService.connectSocket(ip,ports,responder);
		}
				
	}
}