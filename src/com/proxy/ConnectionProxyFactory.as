package com.proxy
{
	public class ConnectionProxyFactory
	{
		public function ConnectionProxyFactory()
		{
		}
		public static function getConnectionProxy():IConnectionProxy
		{
			CONFIG::debug{
				return new DemoConnectionProxy();
			}
				return new ConnectionProxy();
		}
	}
}