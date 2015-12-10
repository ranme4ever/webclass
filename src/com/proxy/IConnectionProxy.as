package com.proxy
{
	import mx.rpc.IResponder;

	public interface IConnectionProxy
	{
		
		function connectSignal(ip:String,ports:Array,responder:IResponder):void
		function sendSignalData(data:Object):void
		function connectMedia(ip:String,ports:Array,responder:IResponder):void
	}
	
}