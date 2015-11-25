package com.proxy
{
	import mx.rpc.IResponder;

	public class ConnectionProxy
	{
		private var _lbsConnection:SocketService
		public function ConnectionProxy()
		{
		}
		private function get lbsConnection():SocketService{
			if(!_lbsConnection)
				_lbsConnection = SocketFactory.getLbsSocket();
			return _lbsConnection;
		}
		public function connectLbsServer(ip:String,ports:Array,responder:IResponder):void
		{
			lbsConnection.connectSocket(ip,ports,responder);
		}
	}
}