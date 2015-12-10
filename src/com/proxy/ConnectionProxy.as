package com.proxy
{
	import com.protocol.NetProtocol;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;

	public class ConnectionProxy implements IConnectionProxy
	{
		private var _signalService:SocketService
		private var _mediaService:SocketService
		public function ConnectionProxy()
		{
		}
		private function get signalService():SocketService{
			if(!_signalService)
				_signalService = SocketFactory.getSignalSocket();
			return _signalService;
		}
		public function get mediaService():SocketService{
			if(!_mediaService)
				_mediaService = SocketFactory.getMediaConnection();
			return _mediaService;
		}
		public function connectSignal(ip:String,ports:Array,responder:IResponder):void
		{
			signalService.connectSocket(ip,ports,responder);
		}
		
		public function sendSignalData(data:Object):void
		{
			signalService.sendData(data);
		}
		public function stopConnectionTimer():void
		{
			signalService.stopConnectTimer()
		}
		public function connectMedia(ip:String,ports:Array,responder:IResponder):void
		{
			mediaService.connectSocket(ip,ports,responder);
		}
				
	}
}