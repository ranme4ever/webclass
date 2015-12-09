package com.vo
{
	import flash.utils.ByteArray;

	public class PacketStream 
	{
		private var buf:ByteArray = new ByteArray();
		public function PacketStream()
		{
		}
		public function push(ba:ByteArray):void  
		{  
			if(buf == null)  
			{  
				buf = ba;  
			}else  
			{  
				buf.position = buf.length;  
				buf.writeBytes(ba);  
			}  
		} 
		public function getPackets():Array  
		{  
			var ps:Array = [];  
			buf.position = 0;  
			while(buf.bytesAvailable >= MsgPacket.HEADER_LENGTH)  //这里是说当可用数据大于包头时，一个包==包头(body的长度)+包体(body)，也就是说包里如果一旦有数据就开始执行  
			{
				var tag:String = buf.readMultiByte(3,MsgPacket.HEADER_TAG_CHARSET);
				var version:int = buf.readByte();
				var cmd:uint = buf.readUnsignedInt();
				var bodyLength:uint = buf.readUnsignedInt();
				//不足一个包
				if(buf.bytesAvailable < bodyLength)  
				{  
					buf.position -= MsgPacket.HEADER_LENGTH;
					break;
				}
				
				var body:ByteArray = new ByteArray();  
				buf.readBytes(body, 0, bodyLength);   //len为body的长度，将body的数据放入mb  
				body.position = 0;  
				var msg:MsgPacket = new MsgPacket();
				msg.writePacket(cmd,body);
				ps.push(msg);  //放入数组  
			}
			if(buf.position > 0){
				var tmp:ByteArray = new ByteArray();
				buf.readBytes(tmp);
				buf = tmp;
			}
			return ps; 
		}  
		
	}
}