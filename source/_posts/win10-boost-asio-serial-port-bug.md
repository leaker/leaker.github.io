title: Windows10 下 boost::asio::serial_port 的 BUG
date: 2015-10-10 15:49:44
tags:
  - win10
  - boost
  - asio
  - serial_port
categories: programing
---
在最近写一些串口操作的程序时使用了 **boost::asio::serial_port** 来操作串口
但当尝试打开串口的时候出现了错误。下面是我的测试代码：
```cpp
boost::asio::io_service _io_service;
const std::string devname = "COM3";
try
{
	boost::asio::serial_port serial(_io_service);
	serial.open(devname);// throw error every times.
	if (serial.is_open()) {
		std::cout << devname << " serial open successed." << std::endl;
	}
	else {
		std::cout << devname << " serial open failed!" << std::endl;
	}
}
catch (const std::exception& ex)
{
	std::cout << ex.what() << std::endl;// GetLastError() == 87
}
```

每次都会出现错误87。即 GetLastError() 的结果为 87
于是跟进代码里面调试追到了 *win_iocp_serial_port_service::open* 函数里

**win_iocp_serial_port_service::open** 函数的实现如下：
```cpp
boost::system::error_code win_iocp_serial_port_service::open(
	win_iocp_serial_port_service::implementation_type& impl,
	const std::string& device, boost::system::error_code& ec)
{
	if (is_open(impl))
	{
		ec = boost::asio::error::already_open;
		return ec;
	}

	std::string name = (device[0] == '\\') ? device : "\\\\.\\" + device;

	::HANDLE handle = ::CreateFileA(name.c_str(),
		GENERIC_READ | GENERIC_WRITE, 0, 0,
		OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
	if (handle == INVALID_HANDLE_VALUE)
	{
		DWORD last_error = ::GetLastError();
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	using namespace std;
	::DCB dcb;
	memset(&dcb, 0, sizeof(DCB));
	dcb.DCBlength = sizeof(DCB);
	if (!::GetCommState(handle, &dcb))
	{
		DWORD last_error = ::GetLastError();
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	dcb.fBinary = TRUE;
	dcb.fDsrSensitivity = FALSE;
	dcb.fNull = FALSE;
	dcb.fAbortOnError = FALSE;

	if (!::SetCommState(handle, &dcb))
	{
		DWORD last_error = ::GetLastError();// lee: error is here!!!
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	::COMMTIMEOUTS timeouts;
	timeouts.ReadIntervalTimeout = 1;
	timeouts.ReadTotalTimeoutMultiplier = 0;
	timeouts.ReadTotalTimeoutConstant = 0;
	timeouts.WriteTotalTimeoutMultiplier = 0;
	timeouts.WriteTotalTimeoutConstant = 0;
	if (!::SetCommTimeouts(handle, &timeouts))
	{
		DWORD last_error = ::GetLastError();
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	if (handle_service_.assign(impl, handle, ec))
		::CloseHandle(handle);
	return ec;
}
```
发现每次在第一次 SetCommState 的时候总是会报错并离开。
于是查看了前面通过 GetCommState 获取到的 dcb 的值。
发现 dcb.BaudRate == 0 时无法 SetCommState 成功
也就是说在有些设备中获取不到 dcb.BaudRate 这个值。

# 下面是我自己的解决办法
在 win_iocp_serial_port_service.ipp 文件的88行左右添加
```cpp
if (dcb.BaudRate == 0) dcb.BaudRate = 115200;
```

修改后的 win_iocp_serial_port_service::open 函数完整代码如下：
```cpp
boost::system::error_code win_iocp_serial_port_service::open(
	win_iocp_serial_port_service::implementation_type& impl,
	const std::string& device, boost::system::error_code& ec)
{
	if (is_open(impl))
	{
		ec = boost::asio::error::already_open;
		return ec;
	}

	std::string name = (device[0] == '\\') ? device : "\\\\.\\" + device;

	::HANDLE handle = ::CreateFileA(name.c_str(),
		GENERIC_READ | GENERIC_WRITE, 0, 0,
		OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
	if (handle == INVALID_HANDLE_VALUE)
	{
		DWORD last_error = ::GetLastError();
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	using namespace std;
	::DCB dcb;
	memset(&dcb, 0, sizeof(DCB));
	dcb.DCBlength = sizeof(DCB);
	if (!::GetCommState(handle, &dcb))
	{
		DWORD last_error = ::GetLastError();
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	dcb.fBinary = TRUE;
	dcb.fDsrSensitivity = FALSE;
	dcb.fNull = FALSE;
	dcb.fAbortOnError = FALSE;
	if (dcb.BaudRate == 0) dcb.BaudRate = 115200; // add lee 2015.10.10. 解决dcb.BaudRate为0时无法成功SetCommState的BUG
	if (!::SetCommState(handle, &dcb))
	{
		DWORD last_error = ::GetLastError();
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	::COMMTIMEOUTS timeouts;
	timeouts.ReadIntervalTimeout = 1;
	timeouts.ReadTotalTimeoutMultiplier = 0;
	timeouts.ReadTotalTimeoutConstant = 0;
	timeouts.WriteTotalTimeoutMultiplier = 0;
	timeouts.WriteTotalTimeoutConstant = 0;
	if (!::SetCommTimeouts(handle, &timeouts))
	{
		DWORD last_error = ::GetLastError();
		::CloseHandle(handle);
		ec = boost::system::error_code(last_error,
			boost::asio::error::get_system_category());
		return ec;
	}

	if (handle_service_.assign(impl, handle, ec))
		::CloseHandle(handle);
	return ec;
}
```

# 测试环境
| 说明   | 参数                   |
| :------ | :---------------------- |
| 操作系统 | Windows10 专业版 x64 |
| 开发环境 | Microsoft Visual Studio Community 2013 Version 12.0.40629.00 Update 5 |
| Boost版本 | boost_1.59.0 |

# 结束语
以上只是自己的猜测，并不一定是完全正确的。如有任何错误，请联系并告诉我。我将尽快修改，不胜感激。
