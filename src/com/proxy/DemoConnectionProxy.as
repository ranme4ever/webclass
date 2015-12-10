package com.proxy
{
	import com.commands.HandleSocketCommand;
	import com.protocol.NetProtocol;
	
	import flash.utils.setTimeout;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class DemoConnectionProxy implements IConnectionProxy
	{
		public function DemoConnectionProxy()
		{
		}
		
		public function connectSignal(ip:String, ports:Array, responder:IResponder):void
		{
			setTimeout(function():void{responder.result({type:'success'})},Math.random()*2000)
		}
		
		public function connectMedia(ip:String, ports:Array, responder:IResponder):void
		{
			setTimeout(function():void{responder.result({type:'success'})},Math.random()*2000)
		}
		
		public function sendSignalData(data:Object):void
		{
			var sendObj:Object;
			switch(data.cmd)
			{
				case NetProtocol.CMD_CONNECT_SIGNAL_SERVER:
					sendObj = {
						cmd:NetProtocol.CMD_CONNECT_SIGNAL_SERVER,
						ResCode:0,
						ip:'media.server.com',
						port:[80,88]
					}
					serverToClient(sendObj);
					break;
				case NetProtocol.CMD_CONNECT_MEDIA_SERVER://收到媒体服务器链接成功确认请求
					sendObj = {
						cmd:NetProtocol.CMD_CONNECT_MEDIA_SERVER,
						ResCode:0
					}
					serverToClient(sendObj);
					break;
				case NetProtocol.CMD_USER_LOGIN:
					sendObj = {
						cmd:NetProtocol.CMD_USER_LOGIN,
						ResCode:0,
						uid:100001
					}
					serverToClient(sendObj);
					break;
				case NetProtocol.CMD_GET_USER_INFO:
					var sourceid:uint = data.uid;
					sendObj = {
						cmd:NetProtocol.CMD_GET_USER_INFO,
						ResCode:0,
						uid:100001,
						nickName:'tome'
					}
					serverToClient(sendObj);
					break;
				case NetProtocol.CMD_CLASS_SERVER_INFO:
					sendObj = {
						cmd:NetProtocol.CMD_CLASS_SERVER_INFO,
						ResCode:0,
						classid:data.classId,
						courseName:'高一数学',
						courseTime:"2015.11.11 09:00",
						teacherName:'jim',
						teacherId:17771
					}
					serverToClient(sendObj);
					break;
			}
					
		}
		
		private function serverToClient(data:Object):void
		{
			Facade.getInstance().sendNotification(HandleSocketCommand.SOCKET_DATA_COMMOND, data);
		}
				
	}
}