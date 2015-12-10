package com.vo
{
	public class Error
	{
		public function Error(msg:String)
		{
			_msg = msg;
		}
		private var _msg:String;

		public function get msg():String
		{
			return _msg;
		}

		public function set msg(value:String):void
		{
			_msg = value;
		}

	}
}